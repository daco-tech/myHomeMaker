# My Home Maker Tool

## TLDR; 

Linux/Mac Setup:

```bash
bash -c "$(curl -H 'Cache-Control: no-cache' -fsSL https://raw.githubusercontent.com/daco-tech/myHomeMaker/master/installLinuxMac.sh)"
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

### Ansible Playbooks

- [ ] InstallLinuxSpecific
- [ ] InstallMacSpecific
- [ ] InstallGenericApps
- [ ] ConfigureDotFiles
- [ ] ConfigureApps






## Linux and Mac Specific Apps

- Kitty (Terminal)



## Windows Tools Specific Apps

- Cmder (Terminal)


## Global Apps



## Personal Configuration
- [ ] Copy SSH Keys
- [ ] Copy Dot Files
- [ ] Configure Apps



# Credits:

- Ansible Package Install Role base: https://github.com/brentwg/ansible-role-packages
