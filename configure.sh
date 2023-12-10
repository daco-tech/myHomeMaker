#!/bin/bash

configGit(){
    echo "Please provide your GIT e-mail:"
    read gitMail
    echo "Please provide your GIT Name:"
    read gitName
    command -v git >/dev/null 2>&1 || { echo >&2 "git is required but it's not installed. Aborting."; exit 1; }
    git config --global url."git@github.com:".insteadOf "https://github.com/"
    git config --global url."git@gitlab.com:".insteadOf "https://gitlab.com/"
    git config --global user.email "$gitMail"
    git config --global user.name "$gitName"
    git config --global http.postBuffer 1048576000
    git config --global ssh.postBuffer 1048576000
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
echo "Please provide the source RSA identity keys directory below:"
read srcName
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

## SSH Config
echo "..:::: CONFIGURE SSH ::::.."
echo "Please provide your usual SSH username:"
read sshUserName
configSSH $sshUserName

## SUDO Config
echo "..:::: CONFIGURE SUDO ::::.."
configSudo

## GIT Config
echo "..:::: CONFIGURE GIT ::::.."
configGit

## Create tmp dir
echo "..:::: CREATE TMP DIR ::::.."
mkdir -p ~/tmp

echo "..:: DONE! Mission Accomplished! ::.."
