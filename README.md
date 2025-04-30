# Dotfiles

A comprehensive dotfiles configuration for macOS and Linux systems. This repository includes a powerful setup script that automates the installation and configuration of development tools and environments.

## Features

### 🚀 Cross-Platform Support
- Complete support for both macOS and Linux systems
- Intelligent package management (Homebrew/apt/pacman)
- Platform-specific optimizations and configurations
- XDG Base Directory compliant configuration management

### 💻 Development Environment
- Shell: Zsh with Oh-My-Zsh and Powerlevel10k theme
- Editor: Vim/MacVim with curated modern plugins
- Terminal: tmux with optimized configurations
- Git: Comprehensive configurations and global ignore patterns

### 🛠 Programming Languages
- Python: Data science packages and development tools
- Node.js: Essential development tools and packages
- Go: Complete development environment with LSP support
- Rust: Nightly toolchain and rust-analyzer
- C/C++: Full development environment setup

### 🖥 GUI Applications
- Terminal Emulators: Alacritty (cross-platform), iTerm2 (macOS)
- Development Tools: Visual Studio Code with extensions
- Window Management: Rectangle (macOS)
- Input Methods: fcitx5 (Linux)

## Quick Start

### One-Line Installation (Recommended)
```bash
# Install all components (default)
curl -fsSL https://raw.githubusercontent.com/loyalpartner/dotfiles/master/install.sh | bash

# Install specific components only
curl -fsSL https://raw.githubusercontent.com/loyalpartner/dotfiles/master/install.sh | bash -s -- configs
```

### Manual Installation
1. Clone the Repository:
   ```bash
   git clone https://github.com/loyalpartner/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Run the Setup Script:
   ```bash
   # Full installation (recommended for new systems)
   ./setup.sh all

   # Install specific components:
   ./setup.sh basic     # Essential CLI tools
   ./setup.sh gui       # GUI applications
   ./setup.sh program   # Programming languages
   ./setup.sh vim       # Vim setup with plugins
   ./setup.sh configs   # All configuration files
   ```

### Component Selection
```bash
# Install individual components
./setup.sh basic      # Core development tools
./setup.sh gui        # GUI applications
./setup.sh program    # Programming environments
./setup.sh vim        # Vim/MacVim configuration
./setup.sh configs    # Configuration files only
```

## Configuration

### Directory Structure
```
~/.config/dotfiles/        # XDG configuration directory
├── setup.conf            # Main configuration file
├── zsh/                 # Zsh configurations
├── vim/                 # Vim configurations
└── ...                 # Other configurations

~/.local/state/dotfiles/  # Application state
├── logs/                # Installation logs
└── backups/            # Configuration backups

~/.local/cache/dotfiles/ # Cache directory
└── downloads/          # Downloaded packages
```

### Configuration File
Configure the setup script through `~/.config/dotfiles/setup.conf`:

```bash
# Debugging Options
DEBUG_ENABLE=0          # Enable debug mode
VERBOSE=0               # Verbose output

# Installation Settings
DRY_RUN=0              # Preview changes without applying
FORCE_INSTALL=0         # Override existing files

# Component Selection
INSTALL_BASIC=true      # Core CLI tools
INSTALL_GUI=false       # GUI applications
INSTALL_PROGRAMMING=true # Development environments
INSTALL_CONFIGS=true    # Configuration files
```

### Command Line Options
```bash
Usage: setup.sh [OPTIONS] COMMAND

Commands:
    all         Full installation (recommended)
    basic       Core development tools
    gui         GUI applications
    program     Programming environments
    vim         Vim/MacVim setup
    configs     Configuration files only

Options:
    -h, --help      Display help information
    -v, --verbose   Enable detailed output
    -f, --force     Force file overwrites
    -n, --dry-run   Preview changes
    --config FILE   Use custom config file
```

## Detailed Features

### Configuration Management
- XDG Base Directory Specification compliant
- Automatic backup of existing configurations
- Modular dotfiles installation
- Support for Essential Tools:
  * Shell: Zsh with advanced configuration
  * Terminals: Alacritty, Foot (Linux)
  * Development: ctags, gdb, ripgrep
  * Window Management: sway (Linux)
  * Application Launcher: rofi (Linux)

### Core Environment
- Essential Development Tools
  * Version Control: Git with global config
  * Terminal Multiplexer: tmux with optimizations
  * Shell Utilities: fd, bat, exa
  * System Monitors: htop, btop
- Platform-Specific Optimizations
  * macOS: Homebrew optimization
  * Linux: System tuning

### Development Environment
Comprehensive setup for:
- Python Development
  * Core: Python 3.x with pip
  * Data Science: numpy, pandas, jupyter
  * Development: black, flake8, mypy
- Node.js Environment
  * Runtime: Latest LTS version
  * Package Managers: npm, yarn, pnpm
  * Global Tools: typescript, eslint
- Go Development
  * Latest stable Go version
  * Essential tools: gopls, golangci-lint
  * Development utilities
- Rust Toolchain
  * Nightly with cargo
  * LSP: rust-analyzer
  * Tools: clippy, rustfmt
- C/C++ Development
  * Compilers: gcc/clang
  * Build Tools: cmake, make
  * Debug: gdb/lldb

### Platform-Specific Features

#### macOS Environment
- Terminal Emulation
  * Alacritty: Modern GPU-accelerated
  * iTerm2: Feature-rich terminal
- Development Tools
  * Visual Studio Code with extensions
  * Xcode Command Line Tools
- System Utilities
  * Rectangle: Window management
  * Homebrew: Package management
- Fonts & Themes
  * JetBrains Mono Nerd Font
  * Custom color schemes

#### Linux Environment
- Core Components
  * Alacritty terminal
  * fcitx5 input method
  * sway window manager
- System Tools
  * Network management
  * Power management
  * Audio controls
- Development Tools
  * Build essentials
  * Development libraries
  * System headers

## Customization

### Local Configurations
- Shell Customization
  * Create `~/.zshrc.local` for machine-specific settings
  * Add custom functions to `~/.zsh/functions/`
  * Modify prompt in `~/.p10k.zsh`
- Vim/NeoVim Setup
  * Add plugins in `~/.vim/custom/plugins.vim`
  * Custom settings in `~/.vim/custom/settings.vim`
  * Key mappings in `~/.vim/custom/mappings.vim`
- Git Configuration
  * User settings in `~/.gitconfig.local`
  * Custom ignore patterns in `~/.gitignore_global`
  * SSH configuration in `~/.ssh/config`

### Extending the Setup
The modular setup script is designed for easy extension:
1. Add new setup functions in `setup.sh`
2. Define installation steps in `scripts/install/`
3. Add verification in `scripts/verify/`
4. Include configuration in `configs/`

## Maintenance

### System Logs
- Location: `~/.local/state/dotfiles/logs/`
- Retention: Latest 5 log files kept
- Rotation: Weekly with compression
- Format: Detailed timestamp and operation logs

### System Updates
- Automatic Updates
  * Package manager refresh
  * Tool version checks
  * Configuration validation
- Safe Operations
  * Idempotent installation
  * Backup before changes
  * Rollback capability

### Health Checks
- Package Verification
- Configuration Testing
- Dependency Validation
- System Compatibility

## Troubleshooting

### Common Issues

1. **Package Manager Setup**
   ```bash
   # macOS: Install Xcode Command Line Tools
   xcode-select --install

   # Linux: Update package lists
   sudo apt update      # Debian/Ubuntu
   sudo pacman -Sy     # Arch Linux
   ```

2. **Font Installation**
   ```bash
   # macOS
   brew tap homebrew/cask-fonts
   brew install --cask font-jetbrains-mono-nerd-font

   # Linux
   # Arch Linux
   sudo pacman -S ttf-jetbrains-mono-nerd
   # Ubuntu/Debian
   sudo apt install fonts-jetbrains-mono
   ```

3. **Permission Problems**
   ```bash
   # Fix common permission issues
   sudo chown -R $(whoami) ~/.config
   sudo chown -R $(whoami) ~/.local
   
   # Fix SSH directory permissions
   chmod 700 ~/.ssh
   chmod 600 ~/.ssh/config
   ```

4. **Shell Integration**
   ```bash
   # Reload shell configuration
   source ~/.zshrc
   
   # Verify shell version
   zsh --version
   ```

### Diagnostic Tools

1. Verbose Installation
   ```bash
   # Enable detailed output
   ./setup.sh -v all
   
   # Debug specific component
   DEBUG_ENABLE=1 ./setup.sh vim
   ```

2. Log Analysis
   ```bash
   # View recent logs
   tail -f ~/.local/state/dotfiles/logs/setup_latest.log
   
   # Search for errors
   grep "ERROR" ~/.local/state/dotfiles/logs/setup_*.log
   ```

3. System Checks
   ```bash
   # Verify dependencies
   ./setup.sh --check-deps
   
   # Test configuration
   ./setup.sh --test-config
   ```

## Contributing

### Getting Started
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Make your changes
4. Run tests (`./tests/run.sh`)
5. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
6. Push to the branch (`git push origin feature/AmazingFeature`)
7. Open a Pull Request

### Development Guidelines
- Follow the existing code style
- Add tests for new features
- Update documentation
- Keep commits atomic and descriptive

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Various dotfiles communities](https://dotfiles.github.io/).