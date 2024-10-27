# fzf in command history
ch() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac --height "50%" | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# bat all files of a given filetype
fbat() {
  local filetype=$1
  bat *.$filetype
}

# cd & exa - provide the directory to cd into as argument
cl() {
  cd "$@" && lx
}

# fzf in current directory (with dotfiles) and copy to clipboard
f() {
  ls -dp $PWD/{.,}* | fzf | pbcopy
}

# fzf only showing the directories and not the directories within those.
fd() {
  DIR=$(find * -maxdepth 0 -type d -print 2>/dev/null | fzf-tmux) &&
    cd "$DIR"
}

# cd to selected parent directory with fzf
fdp() {
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }
  local DIR=$(get_parent_dirs $(realpath "${1:-$PWD}") | fzf-tmux --tac)
  cd "$DIR"
}

# find-in-file - usage: fif <searchTerm> or fif "string with spaces" or fif "regex"
fif() {
  if [ ! "$#" -gt 0 ]; then
    echo "Need a string to search for!"
    return 1
  fi
  local file
  file="$(rga --max-count=1 --ignore-case --files-with-matches --no-messages "$*" | fzf-tmux +m --preview="rga --ignore-case --pretty --context 10 '"$*"' {}")" && echo "opening $file" && open "$file" || return 1
}

# fzf brew search and open the info page - provide the package name as argument
bfs() {
  brew info $(brew search "$1" | fzf)
}

# Ranger - https://github.com/ranger/ranger
ranger() {
  local IFS=$'\t\n'
  local tempfile="$(mktemp -t tmp.XXXXXX)"
  local ranger_cmd=(
    command
    ranger
    --cmd="set show_hidden=true; map Q chain shell echo %d > "$tempfile"; quitall"
  )

  ${ranger_cmd[@]} "$@"
  if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n $(pwd))" ]]; then
    cd -- "$(cat "$tempfile")" || return
  fi
  command rm -f -- "$tempfile" 2>/dev/null
}

# fzf to select a command to run with python manage.py
fds() {
  local commands=("runserver" "makemigrations" "migrate" "createsuperuser")
  local command=$(printf "%s\n" "${commands[@]}" | fzf --height "50%")
  if [ -n "$command" ]; then
    poetry run python manage.py $command
  fi
}

# fzf npm run scripts
frs() {
  local script
  script=$(cat package.json | jq -r '.scripts | keys[] ' | sort | fzf) && npm run $(echo "$script")
}

# Docker
# Select a docker container to start and attach to, allows multi selection
da() {
  local cid
  cid=$(docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}" | fzf -1 -q "$1" --header-lines=1 | awk 'NR>1 {print $1}')

  [ -n "$cid" ] && docker start "$cid" && docker attach "$cid"
}

# Select a running docker container to stop and remove, allows multi selection
ds() {
  docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}" | fzf -q "$1" --no-sort -m --tac --header-lines=1 | awk '{ print $1 }' | xargs -r docker rm
}

# Select docker images to remove, allows multi selection
drmi() {
  docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}" | fzf -q "$1" --no-sort -m --tac --header-lines=1 | awk '{ print $3 }' | xargs -r docker rmi
}
