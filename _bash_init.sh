#!/bin/bash

############################################
#set -e

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

# If tools.config file not present, generate a template.
if [ ! -f $SCRIPTS_BASE_DIR/tools.config ]; then
    echo "tools.config not present. Generating a template ... Please fill out the tools path in tools.config"
    echo '#!/bin/bash

# Paths for tools

# Python Path
PYTHON_PATH=""

# Python executable
PYTHON_EXECUTABLE=""

# Custom flags for python
PYTHON_FLAGS=""

# Scons Path
SCONS_PATH=""

# Scons main script
SCONS_MAIN=""

# Custom flags for scons
SCONS_FLAG=""' > $SCRIPTS_BASE_DIR/tools.config
fi

# Add the current directory to the PATH
pathadd $SCRIPTS_BASE_DIR after 

# Export the new path to the system
export PATH

# Test
#echo $PATH
