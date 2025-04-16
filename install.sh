#!/bin/bash

# Dotfiles Installation Script
# Author: Kyle Berry
# Description: Sets up symbolic links for dotfiles and installs dependencies

set -e # Exit immediately if a command exits with a non-zero status

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Print colored message
print_message() {
  echo -e "${BLUE}==>${NC} $1"
}

print_success() {
  echo -e "${GREEN}==>${NC} $1"
}

print_error() {
  echo -e "${RED}==>${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}==>${NC} $1"
}

# Check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Create backup directory
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

print_message "Dotfiles installation started..."
print_message "Backup directory: $BACKUP_DIR"

# Function to backup and link files
backup_and_link() {
  source="$1"
  target="$2"
  
  # Create target directory if it doesn't exist
  target_dir=$(dirname "$target")
  if [ ! -d "$target_dir" ]; then
    print_message "Creating directory: $target_dir"
    mkdir -p "$target_dir"
  fi
  
  # Backup existing configuration if it exists
  if [ -e "$target" ]; then
    print_message "Backing up existing $target to $BACKUP_DIR/"
    cp -R "$target" "$BACKUP_DIR/"
    
    # Remove the original
    if [ -d "$target" ]; then
      rm -rf "$target"
    else
      rm -f "$target"
    fi
  fi
  
  # Create symbolic link
  print_message "Creating symlink: $target -> $source"
  ln -sf "$source" "$target"
  print_success "Symlink created successfully!"
}

# Get the directory where the script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check dependencies
print_message "Checking dependencies..."

check_and_install_deps() {
  # Check Neovim version
  if command_exists nvim; then
    nvim_version=$(nvim --version | head -n 1 | cut -d " " -f 2)
    print_success "Neovim $nvim_version is installed"
    
    # Check if Neovim version is >= 0.9.0
    if [[ $(echo "$nvim_version" | cut -d "." -f 1) -eq 0 && $(echo "$nvim_version" | cut -d "." -f 2) -lt 9 ]]; then
      print_warning "Neovim version should be at least 0.9.0, please consider upgrading"
    fi
  else
    print_error "Neovim is not installed. Please install Neovim >= 0.9.0"
    exit 1
  fi
  
  # Check Node.js and npm
  if command_exists node; then
    node_version=$(node --version)
    print_success "Node.js $node_version is installed"
  else
    print_error "Node.js is not installed. Required for LSP servers"
    print_message "Please install Node.js: https://nodejs.org"
    exit 1
  fi
  
  # Check ripgrep
  if command_exists rg; then
    rg_version=$(rg --version | head -n 1)
    print_success "ripgrep $rg_version is installed"
  else
    print_warning "ripgrep is not installed. Recommended for telescope search"
    print_message "Install with: 'sudo apt install ripgrep' or 'brew install ripgrep'"
  fi
  
  # Check fd
  if command_exists fd; then
    fd_version=$(fd --version)
    print_success "fd $fd_version is installed"
  elif command_exists fdfind; then
    fd_version=$(fdfind --version)
    print_success "fd $fd_version is installed (as fdfind)"
  else
    print_warning "fd is not installed. Recommended for telescope file finding"
    print_message "Install with: 'sudo apt install fd-find' or 'brew install fd'"
  fi
  
  # Check git
  if command_exists git; then
    git_version=$(git --version)
    print_success "git $git_version is installed"
  else
    print_error "git is not installed. Required for plugin management"
    print_message "Please install git: https://git-scm.com/downloads"
    exit 1
  fi
}

check_and_install_deps

# Create symbolic links
print_message "Setting up symbolic links..."

# Neovim
backup_and_link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# Add other configuration files as needed
# backup_and_link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
# backup_and_link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# Print summary
print_success "Dotfiles installation completed successfully!"
print_message "You may need to restart your terminal for some changes to take effect."
print_message "Launch Neovim to install plugins: nvim"
