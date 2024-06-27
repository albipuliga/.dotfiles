# File navigation
cl() { cd "$@" && lx; } # cd and exa
f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy; } # find file & copy to clipboard
of() { code "$(find . -type f -not -path '*/.*' | fzf)"; } # find file and open in vscode
fd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; } # find directory
fb() { bat "$(find . -type f -not -path '*/.*' | fzf)"; } # find file and open in bat
ch() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac --height "50%" | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# Brew
bfs() { brew info $(brew search "$1" | fzf); }
bfi() { brew install $(brew search "$1" | fzf); }

# Git
gfb() { git checkout $(git branch | fzf); }
gcmt() { git commit -m "$1"; }
gcma() { git commit -a -m "$1"; }

# Ranger
function ranger {
	local IFS=$'\t\n'
	local tempfile="$(mktemp -t tmp.XXXXXX)"
	local ranger_cmd=(
		command
		ranger
		--cmd="map Q chain shell echo %d > "$tempfile"; quitall"
	)

	${ranger_cmd[@]} "$@"
	if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
		cd -- "$(cat "$tempfile")" || return
	fi
	command rm -f -- "$tempfile" 2>/dev/null
}

