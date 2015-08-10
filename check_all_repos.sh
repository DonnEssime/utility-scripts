#!/bin/bash
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
bold=$(tput bold)
normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)
cwd=$(pwd)
for d in $(find Desktop/Research/ -name .git -type d -exec dirname {} \;) ; do
	echo "${bold}$d${normal}"
	cd "$d"
	git remote update &> /dev/null
	if [ -n "$(git log HEAD..origin/master --oneline)" ];
	then
		echo "${red}Upstream changes!${normal}"
	else
		echo "${green}No upstream changes.${normal}"
	fi
	if [ -n "$(git status -s)" ]; then
		echo "${red}Uncommitted changes!${normal}"
	else
		echo "${green}No uncommitted changes.${normal}"
	fi
	if [ -n "$(git status | grep up-to-date)" ]; then
		echo "${green}Remote synchronized with local.${normal}"
	else
		echo "${red}Remote not synchronized with local!${normal}"
	fi
	cd "$cwd"
done
IFS=$SAVEIFS
