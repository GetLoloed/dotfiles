export ZSH="/home/alive/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
	git
	dnf
	zsh-syntax-highlighting
	zsh-autosuggestions
	)

source $ZSH/oh-my-zsh.sh


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
