# setup.sh
#!/bin/bash

# Ensure required environment variables are set
if [ -z "$REPO_OWNER" ] || [ -z "$REPO_NAME" ] || [ -z "$GH_TOKEN" ]; then
    echo "Error: Please set REPO_OWNER, REPO_NAME, and GH_TOKEN environment variables."
    exit 1
fi

# Install GitHub CLI
if ! command -v gh &> /dev/null
then
    echo "GitHub CLI not found. Installing..."
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null &&
    sudo apt update &&
    sudo apt install gh -y
else
    echo "GitHub CLI is already installed."
fi

# Fetch the latest release from your GitHub repository
echo "Fetching the latest release from GitHub..."
LATEST_RELEASE=$(gh release view --repo "$REPO_OWNER/$REPO_NAME" --json tagName -q .tagName)
echo "Latest release tag: $LATEST_RELEASE"

# Set up Flutter environment and run commands
export PATH="$PATH:$(pwd)/flutter/bin"
echo "export LATEST_RELEASE=$LATEST_RELEASE" >> .env
flutter doctor
flutter pub get
flutter build web --release --verbose

# Output the latest release version
echo "The latest release version is $LATEST_RELEASE"
