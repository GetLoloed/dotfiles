autoload -U colors && colors

# Aliases
alias ls='ls --color=auto'
alias ll='ls -l'
alias v='nvim'

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
