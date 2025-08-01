# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a comprehensive dotfiles repository for configuring development environments on macOS and Linux systems. It provides automated installation and configuration of development tools, shell environments, window managers, and programming language toolchains.

## Key Commands

### Installation and Setup
```bash
# Full installation (recommended for new systems)
./setup.sh all

# Install specific components
./setup.sh basic      # Core development tools
./setup.sh gui        # GUI applications  
./setup.sh program    # Programming environments
./setup.sh vim        # Vim/MacVim configuration
./setup.sh configs    # Configuration files only

# One-line remote installation
curl -fsSL https://raw.githubusercontent.com/loyalpartner/dotfiles/master/install.sh | bash
```

### Development Commands
Since this is a dotfiles repository, there are no traditional build/test commands. However, when modifying the setup scripts:

```bash
# Dry run to preview changes
./setup.sh -n all

# Verbose mode for debugging
./setup.sh -v basic

# Check installation logs
tail -f ~/.local/state/dotfiles/logs/setup_latest.log
```

## Architecture Overview

### Core Structure
The repository follows a modular architecture with clear separation of concerns:

1. **Installation Layer** (`setup.sh`, `install.sh`)
   - Main entry points for system configuration
   - Handles cross-platform compatibility (macOS/Linux)
   - Manages package installation via Homebrew/apt/pacman
   - Implements XDG Base Directory compliance

2. **Configuration Layer** (`configs/`)
   - Organized by application/tool
   - Each tool has its own subdirectory with modular config files
   - Notable configurations:
     - `sway/`: Wayland compositor with modular config includes
     - `vim/`: Extensive Vim configuration with plugin management
     - `zsh/`: Shell configuration with platform-specific files
     - `rofi/`: Application launcher with Incus integration

3. **Utilities Layer** (`bin/`)
   - Custom scripts and utilities
   - Platform-agnostic helper tools

### Key Design Patterns

1. **Modular Configuration**: Sway config demonstrates best practice with includes:
   ```
   configs/sway/config.d/
   ├── appearance/    # Visual settings
   ├── bindings/      # Key bindings
   ├── devices/       # Input/output configs
   ├── rules/         # Window rules
   └── system/        # System-level configs
   ```

2. **Platform Detection**: Scripts detect OS and package manager automatically
   - macOS: Uses Homebrew
   - Linux: Detects apt (Debian/Ubuntu) or pacman (Arch)

3. **State Management**: 
   - Configs: `~/.config/dotfiles/`
   - Logs: `~/.local/state/dotfiles/logs/`
   - Cache: `~/.local/cache/dotfiles/`

4. **Backup Strategy**: Existing configurations are backed up before modification

### Important Implementation Notes

1. **Vim Configuration**:
   - Uses vim-plug for plugin management
   - Extensive plugin list with custom local plugins from `~/vim-dev/`
   - CoC.nvim for LSP support

2. **Shell Environment**:
   - Zsh with Oh-My-Zsh and Powerlevel10k
   - Platform-specific configurations (`.zshrc.linux.zsh`, `.zshrc.local.zsh`)

3. **Window Management** (Linux):
   - Sway as the Wayland compositor
   - Waybar for status bar
   - Rofi for application launching with custom Incus integration

4. **Development Tools**:
   - Comprehensive programming language support (Python, Node.js, Go, Rust, C/C++)
   - Each language includes toolchain and common development utilities

When working with this codebase:
- Respect the modular structure when adding new configurations
- Follow XDG Base Directory specifications
- Maintain cross-platform compatibility in scripts
- Test changes with dry-run mode before applying