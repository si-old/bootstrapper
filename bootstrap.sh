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

scriptName="$( echo "$0" | sed s/^.*\\/// )"
scriptDir="$( echo "$0" | sed s/[\\/]"${scriptName}"// )"

echo
echo "${scriptName} : StudentIngegneria IT Committee project bootstrapper"
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
echo "WARNING: THIS SCRIPT IS DESTRUCTIVE, use only to create new projects"
echo

# Check preconditions

if ! command -v git > /dev/null ; then
	echo "ERROR: Git executable not found in PATH"
	exit 2
fi

askPrompt projectPath "Project path ( last element will be the project name )"

# shellcheck disable=SC2154
projectName="$( echo "${projectPath}" | sed s/^.*\\/// )"

echo
askPrompt projectIsPublic "Will this be uploaded to GitHub ? [yn]"

# Create project

mkdir -p "$projectPath" || exit $?
cp -rf "${scriptDir}/gitdir" "${projectPath}/.git" || exit $?

cd "$projectPath" || exit $?

# shellcheck disable=SC2154
if [ "$projectIsPublic" = "y" ] ; then
	git remote set-url si "https://github.com/StudentIngegneria/${projectName}"
fi

echo DONE
