# Configuration de base
export ZSH="$HOME/.oh-my-zsh"

# Configuration pour lancer tmux automatiquement
if [ -z "$TMUX" ]; then
    # Vérifier si on est dans WSL et si c'est une session initiale
    if [[ -n "$WSL_DISTRO_NAME" && -z "$WINDOW" && -z "$TMUX" && "$SHLVL" -eq 1 ]]; then
        # Vérifier si une session tmux existe déjà
        if tmux has-session 2>/dev/null; then
            # Si une session existe, on s'y attache
            exec tmux attach
        else
            # Sinon on crée une nouvelle session
            exec tmux new-session
        fi
    fi
fi

# Thème simple et efficace
ZSH_THEME=""

# Plugins essentiels
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    history-substring-search
    colored-man-pages
    docker
    kubectl
    sudo                    # Double ESC pour ajouter sudo
    copypath               # copier le chemin du dossier courant
    copyfile               # copier le contenu d'un fichier
    dirhistory            # Alt+Left/Right pour naviguer
    web-search            # recherche directe : google mot_clé
    extract               # extraction universelle avec 'x fichier'
    fzf                   # recherche floue super puissante
    git-flow             # raccourcis pour git-flow
    npm                   # completion pour npm
    pip                   # completion pour pip
    python               # aliases python utiles
    command-not-found    # suggère le paquet à installer si commande non trouvée
    jsontools           # outils pour manipuler du JSON (pp_json, is_json, urlencode_json)
    docker-compose      # completion pour docker-compose
    systemd             # aliases pour systemd (sc-status, sc-restart, etc)
    z                   # jump rapidement vers les dossiers fréquents
    ansible             # completion pour ansible
    timer              # affiche le temps d'exécution des longues commandes
    bgnotify           # notification quand une commande longue se termine
)

# Plugins additionnels utiles
plugins=(
    ${plugins[@]}
    vscode              # Intégration VS Code
    docker-compose      # Completion pour docker-compose
    npm                 # Completion pour npm
    node                # Completion pour node
    golang              # Support pour Go
    rust                # Support pour Rust
    python              # Support pour Python
    git-flow            # Support pour git-flow
)

source $ZSH/oh-my-zsh.sh

# Fonction pour détecter l'icône de la distribution
function get_distro_icon() {
    if [ -f /etc/fedora-release ]; then
        echo "󰣛 "  # Icône Fedora
    elif [ -f /etc/debian_version ]; then
        echo "󰣚 "  # Icône Debian
    elif [ -f /etc/arch-release ]; then
        echo "󰣇 "  # Icône Arch
    elif [ -f /etc/ubuntu-release ]; then
        echo "󰣺 "  # Icône Ubuntu
    else
        echo "󰌽 "  # Icône générique Linux
    fi
}

# Configuration des couleurs pour ls et complétion
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

# Configuration personnalisée du prompt avec git et couleurs
# Fonction pour le status git
function git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo " %F{yellow}󰊢 ${ref#refs/heads/}%f"
}

# Prompt amélioré avec icônes et couleurs
PROMPT='$(get_distro_icon)%F{magenta}%n%f%F{white}@%f%F{blue}%m%f %F{green}%~%f$(git_prompt_info) 
%F{cyan}λ%f '

# Aliases utiles
alias ll='eza -la --icons --group-directories-first'
alias ls='eza --icons --group-directories-first'
alias lt='eza -T --icons --group-directories-first'
alias l='eza -l --icons --group-directories-first'
alias la='eza -la --icons --group-directories-first'
alias zshconfig="nano ~/.zshrc"
alias reload="source ~/.zshrc"

# Amélioration de l'historique
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

# Auto-completion améliorée
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Raccourcis clavier
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Variables d'environnement utiles
export EDITOR='nano'
export VISUAL='nano'
export LANG=fr_FR.UTF-8

# Aliases additionnels utiles
alias update='sudo dnf update -y'        # Mise à jour rapide
alias install='sudo dnf install -y'      # Installation rapide
alias remove='sudo dnf remove -y'        # Désinstallation rapide
alias c='clear'                          # Effacer l'écran
alias ..='cd ..'                         # Remonter d'un niveau
alias ...='cd ../..'                     # Remonter de deux niveaux
alias mkdir='mkdir -p'                   # Créer les dossiers parents si nécessaire
alias ports='netstat -tulanp'           # Voir les ports ouverts
alias h='history'                        # Historique rapide
alias hg='history | grep'                # Rechercher dans l'historique
alias ip='ip -c'                         # IP avec couleurs
alias df='df -h'                         # Espace disque en format lisible
alias free='free -h'                     # Mémoire en format lisible
alias path='echo -e ${PATH//:/\\n}'      # Afficher PATH ligne par ligne

# Aliases WSL
alias explorer='explorer.exe .'  # Ouvre l'explorateur Windows
alias code='code .'           # VS Code
alias idea='idea64.exe .'     # IntelliJ si installé
alias notepad='notepad.exe'   # Notepad Windows
alias chrome='chrome.exe'     # Chrome Windows
alias edge='msedge.exe'       # Edge
alias clip='clip.exe'           # Copier dans le presse-papiers Windows
alias wsl-shutdown='wsl.exe --shutdown'  # Redémarrer WSL
alias winhome='cd /mnt/c/Users/$USER'   # Aller dans le home Windows
alias windesktop='cd /mnt/c/Users/$USER/Desktop'  # Aller sur le bureau Windows

# Intégration avec Windows
alias open='wslview'            # Ouvre avec l'application par défaut Windows
alias ipconfig='ipconfig.exe'   # ipconfig Windows
alias pwsh='powershell.exe'     # PowerShell Windows
alias cmd='cmd.exe'             # CMD Windows

# Fonctions utiles
# Créer un dossier et s'y déplacer
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Sauvegarder un fichier avec date
backup() {
    cp "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)"
}

# Extraire n'importe quel archive
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)          echo "'$1' ne peut pas être extrait via extract()" ;;
        esac
    else
        echo "'$1' n'est pas un fichier valide"
    fi
}

# Recherche récursive de fichiers
ff() { find . -type f -iname "*$1*"; }

# Recherche dans les fichiers
fif() { grep -Rin "$1" .; }

# Auto-correction des commandes
setopt CORRECT
setopt CORRECT_ALL

# Complétion améliorée
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# Configuration de l'historique
setopt EXTENDED_HISTORY          # Ajouter le timestamp à l'historique
setopt HIST_EXPIRE_DUPS_FIRST   # Supprimer les doublons en premier
setopt HIST_IGNORE_SPACE        # Ignorer les commandes commençant par espace
setopt SHARE_HISTORY            # Partager l'historique entre les sessions

# Configuration de la coloration syntaxique pour zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=yellow,bold'

# Configuration pour les suggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Configuration de la complétion
zstyle ':completion:*' menu select
zstyle ':completion:*:descriptions' format '%F{yellow}[%d]%f'
zstyle ':completion:*:messages' format '%F{purple}%d%f'
zstyle ':completion:*:warnings' format '%F{red}Pas de correspondance%f'
zstyle ':completion:*:corrections' format '%F{green}%d (erreurs: %e)%f'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Fonctions utiles
# Convertir les chemins Windows en chemins WSL
wslpath() {
    if [ -z "$1" ]; then
        echo "Usage: wslpath <windows_path>"
        return 1
    fi
    echo "$1" | sed 's/\\/\//g' | sed 's/^\([A-Za-z]\):/\/mnt\/\L\1/'
}

# Ouvrir un dossier dans l'explorateur Windows
exp() {
    if [ -z "$1" ]; then
        explorer.exe .
    else
        explorer.exe "$(wslpath -w "$1")"
    fi
}

# Lancer une commande Windows et convertir les chemins
win() {
    cmd.exe /C "$@" 2>&1 | sed 's/\r//g'
}

# Configuration WSL
# Variables d'environnement WSL
export BROWSER="wslview"
export WSLENV=BROWSER

# Amélioration des performances WSL
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Intégration avec le système de fichiers Windows
export PATH="$PATH:/mnt/c/Windows/System32:/mnt/c/Windows:/mnt/c/Program Files/Microsoft VS Code/bin"

# Configuration pour éviter les problèmes de permissions
if [ -z "$(umask)" ]; then
    umask 022
fi

# Aliases développement
alias dc='docker-compose'
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcl='docker-compose logs -f'

# Fonctions pour le développement
function gitignore() {
    curl -sL https://www.gitignore.io/api/$@ > .gitignore
}

# Configuration des performances
# Optimisations WSL
if [[ -n "$WSL_DISTRO_NAME" ]]; then
    # Désactiver la synchronisation des fichiers Windows
    export DONT_PROMPT_WSL_INSTALL=1
    # Améliorer les performances I/O
    export WSL_UTF8=1
    # Réduire la latence du shell
    export PROMPT_EOL_MARK=''
    # Réduire la latence
    export WSL_IDLE_TIMEOUT=0
    # Utiliser le GPU Windows
    export LIBGL_ALWAYS_INDIRECT=1
fi

# Cache de complétion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Aliases système
alias update-all='sudo dnf update -y && sudo dnf upgrade -y && flatpak update -y'
alias clean='sudo dnf clean all && sudo dnf autoremove -y'
alias services='systemctl list-units --type=service --state=running'
alias ports='netstat -tulpn'
alias disk='df -h | grep -v tmpfs'
alias mem='free -h'
alias cpu='top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk "{print 100 - \$1"%"}"'

# Raccourcis développement
alias ng='ng.cmd'              # Angular CLI via Windows
alias nps='npm start'
alias npd='npm run dev'
alias npt='npm test'
alias npi='npm install'
alias npb='npm run build'

# Fonctions utiles
# Créer un projet Angular
function ng-new() {
    ng.cmd new "$1" --directory "$1" --routing --style scss
}

# Ouvrir VSCode avec WSL
function code-wsl() {
    code-insiders --remote wsl+Fedora "$1"
}

# Gestionnaire de versions Node avec nvm
function node-setup() {
    nvm install node  # Dernière version
    nvm install --lts # Version LTS
    nvm use --lts    # Utiliser LTS
}

# Docker compose avec profils
function dc-env() {
    docker-compose --profile "$1" up -d
}

# Créer une nouvelle branche git et la pousser
function git-new() {
    git checkout -b "$1"
    git push -u origin "$1"
}

# Aliases utiles
# Ranger
alias ra='ranger'
alias r='ranger'
# Ouvrir ranger et changer de répertoire à la sortie
function ranger-cd() {
    temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
    ranger --choosedir="$temp_file" "${@:-$(pwd)}"
    if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$(pwd)" ]; then
        cd -- "$chosen_dir"
    fi
    rm -f -- "$temp_file"
}

# Utiliser Ctrl+O pour ouvrir ranger
bindkey -s '^o' 'ranger-cd\n'
alias ng='node /usr/local/lib/node_modules/@angular/cli/bin/ng.js'


# Load Angular CLI autocompletion.
source <(ng completion script)
