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

COLOR_B_FG=$(everbash_fg_rgb ${COLOR_B_R} ${COLOR_B_G} ${COLOR_B_B})
COLOR_B_BG=$(everbash_bg_rgb ${COLOR_B_R} ${COLOR_B_G} ${COLOR_B_B})
COLOR_A_FG=$(everbash_fg_rgb ${COLOR_A_R} ${COLOR_A_G} ${COLOR_A_B})
COLOR_A_BG=$(everbash_bg_rgb ${COLOR_A_R} ${COLOR_A_G} ${COLOR_A_B})
COLOR_GIT_FG=$(everbash_fg_rgb ${COLOR_GIT_FG_R} ${COLOR_GIT_FG_G} ${COLOR_GIT_FG_B})
COLOR_GIT_BG=$(everbash_bg_rgb ${COLOR_GIT_BG_R} ${COLOR_GIT_BG_G} ${COLOR_GIT_BG_B})

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

# Forest theme
everbash_prompt_colors \
	0 0 0 \
	100 200 120 \
	0 0 0 \
	220 130 90

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

parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/  \1 /'
}

everbash_success_symbol() {
	if [[ "$?" == 0 ]]; then
		echo -en "✔"
	else
		echo -en "✖"
	fi
}

everbash_set_bash_prompt() {
	PS1="\[${COLOR_B_BG}${COLOR_A_FG}\] \w \[${COLOR_GIT_FG}${COLOR_GIT_BG}\]$(parse_git_branch)\[${COLOR_RESET}\]\n$(everbash_success_symbol)\[${COLOR_RESET}\] "
}

if [[ $EVERTRAS_PROMPT_MODE == simple ]]; then
	PS1="\[${COLOR_B_FG}\]\w \[${COLOR_B_FG}\]$\[${COLOR_RESET}\] "
else
	PROMPT_COMMAND=everbash_set_bash_prompt
fi
