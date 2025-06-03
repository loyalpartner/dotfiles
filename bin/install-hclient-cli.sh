#!/usr/bin/env bash
#
# hclient-cli Installation Script
# ===============================
#
# This script downloads and installs the latest hclient-cli binary from Gitee
# and configures it as a systemd service for automatic startup.
#
# Usage:
#   sudo ./install-hclient-cli.sh
#
# Requirements:
#   - Linux system with systemd
#   - Root privileges (use sudo)
#   - curl or wget
#

set -euo pipefail

# Global variables
readonly GITEE_RELEASES_URL="https://gitee.com/lazycatcloud/hclient-cli/releases"
readonly INSTALL_DIR="/usr/local/bin"
readonly SERVICE_FILE="/etc/systemd/system/hclient-cli.service"
readonly BINARY_NAME="hclient-cli"
readonly SERVICE_NAME="hclient-cli"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Output functions
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root. Please use sudo."
        exit 1
    fi
}

# Detect platform and architecture
detect_platform() {
    local os arch

    os=$(uname -s)
    if [[ "$os" != "Linux" ]]; then
        error "This script only supports Linux systems"
        exit 1
    fi

    arch=$(uname -m)
    case "$arch" in
        x86_64)
            ARCH="amd64"
            ;;
        aarch64|arm64)
            ARCH="arm64"
            ;;
        *)
            error "Unsupported architecture: $arch"
            exit 1
            ;;
    esac

    DOWNLOAD_FILENAME="hclient-cli-linux-${ARCH}"
    info "Detected platform: Linux-${ARCH}"
}

# Get latest version from Gitee releases
get_latest_version() {
    info "Fetching latest version information..."

    # Try to get the latest release page
    local releases_page
    if command -v curl >/dev/null 2>&1; then
        releases_page=$(curl -s "$GITEE_RELEASES_URL" || true)
    elif command -v wget >/dev/null 2>&1; then
        releases_page=$(wget -qO- "$GITEE_RELEASES_URL" || true)
    else
        error "Neither curl nor wget is available"
        exit 1
    fi

    if [[ -z "$releases_page" ]]; then
        error "Failed to fetch releases page"
        exit 1
    fi

    # Extract the first version tag (latest)
    VERSION=$(echo "$releases_page" | grep -o 'releases/tag/[^"]*' | head -1 | sed 's/releases\/tag\///' || true)

    if [[ -z "$VERSION" ]]; then
        error "Failed to extract version information"
        exit 1
    fi

    DOWNLOAD_URL="https://gitee.com/lazycatcloud/hclient-cli/releases/download/${VERSION}/${DOWNLOAD_FILENAME}"
    success "Latest version: $VERSION"
}

# Download and install binary
install_binary() {
    local temp_dir temp_file

    info "Downloading hclient-cli binary..."

    # Create temporary directory
    temp_dir=$(mktemp -d)
    temp_file="${temp_dir}/${DOWNLOAD_FILENAME}"

    # Download binary
    if command -v curl >/dev/null 2>&1; then
        if ! curl -L -o "$temp_file" "$DOWNLOAD_URL"; then
            error "Failed to download binary"
            rm -rf "$temp_dir"
            exit 1
        fi
    elif command -v wget >/dev/null 2>&1; then
        if ! wget -O "$temp_file" "$DOWNLOAD_URL"; then
            error "Failed to download binary"
            rm -rf "$temp_dir"
            exit 1
        fi
    fi

    # Verify download
    if [[ ! -f "$temp_file" ]] || [[ ! -s "$temp_file" ]]; then
        error "Downloaded file is empty or does not exist"
        rm -rf "$temp_dir"
        exit 1
    fi

    # Install binary
    info "Installing binary to $INSTALL_DIR/$BINARY_NAME..."

    # Stop service if it's running
    if systemctl is-active --quiet "$SERVICE_NAME" 2>/dev/null; then
        warning "Stopping existing service..."
        systemctl stop "$SERVICE_NAME"
    fi

    # Install binary
    cp "$temp_file" "$INSTALL_DIR/$BINARY_NAME"
    chmod 755 "$INSTALL_DIR/$BINARY_NAME"

    # Verify installation
    if [[ ! -x "$INSTALL_DIR/$BINARY_NAME" ]]; then
        error "Failed to install binary"
        rm -rf "$temp_dir"
        exit 1
    fi

    # Cleanup
    rm -rf "$temp_dir"
    success "Binary installed successfully"
}

# Create systemd service
create_service() {
    info "Creating systemd service..."

    cat > "$SERVICE_FILE" << EOF
[Unit]
Description=Lazy Cat Cloud VPN Client
After=network.target
Wants=network.target

[Service]
Type=simple
User=root
ExecStart=$INSTALL_DIR/$BINARY_NAME -tun
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

    # Reload systemd and enable service
    systemctl daemon-reload
    systemctl enable --now "$SERVICE_NAME"

    success "Systemd service created and enabled"
}

# Cleanup function
cleanup() {
    if [[ -n "${temp_dir:-}" ]] && [[ -d "$temp_dir" ]]; then
        rm -rf "$temp_dir"
    fi
}

# Main installation function
main() {
    info "Starting hclient-cli installation..."

    # Set up cleanup trap
    trap cleanup EXIT

    # Check prerequisites
    check_root
    detect_platform

    # Install process
    get_latest_version
    install_binary
    create_service

    success "Installation completed successfully!"
    echo
    info "hclient-cli has been installed and configured as a systemd service."
    info "To start the service: systemctl start $SERVICE_NAME"
    info "To check status: systemctl status $SERVICE_NAME"
    info "To view logs: journalctl -u $SERVICE_NAME -f"
    echo
    warning "The service is enabled for automatic startup but not started."
    warning "Please start it manually when ready: sudo systemctl start $SERVICE_NAME"
}

# Run main function
main "$@"
