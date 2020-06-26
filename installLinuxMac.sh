#!/bin/bash


# VARS
OS=UNKNOWN #Linux, MacOS
DISTRO=UNKNOWN #Debian, RedHat, Gentoo, Arch or None
INSTALLCMD=UNKNOWN # APT; YUM; PACMAN; EMERGE
NEEDSUDO=UNKNOWN #TRUE; FALSE
AMIOP=UNKNOWN #TRUE; FALSE


###################################################  BASE ###################################################
logmsg() {
    if [ ! -n "$3" ]; then
        GREEN='\033[0;32m'
        RED='\033[0;31m'
        ORANGE='\033[0;33m'
        Underlined='\e[4m'
        NC='\033[0m' # No Color

        case "$1" in
           INFO)
                    echo -e -n "${GREEN}[$1 ]${NC} - "
                    ;;
            WARN)
                    echo -e -n "${ORANGE}[$1 ]${NC} - "
                    ;;
            ERROR)
                    echo -e -n "${RED}[$1]${NC} - "
                    ;;
            *)
                    echo -e -n "${Underlined}[$1]${NC} - "
                    ;;
        esac

        prompt="$2"
        echo -e $prompt
    fi

    fileLogEntry=${prompt//\\033[0m}
    echo $(date) - $fileLogEntry >> HomeMaker.log
}

displayAsciiDisclaimer() {
    echo "██████╗  █████╗  ██████╗ ██████╗    ████████╗███████╗ ██████╗██╗  ██╗"
    echo "██╔══██╗██╔══██╗██╔════╝██╔═══██╗   ╚══██╔══╝██╔════╝██╔════╝██║  ██║"
    echo "██║  ██║███████║██║     ██║   ██║█████╗██║   █████╗  ██║     ███████║"
    echo "██║  ██║██╔══██║██║     ██║   ██║╚════╝██║   ██╔══╝  ██║     ██╔══██║"
    echo "██████╔╝██║  ██║╚██████╗╚██████╔╝      ██║   ███████╗╚██████╗██║  ██║"
    echo "╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═════╝       ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝ "
    logmsg "INFO" "${NC} DACO-TECH - My HomeMaker Started!"
}

amIop(){
    logmsg "INFO" "${NC} Detecting User Level"
    if [ "$EUID" -ne 0 ]
    then 
        AMIOP=false
        logmsg "INFO" "${NC} User does not have root permissions!"
    else
        AMIOP=true
        logmsg "INFO" "${NC} User have root permissions!"
    fi
    if ${AMIOP} == ${NEEDSUDO}
    then
        logmsg "INFO" "${NC} User Permissions: OK"
    else
        logmsg "ERROR" "${NC} Insufficient User Permissions, please run with sudo!"
        exit 1
    fi
}
envDetector(){
    logmsg "INFO" "${NC} Detecting Environment"
    case "$(uname -s)" in
    Darwin)
        OS=MacOS
        DISTRO=none
        if [ -n "$(command -v brew)" ];
        then
            PKGMNG=brew
            break
        fi
    ;;
    Linux)
        OS=Linux
        NEEDSUDO=true
        if [ -n "$(command -v apt-get)" ];
        then
            INSTALLCMD="apt-get -y --allow-unauthenticated install"
            DISTRO=Debian
        elif [ -n "$(command -v apt)" ];
        then
            INSTALLCMD="apt -f install"
            DISTRO=Debian
        elif [ -n "$(command -v yum)" ];
        then
            INSTALLCMD=yum -y
            DISTRO=RedHat

        elif [ -n "$(command -v dnf)" ];
        then
            INSTALLCMD=dnf -y
            DISTRO=RedHat

        elif [ -n "$(command -v pacman)" ];
        then
            INSTALLCMD=pacman --noconfirm
            DISTRO=Arch

        elif [ -n "$(command -v emerge)" ];
        then
            INSTALLCMD=emerge
            DISTRO=Gentoo
        fi
    ;;
    CYGWIN*|MINGW32*|MSYS*)
        logmsg "WARN" "${NC} Detected MS Windows - Please run the installWindows.bat script ..."
        exit 1
    ;;
    *)
        logmsg "ERROR" "${NC} Detected other OS - Nothing to do..."
        exit 1
    ;;
  esac
  logmsg "INFO" "${NC} Detected OS: $OS; Detected Distribution: $DISTRO;"
  logmsg "INFO" "${NC} Install Command: $INSTALLCMD <PACKAGE>"

}



installTool() {
  case "$(uname -s)" in
    Darwin)
        if brew ls --versions $1 > /dev/null; then
            # The package is installed
            logmsg "INFO" "${NC} $1 already installed!"
        else
            # The package is not installed
            logmsg "INFO" "${NC} Installing $1" 
            ${INSTALLCMD[@]} $1
        fi
    ;;
    Linux)
        INSTALLED=false
        if [ -n "$(command -v dpkg-query)" ];
        then
            if [ $(dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed") -eq 0 ];
            then
                INSTALLED=true
            fi
        fi

        if ${INSTALLED} == false
        then
            ${INSTALLCMD[@]} $1
            logmsg "INFO" "${NC} $1 installation terminated (check log above)!"
        else
            logmsg "INFO" "${NC} $1 already installed..."
        fi
    ;;
  esac
}

###################################################  PREPARE ###################################################


installReq(){
    installTool git
    installTool curl
    installTool python
    ## Test
    command -v git >/dev/null 2>&1 || { echo >&2 "git is required but it's not installed.  Aborting."; exit 1; }
    command -v curl >/dev/null 2>&1 || { echo >&2 "curl is required but it's not installed.  Aborting."; exit 1; }
    command -v python >/dev/null 2>&1 || { echo >&2 "python is required but it's not installed.  Aborting."; exit 1; }

}

installAnsible(){
    if [ -n "$(command -v ansible)" ];
    then
        logmsg "INFO" "${NC} ansible already installed..."
    else
        mkdir tmp/
        curl https://bootstrap.pypa.io/get-pip.py -o ./tmp/get-pip.py
        python ./tmp/get-pip.py --user
        rm -rf ./tmp/
        if [ -n "$(command -v pip)" ];
        then
            pip install --user ansible
        elif [ -n "$(command -v pip3)" ];
        then
            pip3 install --user ansible
        else
            logmsg "ERROR" "${NC} Unable to install ansible!"
            exit 1
        fi
    fi

    ## Test
    command -v ansible >/dev/null 2>&1 || { echo >&2 "ansible is required but it's not installed.  Aborting."; exit 1; }

}

downloadRepo(){
    logmsg "INFO" "${NC} Download Repo..."

    if [ -d "myHomeMaker" ]; 
    then
        logmsg "INFO" "${NC} Repo directory exists, updating..."

        cd myHomeMaker
        git reset --hard
        git clean -f -d
        git clean -f -x -d
        git clean -fxd :/ 
        git pull
        cd ..
    else
        logmsg "INFO" "${NC} Repo directory does not exist, downloading..."
        git clone git@github.com:daco-tech/myHomeMaker.git
    fi
    logmsg "INFO" "${NC} Repo Updated!"
}

## Execute
displayAsciiDisclaimer
envDetector
amIop
installReq
installAnsible
downloadRepo



exit 0
