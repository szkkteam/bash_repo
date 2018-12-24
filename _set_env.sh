#!/bin/bash

#Debug switch
#set -x
############################################

# Bash functions
############################################
function error_exit
{

#   ----------------------------------------------------------------
#   Function for exit due to fatal program error
#       Accepts 1 argument:
#           string containing descriptive error message
#   ---------------------------------------------------------------- 

    echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
    exit 1
}

function check_and_search
{
	local LOC_PYTHON_PATH=$1

	if [ -z "$LOC_PYTHON_PATH" ]; then
		LOC_PYTHON_PATH=$(which $2)
		if [ -z "$LOC_PYTHON_PATH" ]; then
			error_exit "$2 is not found."
		fi
	fi
	#eval "$1='$LOC_PYTHON_PATH'"
	echo "$LOC_PYTHON_PATH"
}

PROGNAME=$(basename $0)


PLATFORM_VAR="none"

# Check if the enviroment input argument is exists
if [ -z "$1" ]
  then
	case "$OSTYPE" in
	  solaris*) echo "Build platform $OSTYPE is not supported!" ;; #error_exit "Build platform $OSTYPE is not supported!"
	  darwin*)  echo "Build platform $OSTYPE is not supported!" ;; #error_exit "Build platform $OSTYPE is not supported!"
	  linux*)   PLATFORM_VAR="unix" ;;
	  bsd*)     echo "Build platform $OSTYPE is not supported!" ;; #error_exit "Build platform $OSTYPE is not supported!"
	  msys*)    PLATFORM_VAR="win" ;;
	  *)        echo "Build platform $OSTYPE is not supported!" ;; #error_exit "Build platform $OSTYPE is not supported!"
	esac

	echo "You can specify directly the build platform. Valid arguments are [unix, win]. Build platform picked automatically: $PLATFORM_VAR" 
else 
	case "$1" in
		win*) 	PLATFORM_VAR="win" ;;
	  	unix*)  PLATFORM_VAR="unix" ;;
	    *)      echo "Build platform $1 is not supported!" ;;
	esac
fi

if [ "$PLATFORM_VAR" != "none" ]; then
	export PLATFORM_TYPE=$PLATFORM_VAR
	echo "PLATFORM_TYPE=$PLATFORM_TYPE"
else 
	error_exit "Build platform is not supported!"
fi

source tools.config

# Get the path of python. If the variable is still empty, python is not present on the system, or not added to env path
PYTHON_PATH=$(check_and_search "$PYTHON_PATH" "python")

SCONS_PATH=$(check_and_search "$SCONS_PATH" "scons")
#if [ -z "$PYTHON_PATH" ]; then
#	PYTHON_PATH=$(which python)
#fi
#if [ -z "$PYTHON_PATH" ]; then
#	PYTHON_PATH=$(which python)
#fi
#
#if [ -z "$SCONS_PATH" ]; then
#	SCONS_PATH=$(which scons)
#fi

echo "PYTHON_PATH=$PYTHON_PATH"
echo "SCONS_PATH=$SCONS_PATH"
