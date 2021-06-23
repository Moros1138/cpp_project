#!/bin/sh

echo 'Building the script...'

# move into the archive folder
cd archive

# create the zipped archive
tar -czf ../cpp_project.tar.gz .

# move back
cd ..

# generate the first portion of the script from src/main.sh
cat src/main.sh > cpp_project

# base64 encode the zipped archive and add it to the end of the script
base64 cpp_project.tar.gz >> cpp_project

# remove the archive (we don't need it anymore)
rm cpp_project.tar.gz

# make the script executable
chmod +x cpp_project

# we're done
echo 'Script has been generated in: cpp_project'
echo ''
echo 'Install the script by copying it into your system path (eg. ~/.local/bin)'
