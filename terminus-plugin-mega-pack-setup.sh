#!/bin/sh

# Exit on error
set -e

# Check for Composer, before anything else.
echo "\n"
echo "Thanks for checking out this mega pack of Terminus plugins\n"
sleep 2
if ! [ -x "$(command -v composer)" ]; then
  echo "I noticed Composer is not installed. It's needed. I'll try to install Composer for you..."
  # Composer not found, so let's run the install steps for them
  curl -sS https://getcomposer.org/installer | php
  mv composer.phar /usr/local/bin/composer
  chmod +x /usr/local/bin/composer
  echo "Boosting Composer a little. Give me a moment."
  # Global plugin for Composer speed boost (as of 2019)
  composer global require hirak/prestissimo
  # Double check if Composer is now available, otherwise bail.
  if ! [ -x "$(command -v composer)" ]; then
    echo 'Error: was not able to auto install Composer. Please install it yourself and try again. https://getcomposer.org' >&2
    exit 1
  fi
fi

# Terminus plugins folder check & navigate
TARGET_FOLDER="${HOME}/.terminus/plugins"
if [ -d "${TARGET_FOLDER}" ]; then
  echo "Found your existing \`${TARGET_FOLDER}\` folder."
else
  echo "Didn't find an existing \`${TARGET_FOLDER}\` folder; we'll make it for you."
  mkdir -p ${TARGET_FOLDER}
fi
cd ${TARGET_FOLDER}

# Install Terminus plugins for effecient WebOps
echo "Going to install Terminus plugins (via Composer)...\n"

# Terminus plugin list. Composer package string format.
declare -a TERMINUS_PLUGINS=(
  "pantheon-systems/terminus-build-tools-plugin:^2.0.0"
  "pantheon-systems/terminus-composer-plugin:~1"
  "pantheon-systems/terminus-mass-update:~1"
  "pantheon-systems/terminus-quicksilver-plugin:~1"
  "pantheon-systems/terminus-rsync-plugin:~1"
  "pantheon-systems/terminus-site-clone-plugin:^2"
#  "terminus-plugin-project/terminus-autocomplete-plugin:~2"
  "terminus-plugin-project/terminus-filer-plugin:~2"
  "terminus-plugin-project/terminus-pancakes-plugin:~2"
  "terminus-plugin-project/terminus-site-status-plugin:~2"
  "jnettik/terminus-mass-run:dev-master"
)

# Loop through each plugin in the list
for TERMINUS_PLUGIN in ${TERMINUS_PLUGINS[@]}
do
  echo ""
  echo "Installing plugin: ${TERMINUS_PLUGIN}"
  echo " -=-=-=-=-=-=-=-=-=-"
  composer create-project -n --no-dev -d ~/.terminus/plugins $TERMINUS_PLUGIN
done

# Run Terminus commands that'll help get things rolling
# Clear Terminus cache to pickup new plugins
terminus self:clear-cache

# TODO: Intall autocomplete
#terminus autocomplete:install

## Quicksilver config check check & navigate
#TARGET_FOLDER="${HOME}/.quicksilver"
#if [ -d "${TARGET_FOLDER}" ]; then
#  echo "Directory \`${TARGET_FOLDER}\` found."
#else
#  echo "Didn't find \`${TARGET_FOLDER}\` folder"
#  mkdir -p ${TARGET_FOLDER}
#  echo "Created directory \`${TARGET_FOLDER}\`"
#fi
#cd ${TARGET_FOLDER}
#
## Quicksilver plugins
#QUICKSILVER_CONFIG_REPO="ccharlton/cdddeebf6b0d8db4946bf76bb7550992"
#git clone https://gist.github.com/${QUICKSILVER_CONFIG_REPO}
## install Quicksilver recipes based on a named profile
#terminus quicksilver:profile webops

# Closing statements, help, and links.
echo "\n"
echo "All done. Your Terminus now has a bunch of useful plugins."
echo "Official Terminus Plugin directory: https://pantheon.io/docs/terminus/plugins/directory"
echo "Additional Terminus Plugin directory: https://github.com/terminus-plugin-project"
echo "Learn more Terminus commands: https://pantheon.io/docs/terminus"
