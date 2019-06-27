#!/bin/env sh
#
# Copyright (C) 2019  StudentIngegneria
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

export LC_ALL=C

askPrompt()
	{
		echo "$2"
		printf "%s" "	➜ "
		#shellcheck disable=SC2162
		read "$1"
	}

checkExecutable()
	{
		if ! command -v "$1" > /dev/null ; then
				echo "ERROR: $1 executable not found in PATH"
				exit 2
			fi
	}

abort()
	{
		echo "[*] Error. Program aborted. Cleaning up"
		eval 'rm -rf $projectName'
		exit $1
	}

scriptName="$( echo "$0" | sed s/^.*\\/// )"
scriptDir="$( echo "$0" | sed s/[\\/]"${scriptName}"// )"

echo
echo "${scriptName} : StudentIngegneria IT Committee git flow bootstrapper"
echo
echo "====================================================================="
echo "Copyright (C) 2019  StudentIngegneria"
echo "This program is free software: you can redistribute it and/or modify"
echo "it under the terms of the GNU General Public License as published by"
echo "the Free Software Foundation, either version 3 of the License, or"
echo "(at your option) any later version."
echo
echo "This program is distributed in the hope that it will be useful,"
echo "but WITHOUT ANY WARRANTY; without even the implied warranty of"
echo "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the"
echo "GNU General Public License for more details."
echo
echo "You should have received a copy of the GNU General Public License"
echo "along with this program.  If not, see <https://www.gnu.org/licenses/>."
echo "======================================================================"
echo
echo

# Check preconditions

checkExecutable git
checkExecutable git-flow

askPrompt projectPath   "Project path ( last element will be the project name )"
askPrompt useOnlineRepo "Sync with an existing online repo ? [yn]"

# shellcheck disable=SC2154
projectName="$( echo "${projectPath}" | sed s/^.*\\/// )"

# TODO: Fix paths if . is specified as project path

# Setup project

mkdir -p "$projectPath" || exit $?
cd "$projectPath"       || exit $?

git init

echo ":: Configuring git flow"

git config --local --add gitflow.branch.master     release
git config --local --add gitflow.branch.develop    dev
git config --local --add gitflow.prefix.feature    feature/
git config --local --add gitflow.prefix.bugfix     bugfix/
git config --local --add gitflow.prefix.release    rc/
git config --local --add gitflow.prefix.hotfix     hotfix/
git config --local --add gitflow.prefix.support    support/
git config --local --add gitflow.prefix.versiontag v
git config --local --add gitflow.path.hooks        .git/hooks

echo ":: Configuring remotes"

while git remote | grep -E '^si$' > /dev/null ; do

		echo -e "\t/!\\ WARNING: \"si\" remote already exists. Delete or rename it"
		echo -e "\t/!\\ Dropping a subshell. Invoke 'exit' when you're done"

		$SHELL

		echo -e "\t:: Resuming script execution\n"

	done

git remote add si "https://github.com/StudentIngegneria/${projectName}"

# shellcheck disable=SC2154
if [ "$useOnlineRepo" = "y" ] ; then

		echo ":: Synchronizing with remote repository"
		git fetch --all -q || abort $?

		echo ":: Setting up branches"
		git checkout -q release
		git checkout -q dev

	else

		echo ":: Bootstrapping branches"
		git checkout -b dev
		git checkout -b dev

		# If log is empty
		if [ "$( git log > /dev/null ; echo $? )" -eq 128 ] ; then

				echo ":: Creating initial commit"
				git commit --allow-empty --quiet -m "Initial commit"
			fi

	fi

echo ":: DONE"
