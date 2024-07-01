#!/bin/bash

# Log output:
# * 51c333e    (12 days)    <Gary Bernhardt>   add vim-eunuch
LOG_HASH="%C(always,yellow)%h%C(always,reset)"
LOG_RELATIVE_TIME="%C(always,green)(%ar)%C(always,reset)"
LOG_AUTHOR="%C(always,blue)<%an>%C(always,reset)"
LOG_REFS="%C(always,red)%d%C(always,reset)"
LOG_SUBJECT="%s"
LOG_FORMAT="$LOG_HASH}$LOG_AUTHOR}$LOG_RELATIVE_TIME}$LOG_SUBJECT $LOG_REFS"

# Branch output:
# * release/v1.1    (13 days)    <Leyan Lo>   add pretty_git_branch
BRANCH_PREFIX="%(HEAD)"
BRANCH_REF="%(color:red)%(color:bold)%(refname:short)%(color:reset)"
BRANCH_HASH="%(color:yellow)%(objectname:short)%(color:reset)"
BRANCH_DATE="%(color:green)(%(committerdate:relative))%(color:reset)"
BRANCH_AUTHOR="%(color:blue)%(color:bold)<%(authorname)>%(color:reset)"
BRANCH_CONTENTS="%(contents:subject)"
BRANCH_FORMAT="}$BRANCH_PREFIX}$BRANCH_REF}$BRANCH_HASH}$BRANCH_DATE}$BRANCH_AUTHOR}$BRANCH_CONTENTS"

# Displays the latest commit information
show_git_head() {
    pretty_git_log -1
    git show -p --pretty="tformat:"
}

# Displays a pretty formatted log of git commits
pretty_git_log() {
    git log --reverse --since="12 months ago" --pretty="tformat:${LOG_FORMAT}" $* | pretty_git_format
}

# Displays a pretty formatted log of all git commits
pretty_git_log_all() {
    git log --all --since="12 months ago" --graph --pretty="tformat:${LOG_FORMAT}" $* | pretty_git_format | git_page_maybe
}

# Displays a pretty formatted list of git branches
pretty_git_branch() {
    git branch -v --color=always --format=${BRANCH_FORMAT} $* | pretty_git_format
}

# Displays a pretty formatted list of git branches sorted by commit date
pretty_git_branch_sorted() {
    git branch -v --color=always --format=${BRANCH_FORMAT} --sort=-committerdate $* | pretty_git_format
}

# Formats the output of git log and git branch commands
pretty_git_format() {
    # Replace (2 years ago) with (2 years)
    sed -Ee 's/(^[^)]*) ago\)/\1)/' |
        # Replace (2 years, 5 months) with (2 years)
        sed -Ee 's/(^[^)]*), [[:digit:]]+ .*months?\)/\1)/' |
        # Shorten time
        sed -Ee 's/ seconds?\)/s\)/' |
        sed -Ee 's/ minutes?\)/m\)/' |
        sed -Ee 's/ hours?\)/h\)/' |
        sed -Ee 's/ days?\)/d\)/' |
        sed -Ee 's/ weeks?\)/w\)/' |
        sed -Ee 's/ months?\)/M\)/' |
        # Shorten names
        sed -Ee 's/<Andrew Burgess>/<me>/' |
        sed -Ee 's/<([^ >]+) [^>]*>/<\1>/' |
        # Line columns up based on } delimiter
        column -s '}' -t
}

# Displays git log or git branch output with pagination
git_page_maybe() {
    # Page only if we're asked to.
    if [ -n "${GIT_NO_PAGER}" ]; then
        cat
    else
        # Page only if needed.
        less --quit-if-one-screen --no-init --RAW-CONTROL-CHARS --chop-long-lines
    fi
}

# Shortcut for checking out a git branch using fzf for interactive selection
gfb() {
    git checkout $(git branch | fzf)
}

# Shortcut for committing changes with a message
gcmt() {
    git commit -m "$1"
}

# Shortcut for committing all changes with a message
gcma() {
    git commit -a -m "$1"
}

# Displays a pretty formatted git log with interactive selection using fzf
gbc() {
    git log --graph --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
        fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort --preview \
            'f() { set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}"); [ $# -eq 0 ] || git show --color=always $1 ; }; f {}' \
            --header "enter to view, ctrl-o to checkout" \
            --bind "q:abort,ctrl-f:preview-page-down,ctrl-b:preview-page-up" \
            --bind "ctrl-o:become:(echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | xargs git checkout)" \
            --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF" --preview-window=right:60%
}

# gfs - type gfs to get a list of your stashes
# enter shows you the contents of the stash
# ctrl-d shows a diff of the stash against your current HEAD
# ctrl-b checks the stash out as a branch, for easier merging
gfs() {
    local out q k sha
    while out=$(
        git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
            fzf --ansi --no-sort --query="$q" --print-query \
                --expect=ctrl-d,ctrl-b
    ); do
        mapfile -t out <<<"$out"
        q="${out[0]}"
        k="${out[1]}"
        sha="${out[-1]}"
        sha="${sha%% *}"
        [[ -z "$sha" ]] && continue
        if [[ "$k" == 'ctrl-d' ]]; then
            git diff $sha
        elif [[ "$k" == 'ctrl-b' ]]; then
            git stash branch "stash-$sha" $sha
            break
        else
            git stash show -p $sha
        fi
    done
}

# fgst - pick files from `git status -s`
is_in_git_repo() {
    git rev-parse HEAD >/dev/null 2>&1
}

fgst() {
    # "Nothing to see here, move along"
    is_in_git_repo || return

    local cmd="${FZF_CTRL_T_COMMAND:-"command git status -s"}"

    eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" | while read -r item; do
        echo "$item" | awk '{print $2}'
    done
    echo
}
