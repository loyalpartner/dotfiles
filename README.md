# Dotfiles

A thoughtfully crafted dotfiles collection for a powerful development environment. This repository contains my personal configuration files for Zsh, Vim/Neovim, Tmux, and more, optimized for both GUI and CLI environments.

## Features

### 🚀 Shell Environment (Zsh)
- Powered by Oh-My-Zsh framework
- Smart theme switching:
  - Powerlevel10k theme with instant prompt for modern terminals
  - Robbyrussell theme for TTY sessions
- Rich plugin collection for development:
  - Version Control: git
  - Container: docker, docker-compose, kubectl, helm
  - Languages: golang, rust, npm, pip
  - Navigation: z, autojump
  - Productivity: zsh-autosuggestions, dotenv
- Cross-platform support (macOS & Linux)

### 📝 Editor Setup (Vim/Neovim)
- Modular configuration structure
- Modern features:
  - Tree-sitter support for better syntax highlighting
  - LSP integration via CoC
  - Customized status line and tab line
- Specialized configurations:
  - GN build system support
  - Language-specific settings
- Carefully curated key mappings and commands

### ⚙️ Additional Tools
- tmux configuration for enhanced terminal multiplexing
- sxhkd for X11 keyboard shortcuts
- Custom scripts in `bin` directory
- Git configuration and global ignore patterns

## Prerequisites

Before installation, ensure you have the following tools installed:
- git
- zsh
- curl
- vim or neovim
- tmux (optional)

For the full GUI environment:
- X11 or Wayland
- sxhkd (for X11)

## Installation

### Quick Install (Automated)
```bash
curl -fsSL https://raw.githubusercontent.com/loyalpartner/dotfiles/master/install.sh | bash
```

### Manual Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/loyalpartner/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Run the setup script with desired configuration:

   Basic CLI environment:
   ```bash
   bash setup.sh basic
   ```

   Full GUI environment:
   ```bash
   bash setup.sh gui
   ```

   Wayland environment:
   ```bash
   bash setup.sh wayland
   ```

   Vim configuration only:
   ```bash
   bash setup.sh vim
   ```

   Emacs configuration (Doom):
   ```bash
   bash setup.sh doom
   ```

   Everything:
   ```bash
   bash setup.sh all
   ```

## Customization

### Local Configurations
- Zsh: Create `~/.work.sh` or modify `zsh/zshrc.local.zsh` for machine-specific settings
- Vim: Add custom configurations in `vimrc.d/`
- Git: Configure user information in `~/.gitconfig.local`

### Directory Structure
```
dotfiles/
├── bin/                  # Custom scripts and tools
├── configs/              # Various tool configurations
├── vimrc.d/             # Modular Vim configurations
│   ├── general.vim      # Basic settings
│   ├── plugin.vim       # Plugin management
│   ├── remap.vim        # Key mappings
│   └── ...
├── zsh/                 # Zsh configurations
│   ├── zshrc.zsh        # Main Zsh configuration
│   ├── zshrc.linux.zsh  # Linux-specific settings
│   └── zshrc.local.zsh  # Local machine settings
├── tmux.conf            # Tmux configuration
└── setup.sh            # Installation script
```

## Recommended Tools

For the best experience, consider installing:
- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder
- [ripgrep](https://github.com/BurntSushi/ripgrep) - Fast search tool
- [bat](https://github.com/sharkdp/bat) - Better cat
- [delta](https://github.com/dandavison/delta) - Better git diff
- [atuin](https://github.com/ellie/atuin) - Shell history sync

## Troubleshooting

### Known Issues
1. If Powerlevel10k prompt doesn't render correctly, ensure your terminal uses a [Nerd Font](https://www.nerdfonts.com/)
2. For Vim plugin installation issues, run `:PlugInstall` manually
3. If tmux status line shows wrong characters, check if tmux version >= 2.9

### Common Solutions
1. Regenerate Zsh completion cache:
   ```bash
   rm ~/.zcompdump* && exec zsh
   ```
2. Reset Vim plugins:
   ```bash
   rm -rf ~/.vim/plugged && vim +PlugInstall
   ```

## Contributing

Feel free to fork this repository and customize it for your needs. If you have any improvements or bug fixes, pull requests are welcome!

## Credits

This dotfiles collection is inspired by various awesome configurations from the community. Special thanks to:
- [Oh-My-Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- And many other open source projects

## License

This project is licensed under the MIT License - see the LICENSE file for details.