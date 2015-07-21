#!/bin/bash

# check if there are fourth parameters
if [ $# -ne 5 ]; then
	echo echo "Usage: ${0} TAG DIRECTORY0 DIRECTORY1"
	echo "You need at least three parameters."
	exit 1
fi

# check if parameter 2 is an existent directory
if [ ! -e $2 ]; then
	echo echo "Usage: ${0} TAG DIRECTORY0 DIRECTORY1"
	echo "$2 does not exist in the file system."
	exit 1
fi
if [ ! -d $2 ]; then
	echo echo "Usage: ${0} TAG DIRECTORY0 DIRECTORY1"
	echo "$2 is no directory."
	exit 1
fi

# check if parameter 3 is an existent directory
if [ ! -e $3 ]; then
	echo echo "Usage: ${0} TAG DIRECTORY0 DIRECTORY1"
	echo "$3 does not exist in the file system."
	exit 1
fi
if [ ! -d $3 ]; then
	echo echo "Usage: ${0} TAG DIRECTORY0 DIRECTORY1"
	echo "$3 is no directory."
	exit 1
fi

# check if parameter 4 is an existent directory
if [ ! -e $4 ]; then
	echo echo "Usage: ${0} TAG DIRECTORY0 DIRECTORY1"
	echo "$4 does not exist in the file system."
	exit 1
fi
if [ ! -d $4 ]; then
	echo echo "Usage: ${0} TAG DIRECTORY0 DIRECTORY1"
	echo "$4 is no directory."
	exit 1
fi

# check if parameter 5 is an existent file
if [ ! -e $5 ]; then
	echo echo "Usage: ${0} TAG DIRECTORY0 DIRECTORY1"
	echo "$5 does not exist in the file system."
	exit 1
fi
if [ ! -f $5 ]; then
	echo echo "Usage: ${0} TAG DIRECTORY0 DIRECTORY1"
	echo "$5 is no regular file."
	exit 1
fi

# check if parameter 1 is a valid tag in the repository
NR_TAGS=`git tag -l | grep -x -c $1`
if [ $NR_TAGS -ne 1 ]; then
	echo "Hey: $1 is no valid tag in this repository."
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


# calculate which is the last tag
TAG=$1
if ( ${TAG} == "-" ); then
	TAG=`git tag -l | sort -g | tail -n 1`
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


