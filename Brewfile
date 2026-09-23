# Homebrew Bundle file - https://docs.brew.sh/Brewfile
#
# This is the single source of truth for every tool this project installs
# through Homebrew, on *both* macOS and Linux (Linuxbrew). It is applied via
# `brew bundle --file=Brewfile` by the `crossplatform-package-manager`
# Ansible role (see ansible/roles/crossplatform-package-manager), which is
# run on every supported OS.
#
# Homebrew casks (pre-built GUI apps and fonts) and `vscode` extension
# entries only work on macOS here (they need the `code` CLI shim that the
# visual-studio-code cask installs), so they are wrapped in an `if OS.mac?`
# block below. Linux-only desktop apps/fonts that have no Homebrew formula
# (VSCodium, Nerd Fonts, Timeshift, Stacer, Flameshot, ...) still go through
# the native package manager - see install_debian_linux_packages /
# install_arch_linux_aur_packages / install_linux_packages in
# ansible/playbook.yml.

# ---- Cross-platform CLI tools (macOS + Linux) ------------------------------
brew "htop"
brew "glances"
brew "cmake"
brew "wget"
brew "httpie"
brew "fastfetch"
brew "graphviz"
brew "bash-completion"
brew "fzf" # https://github.com/junegunn/fzf
brew "watch"
brew "jq"
brew "nano"
brew "go"
brew "azure-cli"
brew "gh"
brew "k9s"
brew "kubecolor"
brew "kubespy"
brew "terraform-docs"
brew "tfsec"
brew "opencode"
brew "node"
brew "podman"
brew "podman-compose"

# ---- macOS-only GUI apps & fonts (Homebrew casks) --------------------------
if OS.mac?
  cask "font-fira-code"
  cask "font-hack-nerd-font"
  cask "font-jetbrains-mono"
  cask "vlc"
  cask "copilot-cli"
  cask "visual-studio-code"
  cask "alt-tab"
  cask "ghostty"

  # ---- VS Code extensions -------------------------------------------------
  # Installed via the `code` CLI shim from the visual-studio-code cask
  # above (Homebrew Bundle installs casks before vscode entries), based on
  # https://github.com/josemaia/dotfiles/blob/master/files/Brewfile
  vscode "ban.spellright"
  vscode "casualjim.gotemplate"
  vscode "charliermarsh.ruff"
  vscode "davidanson.vscode-markdownlint"
  vscode "eamodio.gitlens"
  vscode "editorconfig.editorconfig"
  vscode "github.vscode-github-actions"
  vscode "github.vscode-pull-request-github"
  vscode "golang.go"
  vscode "hashicorp.terraform"
  vscode "mdickin.markdown-shortcuts"
  vscode "ms-azuretools.vscode-azurefunctions"
  vscode "ms-azuretools.vscode-azureresourcegroups"
  vscode "ms-azuretools.vscode-azurestorage"
  vscode "ms-azuretools.vscode-containers"
  vscode "ms-azuretools.vscode-docker"
  vscode "ms-dotnettools.csharp"
  vscode "ms-dotnettools.vscode-dotnet-runtime"
  vscode "ms-python.black-formatter"
  vscode "ms-python.debugpy"
  vscode "ms-python.isort"
  vscode "ms-python.python"
  vscode "ms-python.vscode-pylance"
  vscode "ms-vscode-remote.remote-containers"
  vscode "ms-vscode.cpp-devtools"
  vscode "ms-vscode.powershell"
  vscode "ms-vscode.wordcount"
  vscode "ms-vsliveshare.vsliveshare"
  vscode "redhat.vscode-commons"
  vscode "redhat.vscode-yaml"
  vscode "rogalmic.bash-debug"
  vscode "yzane.markdown-pdf"
  vscode "yzhang.markdown-all-in-one"
end
