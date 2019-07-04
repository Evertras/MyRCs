shopt -s checkwinsize
shopt -s histappend

EDITOR=nvim
VISUAL=nvim

####################
#### COLORS ########
####################

# For vim/tmux colors... change this to switch between light/dark
export EVERTRAS_SCREEN_MODE=light
# export EVERTRAS_SCREEN_MODE=dark
export EVERTRAS_SCREEN_TRANSPARENCY=false

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
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

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

success_symbol() {
	if [[ "$?" == 0 ]]; then
		echo -en "\[\033[38;2;62;124;177m\]✔"
	else
		echo -en "\[\033[38;2;200;80;0m\]✖"
	fi
}

if [[ $EVERTRAS_SCREEN_MODE == dark ]]; then
	COLOR_A_FG=$(fg_rgb 62 124 177)
	COLOR_A_BG=$(bg_rgb 62 124 177)
	COLOR_B_FG=$(fg_rgb 219 228 238)
	COLOR_B_BG=$(bg_rgb 219 228 238)
else
	COLOR_A_FG=$(fg_rgb 177 124 62)
	COLOR_A_BG=$(bg_rgb 177 124 62)
	COLOR_B_FG=$(fg_rgb 220 200 150)
	COLOR_B_BG=$(bg_rgb 220 200 150)
fi

parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/  \1/'
}

set_bash_prompt() {
	PS1="\[${COLOR_B_FG}${COLOR_RESET_BG}\]\[${COLOR_B_BG}\]$(success_symbol)\[${COLOR_A_FG}\]  \w$(parse_git_branch)\[${COLOR_B_FG}${COLOR_RESET_BG}\]\[${COLOR_RESET}\] "
}

PROMPT_COMMAND=set_bash_prompt

export TERM=xterm-256color

# Bash completions
HOMEBREW_PREFIX=$(brew --prefix)
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# Ruby
eval "$(rbenv init -)"

alias vim=nvim

PATH=${PATH}:~/go/bin:/Applications/TexturePacker.app/Contents/MacOS/

