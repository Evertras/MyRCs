# Use this to profile load times and find slow things
#PS4='+ $EPOCHREALTIME\011 '
#set -x

# We want to use the same bashrc between Mac and Linux, but there are some
# differences based on where we're running, so figure out where we are
HOST_OS=$(uname)

################################################################################
######################### PROMPT/THEME #########################################
################################################################################

export TERM=xterm-256color

# Add color to ls
if [[ "${HOST_OS}" == "Darwin" ]]; then
	export CLICOLOR=true
else
	alias ls='ls --color'
fi

# Enable starship as our bash prompt if it's installed
if which starship &>/dev/null; then
  eval "$(starship init bash)"
fi

if which direnv &>/dev/null; then
  eval "$(direnv hook bash)"
fi

################################################################################
############################ ALIASES ###########################################
################################################################################

# Colorize all greps when appropriate
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Just use nvim
alias vim=nvim

# Quick access to tweak things
alias editbash='nvim ~/.bashrc'
alias reloadbash='source ~/.bashrc'
alias editvim='nvim ~/.vimrc'

# Typing "npm run" is oddly annoying
alias nr='npm run'

# So is 'tmuxinator'
alias mux='tmuxinator'

# Some kubectl shortcuts
alias usens='kubectl config set-context --current --namespace'
alias k='kubectl'

# The ultimate laziness
alias m='make'

# Fix keyboard layout in Linux (harmless in Mac, so fine in here)
alias fixkeyboard='setxkbmap -layout us'

# Quick pure nix-shell
alias nspure='nix-shell --pure'

# Usage: up [n]
#
# Example: 'up 3' goes up 3 directories
up() {
	local d=""
	limit=$1
	for((i=1 ; i <= limit ; i++))
		do
			d=$d/..
		done

	d=$(echo $d | sed 's/^\///')
	if [ -z "$d" ]; then
		d=..
	fi

	cd $d
}

################################################################################
############################ MISC ##############################################
################################################################################

# Reset LINES/COLUMNS after each command
shopt -s checkwinsize

# Append to history per-command rather than waiting for shell to exit
shopt -s histappend

# Don't ding on autocomplete
bind 'set bell-style none'

# Don't show control characters (for interactive shells only)
[[ $- == *i* ]] && stty -echoctl

# Use nvim for all our editing needs
export EDITOR=nvim
export VISUAL=nvim

# We're a dirty 'murican
export LC_ALL=en_US.UTF-8

# Make GPG signing happen in the correct terminal
export GPG_TTY="$(tty)"

# Machine-specific bash stuff should go in this directory
for SRCFILE in ~/.bashrc.d/*; do
	if [[ -f ${SRCFILE} ]]; then
		source ${SRCFILE}
	fi
done

# Simple Makefile completion
complete -W "\`grep -oE '^[a-zA-Z0-9_-]+:([^=]|$)' Makefile | sed 's/[^a-zA-Z0-9_-]*$//'\`" make

function checkpath() {
	echo "${PATH}" | tr ":" "\n" | sort -u
}

function volumize() {
	if [[ $# -ne 2 ]]; then
		echo "Usage: volumize <dir> <volume-name>"
		return 1
	fi

	VDIR=$1
	VNAME=$2

	echo "Putting directory $VDIR into volume $VNAME"

	docker rm volumizer-helper || echo "^^^^ This is fine if it doesn't exist"
	docker volume create ${VNAME}
	docker create -v ${VNAME}:/data --name volumizer-helper busybox true
	docker cp ${VDIR} volumizer-helper:/data
	docker rm volumizer-helper

	echo "Done!  Use volume '${VNAME}'"
}

function host() {
  if [[ $# -ne 3 ]]; then
    echo "Usage: host <dir> <hostname> <port>"
    return 1
  fi

  EVERTRAS_HOST_DIR=$1
  EVERTRAS_HOST_NAME=$2
  EVERTRAS_HOST_PORT=$3

  echo "Hosting directory ${EVERTRAS_HOST_DIR} on http://${EVERTRAS_HOST_NAME}:${EVERTRAS_HOST_PORT}"

  docker run --rm -it \
    -v ${EVERTRAS_HOST_DIR}:/usr/share/nginx/html \
    -e NGINX_HOST=${EVERTRAS_HOST_NAME} \
    -p ${EVERTRAS_HOST_PORT}:80 \
    nginx:1.23-alpine
}

function hostfileindex() {
  if [[ $# -ne 3 ]]; then
    echo "Usage: hostfileindex <file> <hostname> <port>"
    return 1
  fi

  EVERTRAS_HOST_DIR=$1
  EVERTRAS_HOST_NAME=$2
  EVERTRAS_HOST_PORT=$3

  echo "Hosting file ${EVERTRAS_HOST_DIR} on http://${EVERTRAS_HOST_NAME}:${EVERTRAS_HOST_PORT}"

  docker run --rm -it \
    -v ${EVERTRAS_HOST_DIR}:/usr/share/nginx/html/index.html \
    -e NGINX_HOST=${EVERTRAS_HOST_NAME} \
    -p ${EVERTRAS_HOST_PORT}:80 \
    nginx:1.23-alpine
}

function terminal-mode-normal() {
  echo -n "" > ~/.config/alacritty/demo-override.yml
}

function terminal-mode-demo() {
  cp ~/.config/alacritty/mode-demo.yml ~/.config/alacritty/demo-override.yml
}

function git-merged() {
  branch=$(git rev-parse --abbrev-ref HEAD)
  git checkout main
  git pull
  git branch -d "${branch}"
}

################################################################################
############################ END ###############################################
################################################################################

# Anything past here got auto-added by something and should be moved to ~/.bashrc.d/

