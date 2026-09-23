#!/bin/bash

configGit(){
    echo "Please provide your GIT e-mail (leave empty to skip GIT config):"
    read gitMail
    if [ -z "$gitMail" ]; then
        echo "No GIT e-mail provided, skipping GIT config."
        return
    fi
    echo "Please provide your GIT Name (leave empty to skip GIT config):"
    read gitName
    if [ -z "$gitName" ]; then
        echo "No GIT name provided, skipping GIT config."
        return
    fi
    command -v git >/dev/null 2>&1 || { echo >&2 "git is required but it's not installed. Aborting."; exit 1; }
    git config --global url."git@github.com:".insteadOf "https://github.com/"
    git config --global url."git@gitlab.com:".insteadOf "https://gitlab.com/"
    git config --global user.email "$gitMail"
    git config --global user.name "$gitName"
    git config --global http.postBuffer 1048576000
    git config --global ssh.postBuffer 1048576000
}

configDotfiles(){
    dotfilesDir="$1"

    if [ ! -d "$dotfilesDir" ]; then
        echo "Dotfiles directory '$dotfilesDir' does not exist. Skipping dotfiles setup."
        return
    fi

    echo "..:: Linking dotfiles from $dotfilesDir into \$HOME... ::.."
    for f in "$dotfilesDir"/.[!.]* "$dotfilesDir"/*; do
        [ -e "$f" ] || continue
        name="$(basename "$f")"
        case "$name" in
            .git|.gitignore|.gitmodules|.DS_Store|README*|LICENSE*) continue ;;
        esac
        target="$HOME/$name"
        if [ -L "$target" ] && [ "$(readlink "$target")" = "$f" ]; then
            echo "  $name already linked, skipping"
            continue
        fi
        if [ -e "$target" ] || [ -L "$target" ]; then
            backup="$target.bak.$(date +%Y%m%d%H%M%S)"
            echo "  Backing up existing $name to $backup"
            mv "$target" "$backup"
        fi
        echo "  Linking $target -> $f"
        ln -s "$f" "$target"

        # Synced folders (e.g. Nextcloud/Dropbox) don't always preserve strict
        # unix permissions, and SSH refuses keys that are group/world readable.
        # Re-harden them every time .ssh gets (re)linked.
        if [ "$name" = ".ssh" ]; then
            echo "  Hardening SSH key permissions in $f"
            chmod 700 "$f" 2>/dev/null
            find "$f" -maxdepth 1 -type f \( -name "id_*" ! -name "*.pub" \) -exec chmod 600 {} \;
            find "$f" -maxdepth 1 -type f -name "*.pub" -exec chmod 644 {} \;
            [ -f "$f/config" ] && chmod 600 "$f/config"
        fi
    done
}

configSudo(){
    case "$(uname -s)" in
    Darwin)
        echo " Using Mac! Sudo not configured!"
    ;;
    Linux)
        echo "Checking if you are a sudoer... Enter root password"
        if su -c "grep -q \"$USER\" /etc/sudoers" ; then
        echo "Already a sudoer. Nothing to do..."
        else
        echo "Enable sudo. Enter the root password:"
        su -c "echo '$USER    ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"
        fi
    ;;
    esac
}

configSSH()
{
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    echo "Host *" > ~/.ssh/config
    echo " AddKeysToAgent yes" >> ~/.ssh/config
    echo " IdentityFile ~/.ssh/id_rsa" >> ~/.ssh/config
    echo " User $1" >> ~/.ssh/config

    case "$(uname -s)" in
    Darwin)
        echo " UseKeychain yes" >> ~/.ssh/config
    ;;
    esac
}

displayAsciiDisclaimer() {
    echo "██████╗  █████╗  ██████╗ ██████╗    ████████╗███████╗ ██████╗██╗  ██╗"
    echo "██╔══██╗██╔══██╗██╔════╝██╔═══██╗   ╚══██╔══╝██╔════╝██╔════╝██║  ██║"
    echo "██║  ██║███████║██║     ██║   ██║█████╗██║   █████╗  ██║     ███████║"
    echo "██║  ██║██╔══██║██║     ██║   ██║╚════╝██║   ██╔══╝  ██║     ██╔══██║"
    echo "██████╔╝██║  ██║╚██████╗╚██████╔╝      ██║   ███████╗╚██████╗██║  ██║"
    echo "╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═════╝       ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝ "
    echo "DACO-TECH - My HomeMaker Started!"
    echo "Backup your configurations before continue! I am not resposible for any loss!"
}

displayAsciiDisclaimer

echo "..:: PREPARE DACO SETUP ::.."
echo "..:::: COPY RSA KEYS ::::.."
echo "Please provide the source RSA identity keys directory below (leave empty to skip):"
read srcName
if [ -n "$srcName" ]; then
    echo "..:: Prepare rsa keys directory... ::.."
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    echo "..:: Copy RSA Keys... ::.."
    case "$(uname -s)" in
        Darwin)
            echo "Preparing Mac"
            cp -rfv "$srcName/id_rsa" ~/.ssh/
            cp -rfv "$srcName/id_rsa.pub" ~/.ssh/
        ;;
        Linux)
            echo "Preparing Linux"
            cp -rfv $srcName/id_rsa ~/.ssh/
            cp -rfv $srcName/id_rsa.pub ~/.ssh/
        ;;
    esac

    chmod 600 ~/.ssh/id_rsa
    chmod 644 ~/.ssh/id_rsa.pub
else
    echo "No RSA keys source directory provided, skipping RSA key copy."
fi

## SSH Config
echo "..:::: CONFIGURE SSH ::::.."
echo "Please provide your usual SSH username (leave empty to skip):"
read sshUserName
if [ -n "$sshUserName" ]; then
    configSSH $sshUserName
else
    echo "No SSH username provided, skipping SSH config."
fi

## SUDO Config
echo "..:::: CONFIGURE SUDO ::::.."
configSudo

## GIT Config
echo "..:::: CONFIGURE GIT ::::.."
configGit

## Dotfiles Config
echo "..:::: CONFIGURE DOTFILES ::::.."
echo "Please provide the path to your dotfiles directory (e.g. /Users/yourname/Nextcloud/dotfiles), or leave empty to skip:"
read dotfilesDir
if [ -n "$dotfilesDir" ]; then
    configDotfiles "$dotfilesDir"
else
    echo "No dotfiles directory provided, skipping."
fi

## Create tmp dir
echo "..:::: CREATE TMP DIR ::::.."
mkdir -p ~/tmp

echo "..:: DONE! Mission Accomplished! ::.."
