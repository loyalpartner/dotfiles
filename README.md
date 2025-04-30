# Dotfiles

My personal dotfiles for macOS and Linux systems. Features a powerful setup script that automates the installation and configuration of development tools and environments.

## Features

### 🚀 Cross-Platform Support
- Full support for both macOS and Linux
- Smart package management (Homebrew/apt/pacman)
- Platform-specific optimizations and configurations
- Flexible configuration file management with XDG compliance

### 💻 Development Environment
- Shell: Zsh with Oh-My-Zsh and Powerlevel10k
- Editor: Vim/MacVim with modern plugins
- Terminal: tmux with custom configurations
- Git configurations and global ignore patterns

### 🛠 Programming Languages
- Python with common data science packages
- Node.js with essential development tools
- Go with development tools and LSP support
- Rust with nightly toolchain and rust-analyzer
- C/C++ development environment

### 🖥 GUI Applications
- Terminal emulators (Alacritty, iTerm2 on macOS)
- Development tools (VS Code)
- Window management (Rectangle on macOS)
- Input methods (fcitx5 on Linux)

## Quick Start

### One-Line Install
```bash
# Install everything (default)
curl -fsSL https://raw.githubusercontent.com/loyalpartner/dotfiles/master/install.sh | bash

# Or install specific components
curl -fsSL https://raw.githubusercontent.com/loyalpartner/dotfiles/master/install.sh | bash -s -- configs
```

### Manual Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/loyalpartner/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Run the setup script:
   ```bash
   # Install everything (recommended for new systems)
   ./setup.sh all

   # Or choose specific components:
   ./setup.sh basic      # Basic CLI tools
   ./setup.sh gui        # GUI applications
   ./setup.sh program    # Programming languages
   ./setup.sh vim        # Vim configuration and plugins
   ./setup.sh configs    # Install all configuration files
   
   # You can also install specific configurations:
   ./setup.sh configs    # Install all configs
   ./setup.sh vim       # Install only vim config
   ```

## Configuration

### Directory Structure
```
~/.config/dotfiles/        # XDG config directory
├── setup.conf            # Setup configuration
└── ...

~/.local/state/dotfiles/  # Application state
├── logs/                # Log files
└── ...

~/.local/cache/dotfiles/ # Cache directory
└── ...
```

### Configuration File
The setup script can be configured via `~/.config/dotfiles/setup.conf`:

```bash
# Debug and logging
DEBUG_ENABLE=0
VERBOSE=0

# Installation behavior
DRY_RUN=0
FORCE_INSTALL=0

# Component selection
INSTALL_BASIC=true
INSTALL_GUI=false
INSTALL_PROGRAMMING=false
INSTALL_CONFIGS=true      # Install configuration files
```

### Command Line Options
```bash
Usage: setup.sh [OPTIONS] COMMAND

Commands:
    all         Install everything
    basic       Install basic development tools
    gui         Install GUI applications
    program     Install programming languages
    vim         Configure Vim editor
    configs     Install configuration files only

Options:
    -h, --help     Show help message
    -v, --verbose  Enable verbose output
    -f, --force    Force installation
    -n, --dry-run  Show what would be done
    --config FILE  Use custom config file
```

## Features in Detail

### Configuration Management
- XDG Base Directory compliant
- Automated backup of existing configurations
- Optional installation of dotfiles
- Supports common tools and applications:
  * Shell configurations (zsh)
  * Terminal emulators (alacritty, foot)
  * Development tools (ctags, gdb)
  * Window managers (sway)
  * Application launchers (rofi)

### Basic Environment
- Core utilities and shell tools
- Git with global configuration
- tmux with custom configuration
- System-specific optimizations

### Programming Environment
Installs and configures:
- Python (with pip and common packages)
- Node.js (with npm, yarn, and global packages)
- Go (with common development tools)
- Rust (with cargo and components)
- C/C++ development tools

### GUI Environment
Installation varies by platform:

#### macOS
- Alacritty
- iTerm2
- Visual Studio Code
- Rectangle
- JetBrains Mono Nerd Font

#### Linux
- Alacritty
- fcitx5 input method
- Various GUI utilities

## Customization

### Local Configurations
- Shell: Create `~/.zshrc.local` for machine-specific settings
- Vim: Add custom configurations in `~/.vim/custom/`
- Git: Configure user information in `~/.gitconfig.local`

### Adding New Tools
The setup script is modular and easy to extend. Add new tools by:
1. Creating a new setup function in `setup.sh`
2. Adding the tool to the appropriate installation list
3. Adding verification steps in the `verify_installation` function

## Maintenance

### Logs
- Log files are stored in `~/.local/state/dotfiles/logs/`
- Logs are automatically rotated (keeps last 5)
- Old logs (>7 days) are compressed

### Updates
- The script checks for package updates
- Updates package managers when needed
- Can be run multiple times safely

## Troubleshooting

### Common Issues

1. **Homebrew Installation Fails**
   ```bash
   # Check system requirements
   xcode-select --install
   ```

2. **Font Issues**
   ```bash
   # Install fonts manually
   brew tap homebrew/cask-fonts
   brew install --cask font-jetbrains-mono-nerd-font
   ```

3. **Permission Issues**
   ```bash
   # Fix directory permissions
   sudo chown -R $(whoami) ~/.config
   ```

### Debug Mode
Run with verbose output:
```bash
./setup.sh -v basic
```

Check logs:
```bash
cat ~/.local/state/dotfiles/logs/setup_*.log
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.