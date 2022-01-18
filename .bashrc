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

# For vim/tmux colors... change this to switch between light/dark
export EVERTRAS_SCREEN_MODE=${EVERTRAS_SCREEN_MODE:-dark}
export EVERTRAS_SCREEN_TRANSPARENCY=${EVERTRAS_SCREEN_TRANSPARENCY:-false}
export EVERTRAS_PROMPT_MODE=${EVERTRAS_PROMPT_MODE:-normal}

COLOR_RESET="\033[0m"
COLOR_RESET_BG="\033[49m"
COLOR_LIGHT_GREEN="\033[38;5;2m"
COLOR_SEA_GREEN="\033[38;5;42m"
COLOR_ORANGE="\033[38;5;208m"
COLOR_RED="\033[38;5;196m"

everbash_fg_rgb() {
	echo -ne "\033[38;2;${1};${2};${3}m"
}

everbash_bg_rgb() {
	echo -ne "\033[48;2;${1};${2};${3}m"
}

everbash_prompt_colors() {
	COLOR_A_R="${1}"
	COLOR_A_G="${2}"
	COLOR_A_B="${3}"

	COLOR_B_R="${4}"
	COLOR_B_G="${5}"
	COLOR_B_B="${6}"

	COLOR_GIT_FG_R="${7}"
	COLOR_GIT_FG_G="${8}"
	COLOR_GIT_FG_B="${9}"

	COLOR_GIT_BG_R="${10}"
	COLOR_GIT_BG_G="${11}"
	COLOR_GIT_BG_B="${12}"
}

if [[ $EVERTRAS_SCREEN_MODE == dark ]]; then

	everbash_prompt_colors \
		0 0 0 \
		0 150 220 \
		0 0 0 \
		250 120 20

elif [[ $EVERTRAS_SCREEN_MODE == neutral ]]; then

	everbash_prompt_colors \
		20 0 0 \
		100 200 200 \
		20 20 20 \
		150 150 200

else

	everbash_prompt_colors \
		177 124 62 \
		220 200 150 \
		150 150 200 \
		150 150 200

fi

EVERTRAS_THEME=forest

EVERTRAS_THEME_FILE=~/.bashrc.d/themes/${EVERTRAS_THEME}.sh

if [[ -f "${EVERTRAS_THEME_FILE}" ]]; then
	source "${EVERTRAS_THEME_FILE}"
fi

COLOR_B_FG=$(everbash_fg_rgb ${COLOR_B_R} ${COLOR_B_G} ${COLOR_B_B})
COLOR_B_BG=$(everbash_bg_rgb ${COLOR_B_R} ${COLOR_B_G} ${COLOR_B_B})
COLOR_A_FG=$(everbash_fg_rgb ${COLOR_A_R} ${COLOR_A_G} ${COLOR_A_B})
COLOR_A_BG=$(everbash_bg_rgb ${COLOR_A_R} ${COLOR_A_G} ${COLOR_A_B})
COLOR_GIT_FG=$(everbash_fg_rgb ${COLOR_GIT_FG_R} ${COLOR_GIT_FG_G} ${COLOR_GIT_FG_B})
COLOR_GIT_BG=$(everbash_bg_rgb ${COLOR_GIT_BG_R} ${COLOR_GIT_BG_G} ${COLOR_GIT_BG_B})

everbash_success_symbol() {
	if [[ "$?" == 0 ]]; then
		echo -en "✔"
	else
		echo -en "✖"
	fi
}

parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/  \1 /'
}

everbash_set_bash_prompt() {
	PS1="\[${COLOR_B_BG}${COLOR_A_FG}\] \w \[${COLOR_GIT_FG}${COLOR_GIT_BG}\]$(parse_git_branch)\[${COLOR_RESET}\]\n$(everbash_success_symbol)\[${COLOR_RESET}\] "
}

if [[ $EVERTRAS_PROMPT_MODE == simple ]]; then
	PS1="\[${COLOR_B_FG}\]\w \[${COLOR_B_FG}\]$\[${COLOR_RESET}\] "
else
	PROMPT_COMMAND=everbash_set_bash_prompt
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

################################################################################
############################ END ###############################################
################################################################################

# Anything past here got auto-added by something and should be moved to ~/.bashrc.d/

