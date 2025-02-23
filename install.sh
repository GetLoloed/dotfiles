#!/bin/bash

# ███████╗███████╗████████╗██╗   ██╗██████╗ 
# ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
# ███████╗█████╗     ██║   ██║   ██║██████╔╝
# ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ 
# ███████║███████╗   ██║   ╚██████╔╝██║     
# ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     
                                          
# Colors and styles
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Fancy symbols
CHECK_MARK="\033[0;32m✓\033[0m"
CROSS_MARK="\033[0;31m✗\033[0m"
ARROW="\033[0;34m➜\033[0m"
STAR="\033[0;33m★\033[0m"

# Progress bar function
progress_bar() {
    local duration=$1
    local width=50
    local progress=0
    local step=$((width * 100 / duration))
    
    printf "  Progress: "
    while [ $progress -le 100 ]; do
        local current=$((progress * width / 100))
        printf "\r  Progress: ["
        for ((i=0; i<current; i++)); do printf "█"; done
        for ((i=current; i<width; i++)); do printf " "; done
        printf "] %d%%" $progress
        progress=$((progress + step))
        sleep 0.1
    done
    printf "\n"
}

# Message functions
print_header() {
    echo -e "\n${CYAN}${BOLD}=== $1 ===${NC}\n"
}

print_step() {
    echo -e "${ARROW} ${BOLD}$1${NC}"
}

print_success() {
    echo -e "${CHECK_MARK} ${GREEN}$1${NC}"
}

print_error() {
    echo -e "${CROSS_MARK} ${RED}$1${NC}"
}

print_info() {
    echo -e "${STAR} ${YELLOW}$1${NC}"
}

# Welcome message
clear
cat << "EOF"
 ____        _    _____ _ _            ____       _             
|  _ \  ___ | |_ |  ___(_) | ___  ___|  _ \ ___ | |_ _   _ ___ 
| | | |/ _ \| __|| |_  | | |/ _ \/ __| |_) / _ \| __| | | | _ \
| |_| | (_) | |_ |  _| | | |  __/\__ \  __/ (_) | |_| |_| |  _/
|____/ \___/ \__||_|   |_|_|\___||___/_|   \___/ \__|\__,_|_|  
                                                                
EOF
echo -e "\n${BOLD}Welcome to your personalized dotfiles setup!${NC}\n"

# Check system
print_header "System Check"
print_step "Checking system requirements..."

if [ -f /etc/fedora-release ]; then
    print_success "Fedora system detected"
    print_step "Installing dependencies..."
    
    # Update system and install packages
    sudo dnf update -y &> /dev/null
    sudo dnf install -y \
        zsh git curl wget npm nodejs neovim tmux \
        fzf ranger python3-pip eza wslu &> /dev/null
    
    print_success "Dependencies installed successfully"
else
    print_error "This script is optimized for Fedora. Some commands might not work."
fi

# Oh My Zsh installation
print_header "Shell Setup"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_step "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My Zsh installed"
fi

# Zsh plugins
print_step "Setting up Zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions &> /dev/null
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting &> /dev/null
fi
print_success "Zsh plugins installed"

# Fonts installation
print_header "Fonts Setup"
print_step "Installing FiraMono Nerd Font..."
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraMono.zip &> /dev/null
unzip FiraMono.zip &> /dev/null
rm FiraMono.zip
fc-cache -fv &> /dev/null
print_success "Fonts installed"

# Neovim setup
print_header "Neovim Setup"
if [ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    print_step "Installing Neovim package manager..."
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
        ~/.local/share/nvim/site/pack/packer/start/packer.nvim &> /dev/null
    print_success "Neovim package manager installed"
fi

# Tmux setup
print_header "Tmux Setup"
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    print_step "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm &> /dev/null
    print_success "Tmux Plugin Manager installed"
fi

# Ranger setup
print_header "Ranger Setup"
print_step "Configuring Ranger..."
pip3 install --user ueberzug &> /dev/null
if [ ! -d "$HOME/.config/ranger/plugins/ranger_devicons" ]; then
    git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons &> /dev/null
fi
print_success "Ranger configured"

# Configuration files
print_header "Configuration Files"
print_step "Setting up configuration files..."

# Create necessary directories
mkdir -p ~/.config/{nvim,ranger}

# Backup function
backup_file() {
    if [ -f "$1" ]; then
        mv "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
        print_info "Backup created for $1"
    fi
}

# Backup existing configs
backup_file ~/.zshrc
backup_file ~/.tmux.conf
backup_file ~/.config/nvim/init.lua
backup_file ~/.config/ranger/rc.conf

# Copy new configurations
cp dotfiles/.zshrc ~/.zshrc
cp dotfiles/.tmux.conf ~/.tmux.conf
cp -r dotfiles/nvim/* ~/.config/nvim/
cp dotfiles/ranger/rc.conf ~/.config/ranger/rc.conf
print_success "Configuration files installed"

# Set default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    print_step "Changing default shell to Zsh..."
    chsh -s $(which zsh)
    print_success "Default shell changed to Zsh"
fi

# Final setup
print_header "Finalizing Installation"
progress_bar 100

# Completion message
echo -e "\n${GREEN}${BOLD}Installation completed successfully!${NC}\n"
print_info "Please restart your terminal to apply all changes"
print_info "Don't forget to run ':PackerSync' in Neovim to install plugins"
echo -e "\n${BOLD}Enjoy your new setup! 🚀${NC}\n" 