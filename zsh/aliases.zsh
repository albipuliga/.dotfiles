# cd
alias .='cd ..'
alias ..='cd ../..'
alias ...='cd ../../..'
alias ....='cd ../../../..'

# File navigation
alias lx='eza --icons --git --sort=type'               # List everything by type
alias ld='eza -D --icons --git'                        # List only directories
alias lh='eza -d --icons .* --group-directories-first' # List only hidden files
alias la='eza -alh --icons --git --sort=type --no-permissions --no-user'
alias lta='eza --tree --level=2 -alh --icons --git --sort=type --no-permissions --no-user'
alias lsg='ls -a | grep $1'

# General
alias c='clear'
alias h='history'
alias dk='cd ~/Desktop'
#------------------------------
alias reload='source ~/.zshrc'
alias zshrc="code ~/.zshrc"
alias cpp='copypath'
alias top='btop'
alias rr='ranger'

# fzf
# | Token     | Match type                 | Description                          |
# | --------- | -------------------------- | ------------------------------------ |
# | `sbtrkt`  | fuzzy-match                | Items that match `sbtrkt`            |
# | `'wild`   | exact-match (quoted)       | Items that include `wild`            |
# | `^music`  | prefix-exact-match         | Items that start with `music`        |
# | `.mp3$`   | suffix-exact-match         | Items that end with `.mp3`           |
# | `!fire`   | inverse-exact-match        | Items that do not include `fire`     |
# | `!^music` | inverse-prefix-exact-match | Items that do not start with `music` |
# | `!.mp3$`  | inverse-suffix-exact-match | Items that do not end with `.mp3`    |

alias fa='fzf'
alias fcf='code $(fzf -m --preview "bat --style=numbers --color=always {}")'
alias fps='ps aux | fzf --reverse --height 50%'
alias fpsk='ps aux | fzf --reverse --height 50% | awk "{print $2}" | xargs kill -9'

# AWS Q
alias qc='q chat'
alias qt='q translate'

# Brew
alias br='brew'
alias bl='brew list'
alias bi='brew install'
alias bu='brew uninstall'
alias updt='brew update && brew upgrade && omz update'

# npm
alias nrd='npm run dev'

# pnpm
alias prd='pnpm dev'

# Python
alias py='python3'
alias main='python3 main.py'
alias str='streamlit run'
alias poer='poetry run python'
alias psh='source "$(poetry env info --path)/bin/activate"'
alias jupdf='jupyter nbconvert --to pdf'

# Pip
alias ppl='pip list'
alias ppi='pip install'
alias ppu='pip uninstall'

# pip requirements & pipreqs
alias ppr='pip install -r requirements.txt'
alias reqs='pipreqs . --scan-notebooks'
alias reqsf='pipreqs . --force --scan-notebooks'

# Virtuenv & wrapper
alias menv='mkvirtualenv'
alias wenv='workon'
alias renv='rmvirtualenv'
alias lenv='lsvirtualenv'
alias denv='deactivate && c'
# Vanilla venv
alias act='source bin/activate && . && c'

# Git
alias gcl="git clone"
alias gps='git push origin "$(git_current_branch)"'
alias gpl='git pull origin "$(git_current_branch)"'
alias gplm='git pull origin main'
# alias glgg='pretty_git_log_all'
alias glg='pretty_git_log'
alias gdf='git diff'
alias gdfh='show_git_head'
alias gaa='git add .'
alias gu='git reset HEAD .'
alias gdsc='git checkout -- .'
alias gb='pretty_git_branch_sorted'
alias gstiu='gst --ignored -u'
alias gfc='glg | grep $1'
alias lg='lazygit'

# Github (gh)
alias repo='gh repo create'
alias ghcs='gh copilot suggest'
alias ghce='gh copilot explain'

# Forgit
alias fga='forgit::add'
# forgit_log=glo
# forgit_diff=gd
# forgit_add=ga
# forgit_reset_head=grh
# forgit_ignore=gi
# forgit_checkout_file=gcf
# forgit_checkout_branch=gcb
# forgit_branch_delete=gbd
# forgit_checkout_tag=gct
# forgit_checkout_commit=gco
# forgit_revert_commit=grc
# forgit_clean=gclean
# forgit_stash_show=gss
# forgit_stash_push=gsp
# forgit_cherry_pick=gcp
# forgit_rebase=grb
# forgit_blame=gbl
# forgit_fixup=gfu

# Docker
alias lzd='lazydocker'
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# Supabase
alias spb='supabase'

# Direnv
alias adenv='direnv allow .'
