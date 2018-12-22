#!/bin/bash

# Just a Test
############################################
STRING="_bash_init.sh"
#print variable on a screen
echo $STRING
############################################

# Bash functions
############################################

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

# Get the absoluty path for the Scons_utils directory
SCRIPTS_BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Add the current directory to the PATH
pathadd $SCRIPTS_BASE_DIR after 

# Export the new path to the system
export PATH

# Test
echo $PATH
