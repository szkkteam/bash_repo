#!/bin/bash

#Debug switch
#set -x
############################################

set -e

CONFIG_FILE="tools.config"

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
    return
}

# Add path to path enviroment variable is not exists
pathadd() {
    newelement=${1%/}
    if [ -d "$1" ] && ! echo $PATH | grep -E -q "(^|:)$newelement($|:)" ; then
        if [ "$2" = "after" ] ; then
            PATH="$PATH:$newelement"
        else
            PATH="$newelement:$PATH"
        fi
    fi
}

# Remove path from enviroment variable  
pathrm() {
    PATH="$(echo $PATH | sed -e "s;\(^\|:\)${1%/}\(:\|\$\);\1\2;g" -e 's;^:\|:$;;g' -e 's;::;:;g')"
}

if [ -z $(type $CONFIG_FILE) ]; then
	error_exit "tools.config is not exists. Please run _bash_init.sh first."
else
    source $CONFIG_FILE
fi

function check_and_search
{
	local LOC_PYTHON_PATH=$1

	if [ -z "$LOC_PYTHON_PATH" ]; then
		LOC_PYTHON_PATH=$(type $2)
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

# Get the path of python. If the variable is still empty, python is not present on the system, or not added to env path
PYTHON_PATH=$(check_and_search "$PYTHON_PATH" "$PYTHON_EXECUTABLE")
if [ "$PYTHON_PATH" != "" ]; then
    # Add the current directory to the PATH
    pathadd $PYTHON_PATH after 
    echo "PYTHON_PATH=$PYTHON_PATH"
else 
	error_exit "PYTHON_PATH= is empty. Python executable is not found."
fi

# Get the path of scons. If the variable is still empty, scons is not present on the system, or not added to env path
SCONS_PATH=$(check_and_search "$SCONS_PATH" "$SCONS_MAIN")
if [ "$SCONS_PATH" != "" ]; then
    # Add the current directory to the PATH
    pathadd $SCONS_PATH after 
    echo "SCONS_PATH=$SCONS_PATH"
else 
	error_exit "SCONS_PATH= is empty. Scons package is not found."
fi

# Export the path variable.
export PATH
