#!/bin/sh

# Exit on error
set -e

# Check for Composer, before anything else.
printf "\n"
printf "Thanks for checking out this mega pack of Terminus plugins\n"

# Make sure Terminus is already install. If not, install it for us.
#if ! [ -x "$(command -v terminus)" ]; then
#  echo "I noticed Terminus is not installed. It's needed. I'll try to install for you..."
#  mkdir ${HOME}/terminus && cd ${HOME}/terminus
#  curl -L https://github.com/pantheon-systems/terminus/releases/download/$(curl --silent "https://api.github.com/repos/pantheon-systems/terminus/releases/latest" | perl -nle'print $& while m{"tag_name": "\K.*?(?=")}g')/terminus.phar --output terminus
#  chmod +x terminus
#  sudo ln -s ${HOME}/terminus/terminus /usr/local/bin/terminus
#fi
# Double check if Terminus is now available, otherwise bail.
if ! [ -x "$(command -v terminus)" ]; then
  echo 'Error: was not able to auto install Terminus. Please install it yourself and try again. https://pantheon.io/docs/terminus/install' >&2
  exit 1
fi

terminus art fist
sleep 2

# Install Composer if it doesn't already exist
if ! [ -x "$(command -v composer)" ]; then
  echo "I noticed Composer is not installed. It's needed. I'll try to install for you..."
  # Composer not found, so let's run the install steps for them
  curl -sS https://getcomposer.org/installer | php
  mv composer.phar /usr/local/bin/composer
  chmod +x /usr/local/bin/composer
fi
# Double check if Composer is now available, otherwise bail.
if ! [ -x "$(command -v composer)" ]; then
  echo 'Error: was not able to auto install Composer. Please install it yourself and try again. https://getcomposer.org' >&2
  exit 1
fi

# Terminus plugins folder check & navigate
readonly TERMINUS_PLUGIN_FOLDER="${HOME}/.terminus/plugins"
if [ -d "${TERMINUS_PLUGIN_FOLDER}" ]; then
  echo "Found your existing \`${TERMINUS_PLUGIN_FOLDER}\` folder."
else
  echo "Didn't find an existing \`${TERMINUS_PLUGIN_FOLDER}\` folder; we'll make it for you."
  mkdir -p "${TERMINUS_PLUGIN_FOLDER}"
fi
cd "${TERMINUS_PLUGIN_FOLDER}"

# Install Terminus plugins for efficient WebOps
printf "Going to install Terminus plugins (via Composer)...\n"
terminus art rocket

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
#for TERMINUS_PLUGIN in ${TERMINUS_PLUGINS[@]}
#do
#  # Check if the plugin already exists
#  # Check if the Terminus plugin already exists or not. Skip if it does.
#  if [ -d "${pluginFolderName}/" ]; then
#    echo "${pluginFolderName} plugin already exists. Skipping."
#    echo "If you want to re-install this plugin, just delete the folder and run this script again."
#  else
#    echo ""
#    echo ""
#    echo "Installing plugin: ${TERMINUS_PLUGIN}"
#    echo " -=-=-=-=-=-=-=-=-=-"
#    composer create-project -n --no-dev -d ~/.terminus/plugins $TERMINUS_PLUGIN
#  fi
#done

echo "${TERMINUS_PLUGINS[@]}" | parallel -I% --max-args 1 --jobs 15 composer create-project -n --no-dev -d ~/.terminus/plugins %

# Run Terminus commands that'll help get things rolling
# Clear Terminus cache to pickup new plugins
terminus self:clear-cache

# TODO: Install autocomplete
#terminus autocomplete:install

## Quicksilver config check check & navigate
#TERMINUS_PLUGIN_FOLDER="${HOME}/.quicksilver"
#if [ -d "${TERMINUS_PLUGIN_FOLDER}" ]; then
#  echo "Directory \`${TERMINUS_PLUGIN_FOLDER}\` found."
#else
#  echo "Didn't find \`${TERMINUS_PLUGIN_FOLDER}\` folder"
#  mkdir -p ${TERMINUS_PLUGIN_FOLDER}
#  echo "Created directory \`${TERMINUS_PLUGIN_FOLDER}\`"
#fi
#cd ${TERMINUS_PLUGIN_FOLDER}
#
## Quicksilver plugins
#QUICKSILVER_CONFIG_REPO="ccharlton/cdddeebf6b0d8db4946bf76bb7550992"
#git clone https://gist.github.com/${QUICKSILVER_CONFIG_REPO}
## install Quicksilver recipes based on a named profile
#terminus quicksilver:profile webops

terminus art unicorn
# Closing statements, help, and links.
printf "\n\n"
echo "All done. Your Terminus now has a bunch of useful plugins."
echo "Official Terminus Plugin directory: https://pantheon.io/docs/terminus/plugins/directory"
echo "Additional Terminus Plugin directory: https://github.com/terminus-plugin-project"
echo "Learn more Terminus commands: https://pantheon.io/docs/terminus"
