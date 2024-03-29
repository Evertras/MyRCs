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

################################################################################
######################### COMMON EVALS #########################################
################################################################################

# Enable various commonly used tools if they're installed, skip otherwise

if type starship &>/dev/null; then
  eval "$(starship init bash)"
fi

if type direnv &>/dev/null; then
  eval "$(direnv hook bash)"
fi

if type pyenv &>/dev/null; then
  export PYENV_ROOT="${HOME}/.pyenv"
  command -v pyenv >/dev/null || export PATH="${PYENV_ROOT}/bin/:$PATH"
  eval "$(pyenv init -)"
fi

if [[ -f ~/.cargo/env ]]; then
  . ~/.cargo/env
fi

if [[ -f ~/.asdf/asdf.sh ]]; then
  . ~/.asdf/asdf.sh
fi

# May not be in .asdf/asdf.sh if running in nix, for example, so separate check
if type asdf &>/dev/null; then
  # Want to make sure there's some version of NodeJS for some neovim things
  if ! asdf list nodejs &>/dev/null; then
    echo "Installing NodeJS plugin for asdf..."
    asdf plugin add nodejs
  fi

  if [[ "$(asdf list nodejs 2>&1)" =~ "No versions installed" ]]; then
    echo "Installing NodeJS globally via asdf..."
    version=$(asdf latest nodejs)
    asdf install nodejs "${version}"
    asdf global nodejs "${version}"
  fi

  export ASDF_GOLANG_MOD_VERSION_ENABLED=true
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
# TODO: Fix this to be more conditional, it breaks i3...?
#bind 'set bell-style none'

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
for src in ~/.bashrc.d/*; do
	if [[ -f ${src} ]]; then
		source ${src}
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

function aws-connect() {
  aws ssm start-session --target "${1}"
}

function aws-ec2-list() {
  aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" |
    jq -r '.Reservations | .[] | .Instances | .[] | { Id: .InstanceId, Name: (.Tags[] | select(.Key == "Name") | .Value) } | [.Name, .Id] | @tsv' |
    sort |
    column -t
}

function kitty-theme() {
  kitten theme --reload-in=all --config-file-name theme.conf
  kill -SIGUSR1 $(pgrep kitty)
}

function kitty-reload() {
  kill -SIGUSR1 $(pgrep kitty)
}

function fonts() {
  fc-list : family | awk -F, '{print $1}' | grep Nerd | grep -E 'Mono$' | sort -u
}

function show-color() {
    perl -e 'foreach $a(@ARGV){print "\e[48:2::".join(":",unpack("C*",pack("H*",$a)))."m \e[49m "};print "\n"' "$@"
}

function retheme() {
  searchterm="$@"
  if [ -z "${searchterm}" ]; then
    searchterm=mountain
  fi

  if ! type schemer2 &> /dev/null; then
    mkdir -p ~/bin
    GOBIN=~/bin/schemer2 go install github.com/thefryscorer/schemer2@latest
  fi

  echo "Retheming to '${searchterm}'"
  styli.sh -s "${searchterm}"
  colors=$(schemer2 -format img::colors -in ~/.cache/styli.sh/wallpaper.jpg)
  IFS=$'\n'
  for color in ${colors}; do
    # Hijacked from show-color above
    perl -e 'foreach $a(@ARGV){print "\e[48:2::".join(":",unpack("C*",pack("H*",$a)))."m \e[49m"};' "${color:1}"
  done
  schemer2 -format img::kitty -in ~/.cache/styli.sh/wallpaper.jpg > ~/.config/kitty/theme.conf
  kill -SIGUSR1 $(pgrep kitty)
}

# A place for locally built tools to avoid global installs
export PATH="~/bin:${PATH}"

################################################################################
############################ END ###############################################
################################################################################

# Anything past here got auto-added by something and should be moved to ~/.bashrc.d/

