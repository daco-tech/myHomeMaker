# My Home Maker Tool

## TLDR; 

Requirement:

Linux/Mac Setup:

```bash
bash -c "$(curl -H 'Cache-Control: no-cache' -fsSL https://raw.githubusercontent.com/daco-tech/myHomeMaker/master/installLinuxMac.sh)"
```

Close all open terminal windows, and re-open to run the command:

```bash
config
```

To update your setup to the last app versions just run:

```bash
update
```

## Development status

### General Use Functions

- [x] LogLine formater to add colors to this execution (function: logmsg)
- [x] Say Hello (function: displayAsciiDisclaimer)

### Before start using Ansible


- [x] Fill Global Vars about environment (function: envDetector)
- [x] Check if root is needed (function: amIop)
- [x] Create the basic requirements installation tool (function: installTool)
- [x] Install Requirements (Git, Curl, Python) (function: installReq)
- [x] Install Ansible (function: installAnsible)
- [x] Check if requirements are met to start (Test @installReq & @installAnsible )
- [x] Clone Repo (function: downloadRepo)

### Ansible Playbooks Setups

- [x] InstallLinuxSpecific
- [x] InstallMacSpecific
- [x] InstallGenericApps
- [x] Configure terminal and zsh settings
- [x] Install fonts
- [x] Install and configure vscode
- [x] Install Docker and Docker-Compose
- [x] Install Terraform
- [x] Install Vargrant
- [x] Install and configure AWS Cloud CLI tool
- [x] Install and configure Azure Cloud CLI tool
- [x] ConfigureDotFiles (zshrc)
- [x] Install Kubernetes tools [Kubectl (Mac), Kubectx, etc]

### TODO Later:

- [ ] Install and configure Heroku Cloud CLI tool
- [ ] Install and configure OpenShift Cloud CLI tool
- [ ] Install Kubernetes tools (Kubectl linux)
- [ ] Add Linux Test in GitHub Actions


## Global Apps

**Check playbook.yml**

## Personal Configuration (One time Setup Option)
- [x] Copy SSH Keys
- [x] Configure Personal Git Settings
- [ ] Configure Kubernetes local settings



# Credits:

- Ansible Package Install Role base: https://github.com/brentwg/ansible-role-packages
- Ansible Mac Homebrew install base: https://github.com/adamchainz/mac-ansible/blob/master/roles/adam_mac/tasks/installs.yml
- Joplin Linux install Role base: https://github.com/thisdwhitley/ansible-role-joplin
- VSCode Ansible Role: https://github.com/gantsign/ansible-role-visual-studio-code
- NerdFonts installation: https://github.com/drew-kun/ansible-nerdfonts
- ZSH Configuration and Installation: https://github.com/gantsign/ansible-role-oh-my-zsh


