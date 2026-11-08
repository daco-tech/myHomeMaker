# My Home Maker Tool

## TLDR; 

Requirement:

Mac Setup:

```bash
xcode-select --install
bash -c "$(curl -H 'Cache-Control: no-cache' -fsSL https://raw.githubusercontent.com/daco-tech/myHomeMaker/master/configure.sh)"
bash -c "$(curl -H 'Cache-Control: no-cache' -fsSL https://raw.githubusercontent.com/daco-tech/myHomeMaker/master/installLinuxMac.sh)"
```

Linux Setup:

```bash
bash -c "$(curl -H 'Cache-Control: no-cache' -fsSL https://raw.githubusercontent.com/daco-tech/myHomeMaker/master/configure.sh)"
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
- [x] Install/update every Homebrew-managed app via `brew bundle` (function: runBrewBundle)

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
- [x] Install Packer
- [x] Install and configure AWS Cloud CLI tool
- [x] Install and configure Azure Cloud CLI tool
- [x] ConfigureDotFiles (zshrc)
- [x] Install Kubernetes tools [Kubectl (Mac), Kubectx, etc]
- [x] Install Kubernetes tools (Kubectl linux)


## Global Apps

Cross-platform CLI tools (macOS + Linux) are declared once in the root
[`Brewfile`](./Brewfile) and installed by the shell scripts themselves -
`installLinuxMac.sh`/`installVM.sh` bootstrap Homebrew (using Homebrew on
Linux, "Linuxbrew", if it isn't already present) and then run
`brew bundle --file=Brewfile` (function: `runBrewBundle`) *before* Ansible
ever runs. This keeps Ansible focused on configuration rather than package
management, and means `update` (which just re-runs `installLinuxMac.sh`)
always re-applies the Brewfile too.

Vault is installed from the explicitly declared `hashicorp/tap`. On Homebrew
versions with formula trust enforcement, `runBrewBundle` trusts only the
third-party formulae this repo declares (`hashicorp/tap/vault` and
`andyyyy64/whichllm/whichllm`) before applying the Brewfile, so `update` can
install them without requiring a separate manual Homebrew command.

macOS-only GUI apps and fonts (Homebrew casks) live in the same `Brewfile`,
guarded by an `if OS.mac?` block, since Homebrew casks aren't available on
Linux. That block also declares the default set of VS Code extensions
(installed via `brew bundle`'s `vscode` entries, using the `code` CLI shim
from the `visual-studio-code` cask). The old VSCodium-cask removal and
AltTab uninstall also run after `brew bundle` from the same shell-script
step (macOS only).

MQTT Explorer is installed from the Mac App Store via `mas` in the Brewfile:
the Homebrew cask was disabled because it fails Gatekeeper checks. Sign in to
the Mac App Store on each Mac before running the setup or `update` command.

On Apple Silicon Macs, the Brewfile also installs Ollama, `llama.cpp`, and
MLX-LM for local model inference using Metal/MLX acceleration. These are
runtimes only; models are downloaded on demand. For example, run
`ollama run <model>` to download and start a model with Ollama. Start its
background service at login with `brew services start ollama` if desired.

[whichllm](https://github.com/Andyyyy64/whichllm) is installed alongside them
from the `andyyyy64/whichllm` tap. It inspects the GPU, RAM, and memory
bandwidth, then ranks the local models that fit and how fast they should run:
`whichllm` prints the table, and `whichllm run` downloads the top pick and
opens a chat with it. The upstream Homebrew formula only ships Apple Silicon
wheels; on Linux, install it with `uv tool install whichllm` (the Brewfile
already installs `uv`).

On macOS, the Brewfile also installs
[clipaste](https://github.com/hqhq1025/clipaste) from the `hqhq1025/clipaste`
tap (plus `pngpaste`) and starts the clipaste daemon via `brew services` so
clipboard screenshots paste cleanly into terminal AI tools (Claude Code, Codex,
Cursor). Manage it afterwards with `brew services {info,restart,stop} clipaste`.
The generated `.zshrc` also defines a `clipimg` helper that saves the clipboard
image with `pngpaste` and stages its file path on the clipboard.

Anything with no Homebrew formula/cask (native GUI apps, system fonts,
distro package-manager-only tools) is still installed via Ansible using the
native package manager - see `install_debian_linux_packages` /
`install_arch_linux_aur_packages` / `install_linux_packages` in
**playbook.yml**.

## Personal Configuration (One time Setup Option)
- [x] Copy SSH Keys
- [x] Configure Personal Git Settings
- [ ] Configure Kubernetes local settings
- [ ] Configure Azure
- [ ] Configure AWS



# Credits:

- Ansible Package Install Role base: https://github.com/brentwg/ansible-role-packages
- Ansible Mac Homebrew install base: https://github.com/adamchainz/mac-ansible/blob/master/roles/adam_mac/tasks/installs.yml
- Joplin Linux install Role base: https://github.com/thisdwhitley/ansible-role-joplin
- VSCode Ansible Role: https://github.com/gantsign/ansible-role-visual-studio-code
- ZSH Configuration and Installation: https://github.com/gantsign/ansible-role-oh-my-zsh
- Nerdfonts Ansible Role: https://github.com/drew-kun/ansible-nerdfonts

