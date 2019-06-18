#!/usr/bin/env bash

# Set up `git` for the first time.
gitsetup() {
    echo "Welcome, $(whoami). Let's \`git\` you set up."
    echo "This setup will create a new SSH key for you to use."

    echo "What's your name?"
    read GIT_SETUP_NAME -e
    git config --global user.name $GIT_SETUP_NAME

    echo "What's your email?"
    read GIT_SETUP_EMAIL
    git config --global user.email $GIT_SETUP_EMAIL

    echo "Creating SSH key for you..."
    ssh-keygen -t rsa -C $GIT_SETUP_EMAIL

    echo "Starting ssh-agent..."
    eval "$(ssh-agent -s)"

    echo "Adding SSH key..."
    ssh-add ~/.ssh/id_rsa

    echo "Now copying SSH key to the clipboard..."
    pbcopy < ~/.ssh/id_rsa.pub

    echo "Setting push.default to only for current branches..."
    # Use current branch only when doing git push
    git config --global push.default current

    echo "Done! ✅"

}

gitsetup
