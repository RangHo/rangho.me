#!/bin/sh

# shellcheck shell=ash
# This script assumes at least `local` extension is enabled.

readonly GITHUB_TOKEN="$1"

DEPLOY_REPO_PATH=""

## Logging function
log() {
    printf "[DEPLOY] \033[33m%s\033[39m\n" "$*"
}

## Check if all required commands exist
check_prerequisite() {
    log "Checking availability: pnpm..."
    if ! command -v pnpm >/dev/null; then
        log "pnpm is not installed. Installing it..."
        npm install -g pnpm
    fi
    log "pnpm is installed!"

    log "Installing the latest version of node..."
    pnpm env use --global latest
    log "node is installed!"
}

setup_git() {
    log "Creating a temporary directory..."
    DEPLOY_REPO_PATH="$(mktemp -d)"

    local prev_path
    prev_path="$(pwd)"

    log "Cloning the deploy directory to: $DEPLOY_REPO_PATH/deploy..."
    git clone https://github.com/RangHo/rangho.me "$DEPLOY_REPO_PATH/deploy"

    log "Changing directory to the deploy directory..."
    cd "$DEPLOY_REPO_PATH/deploy"

    log "Setting up a git profile..."
    git config --local user.name "GitHub Pages Deploy"
    git config --local user.email "bot@rangho.me"
    git remote set-url origin "https://x-access-token:$GITHUB_TOKEN@github.com/RangHo/rangho.me"

    log "Checking out the deploy branch..."
    git checkout deploy

    log "Back to original directory..."
    cd "$prev_path"
}

## Build the static page into /build directory
build() {
    log "Installing dependencies..."
    pnpm install

    log "Building the static page..."
    pnpm run build
}

copy_output() {
    log "Entering the build directory..."
    cd build

    log "Copying build artifacts to the deploy directory..."
    cp -r ./* "$DEPLOY_REPO_PATH/deploy"

    log "Exiting the build directory..."
    cd ..
}

deploy() {
    local prev_path
    prev_path="$(pwd)"

    log "Commiting changes to the deployment branch..."
    cd "$DEPLOY_REPO_PATH/deploy"
    git add --all
    git commit -m "Update GitHub Pages"
    git push --force
}

check_prerequisite
setup_git
build
copy_output
[ -z "$GITHUB_TOKEN" ] || deploy # Empty token means that this is for debugging
