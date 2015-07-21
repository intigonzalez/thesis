#!/bin/bash

# check if there are fourth parameters
if [ $# -ne 5 ]; then
	echo -e "\033[31mError: You need at least three parameters.\033[30m"
	echo "	Usage: ${0} TAG DIRECTORY_NEW_COPY DIRECTORY_OLD_COPY DIRECTORY_DIFF File_With_Tex_Files_To_Compare"
	exit 1
fi

# check if parameter 2 is an existent directory
if [ ! -e $2 ]; then
	echo -e "\033[31mError: $2 does not exist in the file system.\033[30m"
	echo "	Usage: ${0} TAG DIRECTORY_NEW_COPY DIRECTORY_OLD_COPY DIRECTORY_DIFF File_With_Tex_Files_To_Compare"
	exit 1
fi
if [ ! -d $2 ]; then
	echo -e "\033[31mError: $2 is no directory.\033[30m"
	echo "	Usage: ${0} TAG DIRECTORY_NEW_COPY DIRECTORY_OLD_COPY DIRECTORY_DIFF File_With_Tex_Files_To_Compare"
	exit 1
fi

# check if parameter 3 is an existent directory
if [ ! -e $3 ]; then
	echo -e "\033[31mError: $3 does not exist in the file system.\033[30m"
	echo "	Usage: ${0} TAG DIRECTORY_NEW_COPY DIRECTORY_OLD_COPY DIRECTORY_DIFF File_With_Tex_Files_To_Compare"
	exit 1
fi
if [ ! -d $3 ]; then
	echo -e "\033[31mError: $3 is no directory.\033[30m"
	echo "	Usage: ${0} TAG DIRECTORY_NEW_COPY DIRECTORY_OLD_COPY DIRECTORY_DIFF File_With_Tex_Files_To_Compare"
	exit 1
fi

# check if parameter 4 is an existent directory
if [ ! -e $4 ]; then
	echo -e "\033[31m Error: $4 does not exist in the file system.\033[30m"
	echo "Usage: ${0} TAG DIRECTORY_NEW_COPY DIRECTORY_OLD_COPY DIRECTORY_DIFF File_With_Tex_Files_To_Compare"
	exit 1
fi
if [ ! -d $4 ]; then
	echo -e "\033[31mError: $4 is no directory.\033[30m"
	echo "	Usage: ${0} TAG DIRECTORY_NEW_COPY DIRECTORY_OLD_COPY DIRECTORY_DIFF File_With_Tex_Files_To_Compare"
	exit 1
fi

# check if parameter 5 is an existent file
if [ ! -e $5 ]; then
	echo -e "\033[31mError: $5 does not exist in the file system.\033[30m"
	echo "	Usage: ${0} TAG DIRECTORY_NEW_COPY DIRECTORY_OLD_COPY DIRECTORY_DIFF File_With_Tex_Files_To_Compare"
	exit 1
fi
if [ ! -f $5 ]; then
	echo -e "\033[31mError: $5 is no regular file.\033[30m"
	echo "	Usage: ${0} TAG DIRECTORY_NEW_COPY DIRECTORY_OLD_COPY DIRECTORY_DIFF File_With_Tex_Files_To_Compare"
	exit 1
fi

# calculate which is the appropiate tag
TAG=$1
if [ "${TAG}" = "-" ]; then
	TAG=`git tag -l | sort -g | tail -n 1`
fi

# check if parameter 1 is a valid tag in the repository
NR_TAGS=`git tag -l | grep -x -c ${TAG}`
if [ $NR_TAGS -ne 1 ]; then
	echo -e "\033[31mError: ${TAG} is no valid tag in this repository.\033[30m"
	exit 1
fi

CURRENT_VERSION="$2/"
OLD_VERSION="$3/"
DIFF_VERSION="$4/"

# let's be sure we have the required folders
rm -r -f -d "${CURRENT_VERSION}*"
if [ ! -e "${CURRENT_VERSION}auto-figures" ]; then
	mkdir "${CURRENT_VERSION}auto-figures"
fi
rm -r -f -d "${OLD_VERSION}*"
if [ ! -e "${OLD_VERSION}auto-figures" ]; then
	mkdir "${OLD_VERSION}auto-figures"
fi
rm -r -f -d "${DIFF_VERSION}*"
if [ ! -e "${DIFF_VERSION}auto-figures" ]; then
	mkdir "${DIFF_VERSION}auto-figures"
fi


# chck if there is nothing modifies in the working three
MODIFICATIONS=`git status --porcelain`
if [ "${MODIFICATIONS}" != "" ]; then
	echo -e "\033[31mError: The working tree must not have uncommited modifications.\033[0m"
	echo "	Hint: git add/commit may probe useful here :-)"
	exit 1
fi

# export the current tree as it is to the folder that is being referenced by $2
git checkout-index -a -f --prefix="${CURRENT_VERSION}"

# export the current tree as it is to the folder that is being referenced by $
git checkout-index -a -f --prefix="${DIFF_VERSION}"

# export the specific tag version tree as it is to the folder that is being referenced by $3
git checkout ${TAG}
git checkout-index -a -f --prefix="${OLD_VERSION}"

# let's go back to normal
git checkout master


while read p; do
  #echo "Comparing ${CURRENT_VERSION}$p against ${OLD_VERSION}$p and puting result in ${DIFF_VERSION}$p"
  latexdiff ${OLD_VERSION}$p ${CURRENT_VERSION}/$p > ${DIFF_VERSION}$p
done < $5


