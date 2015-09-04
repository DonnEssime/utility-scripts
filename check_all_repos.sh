#!/bin/bash
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
bold=$(tput bold)
normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)
cwd=$(pwd)
#simply change Desktop/Research/ to the folder that should be crawled
for d in $(find Desktop/Research/ -name .git -type d -exec dirname {} \;) ; do
	echo "${bold}$d${normal}"
	cd "$d"
	git remote update &> /dev/null
	if [ -n "$(git log HEAD..origin/master --oneline)" ];
	then
		echo "${red}Unmerged upstream changes!${normal}"
	else
		echo "${green}Merged all upstream changes.${normal}"
	fi
	if [ -n "$(git status -s)" ]; then
		echo "${red}Uncommitted changes!${normal}"
	else
		echo "${green}No uncommitted changes.${normal}"
	fi
	if [ -n "$(git status | grep up-to-date)" ]; then
		echo "${green}Pushed all downstream changes.${normal}"
	else
		echo "${red}Unpushed downstream changes!${normal}"
	fi
	cd "$cwd"
done
IFS=$SAVEIFS
