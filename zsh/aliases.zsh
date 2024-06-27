# cd
alias .='cd ..'
alias ..='cd ../..'
alias ...='cd ../../..'
alias ....='cd ../../../..'

# File navigation
alias lx='exa --icons --git --sort=type'
alias la='exa -alh --icons --git --sort=type --no-permissions --no-user'
alias lt='exa --tree --level=2 -F --icons --git --sort=type'
alias lta='exa --tree --level=2 -alh --icons --git --sort=type --no-permissions --no-user'
alias lsg='ls -a | grep $1'

# General
alias c='clear'
alias h='history'
alias cpp='copypath'
alias reload='source ~/.zshrc'
alias zshrc="code ~/.zshrc"
alias dk='cd ~/Desktop'
alias top='btop'
alias rr='ranger'

# AWS Q
alias qc='q chat'
alias qt='q translate'

# Brew
alias br='brew'
alias bl='brew list'
alias bi='brew install'
alias bu='brew uninstall'
alias updt='brew update && brew upgrade && omz update'

# Python
alias py='python3'
alias main='python3 main.py'
alias str='streamlit run'

# Pip
alias ppl='pip list'
alias ppi='pip install'
alias ppu='pip uninstall'

# pip requirements & pipreqs
alias ppr='pip install -r requirements.txt'
alias reqs='pipreqs . --scan-notebooks'
alias reqsf='pipreqs . --force --scan-notebooks'

# Virtual Environment
# virtuenv & wrapper
alias menv='mkvirtualenv'
alias wenv='workon'
alias renv='rmvirtualenv'
alias lenv='lsvirtualenv'
alias denv='deactivate && c'
# vanilla venv
alias act='source bin/activate && . && c'
# env() {
#     python3 -m venv "$1"       # Create the virtual environment with the given name
#     source "$1/bin/activate"      # Activate the virtual environment
# }

# Git
alias gcl="git clone"
alias gps='git push origin "$(git_current_branch)"'
alias gpl='git pull origin "$(git_current_branch)"'
alias gco="git checkout"
alias gb='git branch'
alias ghst='git log --oneline --graph --all'
alias gdf='git diff'
alias ga='git add'
alias gaa='git add .'
alias gdsc='git checkout -- .'

# Github (gh)
alias repo='gh repo create'
alias ghcs='gh copilot suggest'
alias ghce='gh copilot explain'

# Docker
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"
alias ds="docker stop"

# Supabase
alias spb='supabase'

# Direnv
alias adenv='direnv allow .'
