#!/bin/bash
# Fetch latest code
git fetch origin
git reset --hard origin/main

# Update submodules
git submodule sync
git submodule update --init --recursive

# Dependencies
if [[ ! -d ~/.cache/tools-venv ]] ; then
	virtualenv ~/.cache/tools-venv
fi
. ~/.cache/tools-venv/bin/activate
pip install -r requirements.txt

# Apply the changes
make install GALAXY_SERVER=http://bioinf-galactus/ GALAXY_API_KEY=$GALAXY_ADMIN_API_KEY

# Install workflows
find . -name '*.ga' -exec workflow-install -g http://bioinf-galactus/ -a $GALAXY_ADMIN_API_KEY -w '{}' \;
