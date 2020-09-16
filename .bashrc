# Use this to profile load times and find slow things
#PS4='+ $EPOCHREALTIME\011 '
#set -x

################################################################################
######################### PROMPT/THEME #########################################
################################################################################

export TERM=xterm-256color

# Adds color to ls (mac thing)
export CLICOLOR=true

# For vim/tmux colors... change this to switch between light/dark
export EVERTRAS_SCREEN_MODE=${EVERTRAS_SCREEN_MODE:-light}
export EVERTRAS_SCREEN_TRANSPARENCY=${EVERTRAS_SCREEN_TRANSPARENCY:-true}
export EVERTRAS_PROMPT_MODE=${EVERTRAS_PROMPT_MODE:-normal}

COLOR_RESET="\033[0m"
COLOR_RESET_BG="\033[49m"
COLOR_LIGHT_GREEN="\033[38;5;2m"
COLOR_SEA_GREEN="\033[38;5;42m"
COLOR_ORANGE="\033[38;5;208m"
COLOR_RED="\033[38;5;196m"

fg_rgb() {
	echo -ne "\033[38;2;${1};${2};${3}m"
}

bg_rgb() {
	echo -ne "\033[48;2;${1};${2};${3}m"
}

if [[ $EVERTRAS_SCREEN_MODE == dark ]]; then
	COLOR_A_R=0
	COLOR_A_G=0
	COLOR_A_B=0

	COLOR_B_R=0
	COLOR_B_G=150
	COLOR_B_B=220

	COLOR_GIT_FG_R=00
	COLOR_GIT_FG_G=00
	COLOR_GIT_FG_B=00

	COLOR_GIT_BG_R=250
	COLOR_GIT_BG_G=120
	COLOR_GIT_BG_B=20

	COLOR_B_FG=$(fg_rgb ${COLOR_B_R} ${COLOR_B_G} ${COLOR_B_B})
	COLOR_B_BG=$(bg_rgb ${COLOR_B_R} ${COLOR_B_G} ${COLOR_B_B})
	COLOR_A_FG=$(fg_rgb ${COLOR_A_R} ${COLOR_A_G} ${COLOR_A_B})
	COLOR_A_BG=$(bg_rgb ${COLOR_A_R} ${COLOR_A_G} ${COLOR_A_B})
	COLOR_GIT_FG=$(fg_rgb ${COLOR_GIT_FG_R} ${COLOR_GIT_FG_G} ${COLOR_GIT_FG_B})
	COLOR_GIT_BG=$(bg_rgb ${COLOR_GIT_BG_R} ${COLOR_GIT_BG_G} ${COLOR_GIT_BG_B})
elif [[ $EVERTRAS_SCREEN_MODE == neutral ]]; then
	COLOR_A_R=20
	COLOR_A_G=0
	COLOR_A_B=0

	COLOR_B_R=100
	COLOR_B_G=200
	COLOR_B_B=200

	COLOR_GIT_FG_R=20
	COLOR_GIT_FG_G=20
	COLOR_GIT_FG_B=20

	COLOR_GIT_BG_R=150
	COLOR_GIT_BG_G=150
	COLOR_GIT_BG_B=200

	COLOR_B_FG=$(fg_rgb ${COLOR_B_R} ${COLOR_B_G} ${COLOR_B_B})
	COLOR_B_BG=$(bg_rgb ${COLOR_B_R} ${COLOR_B_G} ${COLOR_B_B})
	COLOR_A_FG=$(fg_rgb ${COLOR_A_R} ${COLOR_A_G} ${COLOR_A_B})
	COLOR_A_BG=$(bg_rgb ${COLOR_A_R} ${COLOR_A_G} ${COLOR_A_B})
	COLOR_GIT_FG=$(fg_rgb ${COLOR_GIT_FG_R} ${COLOR_GIT_FG_G} ${COLOR_GIT_FG_B})
	COLOR_GIT_BG=$(bg_rgb ${COLOR_GIT_BG_R} ${COLOR_GIT_BG_G} ${COLOR_GIT_BG_B})
else
	COLOR_GIT_BG_R=150
	COLOR_GIT_BG_G=150
	COLOR_GIT_BG_B=200

	COLOR_A_FG=$(fg_rgb 177 124 62)
	COLOR_A_BG=$(bg_rgb 177 124 62)
	COLOR_B_FG=$(fg_rgb 220 200 150)
	COLOR_B_BG=$(bg_rgb 220 200 150)
	COLOR_GIT_FG=$(fg_rgb ${COLOR_GIT_FG_R} ${COLOR_GIT_FG_G} ${COLOR_GIT_FG_B})
	COLOR_GIT_BG=$(bg_rgb ${COLOR_GIT_BG_R} ${COLOR_GIT_BG_G} ${COLOR_GIT_BG_B})
fi

success_symbol() {
	if [[ "$?" == 0 ]]; then
		echo -en "✔"
	else
		echo -en "✖"
	fi
}

parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/  \1 /'
}

set_bash_prompt() {
	#PS1="\[${COLOR_B_FG}${COLOR_RESET_BG}\]\[${COLOR_B_BG}\]$(success_symbol)\[${COLOR_A_FG}\]    \w$(parse_git_branch)\[${COLOR_B_FG}${COLOR_RESET_BG}\]\[${COLOR_RESET}\] "
	PS1="\[${COLOR_B_BG}${COLOR_A_FG}\] \w \[${COLOR_GIT_FG}${COLOR_GIT_BG}\]$(parse_git_branch)\[${COLOR_RESET}\]\n$(success_symbol)\[${COLOR_RESET}\] "
}

if [[ $EVERTRAS_PROMPT_MODE == simple ]]; then
	PS1="\[${COLOR_B_FG}\]\w \[${COLOR_B_FG}\]$\[${COLOR_RESET}\] "
else
	PROMPT_COMMAND=set_bash_prompt
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
alias usc='kubectl config use-context'

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

# Don't show control characters
stty -echoctl

# Use nvim for all our editing needs
export EDITOR=nvim
export VISUAL=nvim

# We're a dirty 'murican
export LC_ALL=en_US.UTF-8

# Make GPG signing happen in the correct terminal
export GPG_TTY="$(tty)"

# Machine-specific bash stuff should go in this directory
for SRCFILE in ~/.bashrc.d/*; do
	source ${SRCFILE}
done

################################################################################
############################ END ###############################################
################################################################################

# Anything past here got auto-added by something and should be moved to ~/.bashrc.d/

