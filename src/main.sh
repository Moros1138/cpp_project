#!/bin/bash
###############################################################################
#          VS Code: C/C++ Project Template
#                     v0.02
#
#       By: Moros Smith <moros1138@gmail.com>
###############################################################################

# find ourself so we can open ourself later
SELF="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SELF="$SELF/cpp_project"

# requires curl
if [ -z "$(which curl)" ]; then
	echo 'This script requires curl, try "sudo apt install curl"'
    exit 1
fi

# requires git
if [ -z "$(which git)" ]; then
	echo 'This script requires git, try "sudo apt install git"'
    exit 1
fi

# if we make it here, our environment is ready!

# prompt for the project name
read -p "Project Name? (default: MyApp) " project_name

# empty, at first, to keep track of which libraries to download
project_libs=""

# prompt for PixelGameEngine
read -p "Use olcPixelGameEngine? (y/n) " temp
if [ "$temp" = "y" ]; then project_libs="${project_libs} olcPixelGameEngine"; fi

# prompt for Sound PGEX
read -p "Use olcPGEX_Sound? (y/n) " temp
if [ "$temp" = "y" ]; then project_libs="${project_libs} olcPGEX_Sound"; temp=""; fi

# prompt for Animated Sprite PGEX
read -p "Use olcPGEX_AnimatedSprite? (y/n) " temp
if [ "$temp" = "y" ]; then project_libs="${project_libs} olcPGEX_AnimatedSprite"; temp=""; fi

# prompt for Gamepad PGEX
read -p "Use olcPGEX_Gamepad? (y/n) " temp
if [ "$temp" = "y" ]; then project_libs="${project_libs} olcPGEX_Gamepad"; temp=""; fi

# prompt for Tileson
read -p "Use Tileson? (y/n) " temp
if [ "$temp" = "y" ]; then project_libs="${project_libs} Tileson"; temp=""; fi


# if the project name was left empty, use MyApp as default
if [ -z "$project_name" ]; then
	project_name=MyApp
fi

# create project directory
mkdir $project_name

# move into the project directory
cd $project_name

###############################################################################
# START: LOAD THE ARCHIVE FROM THE END OF THE SCRIPT
###############################################################################
# In order to simplify the creation of the project, we have added an archive
# in base64 format at the end of this script. The following mess allows us
# to load the archive, decode it, and extract it.
###############################################################################

# This finds the line number where the base64 encoded archive lies
PAYLOAD_LINE=$(awk '/^__PAYLOAD_BEGINS__/ { print NR + 1; exit 0; }' $0)

# This bit does a few things in one line
#
#   1.  uses tail on this script and outputs everything past the
#       __PAYLOAD_BEGINS__ marker, which we assume is a base64
#       encoded archive file.
#
#   2.  decodes the base64 data and pipes it
#
#   3.  uses tar to unzip and extract the archive

tail -n +${PAYLOAD_LINE} $SELF | base64 --decode - | tar xz

###############################################################################
# END: LOAD THE ARCHIVE FROM THE END OF THE SCRIPT
###############################################################################

# cycle through the libraries, one at a time
for lib in $project_libs
do
    
    echo "Retrieving $lib"
    
    # Javid's olc::PixelGameEngine
    #
    # https://github.com/OneLoneCoder/olcPixelGameEngine
    if [ "$lib" = "olcPixelGameEngine" ]; then
        curl -L https://github.com/OneLoneCoder/olcPixelGameEngine/releases/download/v2.16/olcPixelGameEngine.h -o include/olcPixelGameEngine.h
        curl https://raw.githubusercontent.com/OneLoneCoder/olcPixelGameEngine/master/olcExampleProgram.cpp -o src/main.cpp
    fi
    
    # Javid's Sound PGEX
    #
    # https://github.com/OneLoneCoder/olcPixelGameEngine/blob/master/Extensions/olcPGEX_Sound.h
    if [ "$lib" = "olcPGEX_Sound" ]; then
        curl https://raw.githubusercontent.com/OneLoneCoder/olcPixelGameEngine/master/Extensions/olcPGEX_Sound.h -o include/olcPGEX_Sound.h
    fi
    
    # Gorbit's Gamepad PGEX
    #
    # https://github.com/gorbit99/olcPGEX_Gamepad
    if [ "$lib" = "olcPGEX_Gamepad" ]; then
        curl https://raw.githubusercontent.com/gorbit99/olcPGEX_Gamepad/master/olcPGEX_Gamepad.h -o include/olcPGEX_Gamepad.h
    fi
    
    # SaladinAkara's Animated Sprite PGEX
    #
    # https://github.com/matt-hayward/olcPGEX_AnimatedSprite
    if [ "$lib" = "olcPGEX_AnimatedSprite" ]; then
        curl https://raw.githubusercontent.com/matt-hayward/olcPGEX_AnimatedSprite/master/olcPGEX_AnimatedSprite.h -o include/olcPGEX_AnimatedSprite.h
    fi
    
    # Robin Berg Pettersen's Tileson
    #
    # https://github.com/SSBMTonberry/tileson
    if [ "$lib" = "Tileson" ]; then
        curl -L https://github.com/SSBMTonberry/tileson/releases/download/v1.3.0/tileson.hpp -o include/tileson.hpp
    fi

done

# string replacements
sed -i "s/{{BINARY_NAME}}/$project_name/g" Makefile
sed -i "s/{{BINARY_NAME}}/$project_name/g" .gitignore
sed -i "s/{{BINARY_NAME}}/$project_name/g" .vscode/launch.json

# prompt for Git repository
read -p "Initialize a Git Repository? (y/n) " temp
if [ "$temp" = "y" ]; then git init; git add .; git commit -m "initial commit"; temp=""; fi

# prompt for opening the project in VS Code
read -p "Open project in VS Code? (y/n) " temp
if [ "$temp" = "y" ]; then code .; temp=""; fi

# navigate back to the directory we came from
cd ..

# we're done!
echo "Done!"

###############################################################################
# DO NOT EDIT BEYOND THIS POINT UNLESS YOU KNOW PRECISELY WHAT YOU ARE DOING!
###############################################################################
exit 0
__PAYLOAD_BEGINS__
