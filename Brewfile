# Homebrew Bundle file - https://docs.brew.sh/Brewfile
#
# This is the single source of truth for every tool this project installs
# through Homebrew, on *both* macOS and Linux (Linuxbrew). It is applied via
# `brew bundle --file=Brewfile` by the `crossplatform-package-manager`
# Ansible role (see ansible/roles/crossplatform-package-manager), which is
# run on every supported OS.
#
# Homebrew casks (pre-built GUI apps and fonts) only exist on macOS, so they
# are wrapped in an `if OS.mac?` block below. Linux-only desktop apps/fonts
# that have no Homebrew formula (VSCodium, Nerd Fonts, Timeshift, Stacer,
# Flameshot, ...) still go through the native package manager - see
# install_debian_linux_packages / install_arch_linux_aur_packages /
# install_linux_packages in ansible/playbook.yml.

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
end
