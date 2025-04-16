# Dotfiles

This repository contains my personal configuration files (dotfiles) for various tools and applications, with a focus on a modern Neovim setup optimized for web development.

![Neovim Screenshot](https://i.imgur.com/placeholder.png) <!-- Replace with an actual screenshot of your setup -->

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Structure](#structure)
- [Installation](#installation)
  - [Prerequisites](#prerequisites)
  - [Automatic Installation](#automatic-installation)
  - [Manual Installation](#manual-installation)
- [Neovim Configuration](#neovim-configuration)
  - [Key Features](#key-features)
  - [Plugin List](#plugin-list)
  - [Keybindings](#keybindings)
- [Customization](#customization)
- [Updating](#updating)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## Overview

This dotfiles repository uses symbolic links to maintain configuration files in a centralized Git repository while keeping them properly linked in their expected locations. This makes it easy to:

- Track changes to configuration files
- Synchronize settings across multiple machines
- Quickly set up a new development environment
- Share configurations with others

## Features

- 🚀 **Modern Neovim Config**: Complete IDE-like experience with LSP, autocompletion, and debugging
- 🔧 **Web Development Focus**: Optimized for JavaScript, TypeScript, React, and other web technologies
- 🎨 **Beautiful UI**: Clean themes and statusline with meaningful visual indicators
- 💻 **Cross-Platform**: Works on macOS, Linux, and WSL
- 📦 **Easy Installation**: Scripts to automate setup and dependencies
- 📚 **Well-Documented**: Detailed explanations of configurations and keybindings

## Structure

```
dotfiles/
├── install.sh           # Main installation script
├── README.md            # This readme file
├── nvim/                # Neovim configuration
│   ├── init.lua         # Main entry point
│   └── lua/             # Lua modules
│       ├── config/      # Core configuration
│       └── plugins/     # Plugin-specific configurations
├── bash/                # Bash configuration
├── zsh/                 # Zsh configuration
├── git/                 # Git configuration
└── bin/                 # Utility scripts
```

## Installation

### Prerequisites

- Git
- Neovim >= 0.9.0 (0.10.0+ recommended)
- Node.js and npm (for LSP support)
- A patched [Nerd Font](https://www.nerdfonts.com/) (for icons)
- [ripgrep](https://github.com/BurntSushi/ripgrep) (for telescope search)
- [fd](https://github.com/sharkdp/fd) (for telescope file finding)

### Automatic Installation

1. Clone this repository:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
```

2. Run the installation script:

```bash
cd ~/dotfiles
./install.sh
```

### Manual Installation

If you prefer to set up parts of the configuration manually:

1. Clone this repository:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
```

2. Create necessary directories:

```bash
mkdir -p ~/.config
```

3. Set up symbolic links:

```bash
# Neovim configuration
ln -sf ~/dotfiles/nvim ~/.config/nvim

# Add other configurations as needed
# ln -sf ~/dotfiles/bash/.bashrc ~/.bashrc
# ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
# ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig
```

## Neovim Configuration

My Neovim configuration is built for modern web development, with a focus on JavaScript/TypeScript ecosystems.

### Key Features

- 🔍 LSP integration for intelligent code navigation and autocompletion
- 🌳 Treesitter for advanced syntax highlighting and code understanding
- 🔎 Fuzzy finding with Telescope for files, text, and more
- 📦 Git integration with signs, blame, and diff view
- 🧩 Autocompletion with nvim-cmp and snippets
- 🎨 Beautiful UI with statusline, bufferline, and file explorer
- 🐞 Debugging support for JavaScript/TypeScript
- ⚡ Fast startup with lazy loading of plugins

### Plugin List

Some of the key plugins included:

- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configuration
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Completion engine
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax highlighting
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder
- [null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim) - Linting/formatting
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - Statusline
- [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) - File explorer
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git integration
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) - Debugging

See [Neovim Cheat Sheet](./nvim/CHEATSHEET.md) for detailed keybindings.

### Keybindings

This configuration uses Space as the leader key. Here are some key mappings:

**General**
- `<Space>ff` - Find files
- `<Space>fg` - Live grep
- `<Space>e` - Toggle file explorer
- `<Space>h` - Clear search highlighting

**LSP**
- `gd` - Go to definition
- `gr` - Find references
- `K` - Show documentation
- `<Space>ca` - Code actions
- `<Space>rn` - Rename symbol

**Git**
- `<Space>gs` - Stage hunk
- `<Space>gr` - Reset hunk
- `<Space>gb` - Toggle blame
- `<Space>gd` - Diff view

For a complete list of keybindings, see the [Neovim Cheat Sheet](./nvim/CHEATSHEET.md).

## Customization

To customize this setup:

1. Fork this repository
2. Make changes to the configuration files
3. Update your local repository with `git pull`
4. Run `./install.sh` to apply changes

### Neovim-specific Customization

- Add or modify plugins in `nvim/lua/plugins/*.lua`
- Change keybindings in `nvim/lua/config/keymaps.lua`
- Adjust options in `nvim/lua/config/options.lua`

## Updating

To update your dotfiles:

```bash
cd ~/dotfiles
git pull
./install.sh
```

For Neovim plugins:

1. Open Neovim
2. Run `:Lazy update`

## Troubleshooting

### Common Issues

**Neovim plugin installation fails**
- Ensure you have the right version of Neovim installed
- Check that all dependencies are installed

**Missing icons or broken UI**
- Make sure you have a Nerd Font installed and configured in your terminal

**LSP not working**
- Verify that the language servers are installed
- Run `:LspInfo` to check the status of language servers

If you encounter any issues, please [open an issue](https://github.com/yourusername/dotfiles/issues) on GitHub.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

If you find these dotfiles useful, consider giving this repository a star on GitHub! ⭐
