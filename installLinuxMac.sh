#!/bin/bash


# VARS
OS=UNKNOWN #Linux, MacOS
DISTRO=UNKNOWN #Debian, RedHat, Gentoo, Arch or None
INSTALLCMD=UNKNOWN # APT; YUM; PACMAN; EMERGE
ANSIBLEPARAMS="" # Parameters passed to ansible
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
}
envDetector(){
    logmsg "INFO" "${NC} Detecting Environment"
    case "$(uname -s)" in
    Darwin)
        OS=MacOS
        DISTRO=none
        INSTALLCMD="brew install"
        ANSIBLEPARAMS="-K"
        if ! [ -x "$(command -v clang)" ];
        then
            logmsg "WARN" "${NC} xcode cli tools not installed... installing..."

            xcode-select --install
            logmsg "INFO" "${NC} xcode cli tools installing! Please rerun this script after install!"
            exit 0

        fi

        if ! [ -x "$(command -v brew)" ];
        then
            logmsg "WARN" "${NC} HomeBrew not installed... installing..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
            logmsg "INFO" "${NC} HomeBrew installed! (check log above)"
        fi
    ;;
    Linux)
        OS=Linux
        if [ -n "$(command -v apt-get)" ];
        then
            INSTALLCMD="sudo apt-get -y --allow-unauthenticated install"
            DISTRO=Debian
        elif [ -n "$(command -v apt)" ];
        then
            INSTALLCMD="sudo apt -f install"
            DISTRO=Debian
        elif [ -n "$(command -v dnf)" ];
        then
            INSTALLCMD="sudo dnf -y"
            DISTRO=RedHat
        elif [ -n "$(command -v yum)" ];
        then
            INSTALLCMD="sudo yum -y"
            DISTRO=RedHat

        elif [ -n "$(command -v pacman)" ];
        then
            INSTALLCMD="sudo pacman -S "
            DISTRO=Arch
        elif [ -n "$(command -v yay)" ];
        then
            INSTALLCMD="sudo yay -S"
            DISTRO=Arch
        elif [ -n "$(command -v emerge)" ];
        then
            INSTALLCMD="sudo emerge"
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

endinstall(){
    case "$(uname -s)" in
        Darwin)
        ;;
        Linux)
            chsh -s $(which zsh)
        ;;
    esac
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
        ANSIBLEPARAMS="-K"
        if [ $DISTRO = "Arch" ];
        then
            if pacman -Qs $1 > /dev/null ; then
                INSTALLED=false
            else
                INSTALLED=true
            fi
        elif [ $DISTRO = "Debian" ];
        then 
            if [ -n "$(command -v dpkg-query)" ];
            then
                if [ $(dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed") -eq 0 ];
                then
                    INSTALLED=true
                fi
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
    installTool ansible

    ## Test
    command -v git >/dev/null 2>&1 || { echo >&2 "git is required but it's not installed. Aborting."; exit 1; }
    command -v curl >/dev/null 2>&1 || { echo >&2 "curl is required but it's not installed. Aborting."; exit 1; }
    #command -v python3 >/dev/null 2>&1 || { echo >&2 "python is required but it's not installed. Aborting."; exit 1; }
    if ! command -v python3 &> /dev/null
    then
        echo "python is required but it's not installed. Aborting."
        exit 1
    fi

    mkdir -p ~/go/bin

}

installAnsible(){
    if [ -n "$(command -v ansible)" ];
    then
        logmsg "INFO" "${NC} ansible already installed..."
    else
        if [ "${OS}" == "MacOS" ];
        then
            installTool ansible
        else
            if [ $DISTRO = "Debian" ];
            then 
                sudo apt-add-repository ppa:ansible/ansible
                installTool ansible
            else
                installTool ansible
            fi
            if [ $DISTRO = "RedHat" ];
            then 
                sudo yum install ansible zsh util-linux-ng
            fi
        fi  
    fi

    ## Test
    command -v ansible >/dev/null 2>&1 || { echo >&2 "ansible is required but it's not installed. Aborting."; exit 1; }

}

downloadRepo(){
    mkdir ~/.myhomemaker && cd ~/.myhomemaker
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
        git clone https://github.com/daco-tech/myHomeMaker
    fi
    cd myHomeMaker
    git --no-pager diff HEAD^..HEAD
    cd ..
    logmsg "INFO" "${NC} Repo Updated!"
}

###################################################  RUN PLAYBOOK ###################################################

runPlaybooks(){
    if [ -d "/usr/local/share/zsh" ]; then
        logmsg "INFO" "Fix ZSH permissions..."
        sudo chown -R $(whoami) /usr/local/share/zsh /usr/local/share/zsh/site-functions
        chmod u+w /usr/local/share/zsh /usr/local/share/zsh/site-functions
    fi

    logmsg "INFO" "${NC} Running Playbooks..."
    cd myHomeMaker/ansible
    ansible-playbook ${ANSIBLEPARAMS[@]} playbook.yml --ask-become-pass
    cd ..
}

## Execute
cd ~/
displayAsciiDisclaimer
envDetector
amIop
installReq
installAnsible
downloadRepo
runPlaybooks
endinstall

exit 0
