shopt -s checkwinsize
shopt -s histappend

####################
#### COLORS ########
####################

# For vim/tmux colors... change this to switch between light/dark
export EVERTRAS_SCREEN_MODE=${EVERTRAS_SCREEN_MODE:-dark}
export EVERTRAS_SCREEN_TRANSPARENCY=${EVERTRAS_SCREEN_TRANSPARENCY:-true}
export EVERTRAS_PROMPT_MODE=${EVERTRAS_PROMPT_MODE:-normal}

COLOR_RESET="\033[0m"
COLOR_RESET_BG="\033[49m"
COLOR_LIGHT_GREEN="\033[38;5;2m"
COLOR_SEA_GREEN="\033[38;5;42m"
COLOR_ORANGE="\033[38;5;208m"
COLOR_RED="\033[38;5;196m"

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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Adds color to ls (mac thing)
export CLICOLOR=true

# Colorize all greps when appropriate
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Quick access to tweak things
alias editbash='nvim ~/.bashrc'
alias reloadbash='source ~/.bashrc'
alias editvim='nvim ~/.vimrc'
alias edittmux='nvim ~/.tmux.conf'

# Prompt
fg_rgb() {
	echo -ne "\033[38;2;${1};${2};${3}m"
}

bg_rgb() {
	echo -ne "\033[48;2;${1};${2};${3}m"
}

if [[ $EVERTRAS_SCREEN_MODE == dark ]]; then
	COLOR_A_R=20
	COLOR_A_G=0
	COLOR_A_B=0

	COLOR_B_R=200
	COLOR_B_G=100
	COLOR_B_B=150

	COLOR_B_FG=$(fg_rgb ${COLOR_B_R} ${COLOR_B_G} ${COLOR_B_B})
	COLOR_B_BG=$(bg_rgb ${COLOR_B_R} ${COLOR_B_G} ${COLOR_B_B})
	COLOR_A_FG=$(fg_rgb ${COLOR_A_R} ${COLOR_A_G} ${COLOR_A_B})
	COLOR_A_BG=$(bg_rgb ${COLOR_A_R} ${COLOR_A_G} ${COLOR_A_B})
else
	COLOR_A_FG=$(fg_rgb 177 124 62)
	COLOR_A_BG=$(bg_rgb 177 124 62)
	COLOR_B_FG=$(fg_rgb 220 200 150)
	COLOR_B_BG=$(bg_rgb 220 200 150)
fi

success_symbol() {
	if [[ "$?" == 0 ]]; then
		echo -en "\[${COLOR_A_FG}\]✔"
	else
		echo -en "\[${COLOR_A_FG}\]✖"
	fi
}

parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/  \1/'
}

set_bash_prompt() {
	PS1="\[${COLOR_B_FG}${COLOR_RESET_BG}\]\[${COLOR_B_BG}\]$(success_symbol)\[${COLOR_A_FG}\]    \w$(parse_git_branch)\[${COLOR_B_FG}${COLOR_RESET_BG}\]\[${COLOR_RESET}\] "
}

if [[ $EVERTRAS_PROMPT_MODE == simple ]]; then
	PS1="\[${COLOR_B_FG}\]\w \[${COLOR_B_FG}\]$\[${COLOR_RESET}\] "
else
	PROMPT_COMMAND=set_bash_prompt
fi

export TERM=xterm-256color

# Bash completions
export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
HOMEBREW_PREFIX=$(brew --prefix)
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# Ruby
eval "$(rbenv init -)"

alias vim=nvim

PATH=${PATH}:~/go/bin:/Applications/TexturePacker.app/Contents/MacOS/

# Perl
if [ -f ~/perl5/perlbrew/etc/bashrc ]; then
	source ~/perl5/perlbrew/etc/bashrc
fi

# Random useful utility functions
docker-nuke-volumes() {
	docker volume ls | tail -n+2 | awk '{print $2}' | xargs docker volume rm
}

# Use nvim for all our editing needs
export EDITOR=nvim
export VISUAL=nvim

# We're a dirty 'murican
export LC_ALL=en_US.UTF-8

# Make GPG signing happen in the correct terminal
export GPG_TTY="$(tty)"

# Typing "npm run" is oddly annoying
alias nr='npm run'

