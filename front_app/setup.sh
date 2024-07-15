#!/bin/bash

# Ensure required environment variables are set
if [ -z "$REPO_OWNER" ] || [ -z "$REPO_NAME" ] || [ -z "$GH_TOKEN" ]; then
    echo "Error: Please set REPO_OWNER, REPO_NAME, and GH_TOKEN environment variables."
    exit 1
fi

# Install GitHub CLI
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI not found. Installing..."
    curl -fsSL https://github.com/cli/cli/releases/download/v2.21.2/gh_2.21.2_linux_amd64.tar.gz | tar xz
    mv gh_2.21.2_linux_amd64/bin/gh /usr/local/bin/
else
    echo "GitHub CLI is already installed."
fi

# Clone or update the Flutter repository
if cd flutter; then
    git pull && cd ..
else
    git clone https://github.com/flutter/flutter.git
fi

# Fetch the latest release from your GitHub repository
echo "Fetching the latest release from GitHub..."
LATEST_RELEASE=$(GH_TOKEN=$GH_TOKEN gh release view --repo "$REPO_OWNER/$REPO_NAME" --json tagName -q .tagName)
echo "Latest release tag: $LATEST_RELEASE"

# Set up Flutter environment
export PATH="$PATH:$(pwd)/flutter/bin"
echo "export LATEST_RELEASE=$LATEST_RELEASE" >> .env

# Build the Flutter web app
flutter doctor
flutter pub get
flutter build web --release --web-renderer html --output build/web
