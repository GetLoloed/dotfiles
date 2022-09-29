autoload -U colors && colors

### Start of Zinit installer's chunk
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
	print -P "%F{33}▓▒░ %F{220}Installing Zinit (zdharma-continuum/zinit)…%f"
	command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
	command git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.zinit/bin" && \
		print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
		print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk

## Plugins section

## Options section
# Auto correct mistakes
setopt correct
# Extended globbing. Allows using regular expressions with *
setopt extendedglob
# Case insensitive globbing
setopt nocaseglob
# Array expension with parameters
setopt rcexpandparam
# Warn about running processes when exiting
setopt checkjobs
# Sort filenames numerically when it makes sense
setopt numericglobsort
# No f*****g beep
setopt nobeep
# Immediately append history instead of overwriting
setopt appendhistory
# If a new command is a duplicate, remove the older one
setopt histignorealldups
# If only a directory path is entered, cd there
setopt autocd

setopt prompt_subst
setopt glob_dots

# Case insensitive tab completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' rehash true
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

zstyle :compinstall filename '/home/jules/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install

# VCS Support
autoload -Uz vcs_info

zstyle ':vcs_info:*' actionformats \
    '%F{14}[%F{11}%b%F{11}|%F{9}%a%F{11}]%f'
zstyle ':vcs_info:*' formats \
    '%F{14}[%F{11}%b%F{14}]%f'
zstyle ':vcs_info:*' enable git

precmd ()
{
  vcs_info
}

# Aliases
alias ls='ls --color=auto'
alias ll='ls -l'
alias v='nvim'
alias win='cd /mnt/c/Users/loica/Desktop'
# Functions
mkcd ()
{
	[ ! -d "$1" ] && mkdir -p $1 ; cd $1
}

up ()
{
	sudo apt update -y
	sudo apt full-upgrade -y
}

# Exports
export PROMPT='%F{207}%n% %F{75}@%F{207}%m% %F{75}[%F{214}%~% %F{75}]%F{75}$%f '
export RPROMPT='${vcs_info_msg_0_}'
export EDITOR='nvim'
