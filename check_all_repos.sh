#!/bin/bash
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
bold=$(tput bold)
normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)
cwd=$(pwd)
anyunmerged=false
anyuncommitted=false
anyunpushed=false

CodeRepos=$(find /ipi/research/sdonn/Onderzoek/Code/ -name .git -type d -exec dirname {} \;)
PaperRepo=$(find /ipi/research/sdonn/Papers/ -name .git -type d -exec dirname {} \;)
AllRepos=("${CodeRepos[@]}" "${PaperRepo[@]}")
#simply change code/ to the folder that should be crawled
for d in ${AllRepos[@]} ; do
	echo "${bold}$d${normal}"
	cd "$d"
	git remote update &> /dev/null
	if [ -n "$(git log HEAD..origin/master --oneline)" ];
	then
		echo "${red}Unmerged upstream changes!${normal}"
		anyunmerged=true
	else
		echo "Merged all upstream changes."
	fi
	if [ -n "$(git status -s)" ]; then
		echo "${red}Uncommitted changes!${normal}"
		anyuncommitted=true
	else
		echo "No uncommitted changes."
	fi
	if [ -n "$(git status | grep up-to-date)" ]; then
		echo "Pushed all downstream changes."
	else
		anyunpushed=true
		echo "${red}Unpushed downstream changes!${normal}"
	fi
	cd "$cwd"
done
echo ""
echo ""
if [ "$anyunmerged" == true ] ; then
	echo "${red}There are repositories with upstream changes!${normal}"
fi
if [ "$anyuncommitted" == true ] ; then
	echo "${red}There are repositories with uncommitted changes!${normal}"
fi
if [ "$anyunpushed" == true ] ; then
	echo "${red}There are repositories with unpushed changes!${normal}"
fi
if [ "$anyunpushed" == false ] ; then
if [ "$anyuncommitted" == false ] ; then
if [ "$anyunmerged" == false ] ; then
	echo "${bold}${green}All repositories are perfectly synchronized!${normal}"
fi
fi
fi

IFS=$SAVEIFS
