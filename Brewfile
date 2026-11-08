# Homebrew Bundle file - https://docs.brew.sh/Brewfile
#
# This is the single source of truth for every tool this project installs
# through Homebrew, on *both* macOS and Linux (Linuxbrew). It is applied via
# `brew bundle --file=Brewfile` by the `crossplatform-package-manager`
# Ansible role (see ansible/roles/crossplatform-package-manager), which is
# run on every supported OS.
#
# Entries are grouped by type for readability only; the grouping does not
# change how Homebrew Bundle installs them.
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

# System monitoring & diagnostics
brew "htop"
brew "glances"
brew "watch"
brew "fastfetch"

# Terminal & shell
brew "tmux"
brew "bash-completion"
brew "fzf" # https://github.com/junegunn/fzf
brew "nano"

# Networking & HTTP clients
brew "wget"
brew "httpie"

# Data processing & visualization
brew "jq"
brew "graphviz"

# Language runtimes & build tooling
brew "cmake"
brew "go"
brew "node"
brew "uv" # https://docs.astral.sh/uv/ - fast Python package/project manager

# Git & GitHub
brew "gh"

# Containers & Kubernetes
brew "podman"
brew "podman-compose"
brew "k9s"
brew "kubecolor"
brew "kubespy"

# Infrastructure as Code & security
tap "hashicorp/tap"
brew "hashicorp/tap/vault" # HashiCorp Vault CLI client
brew "terraform-docs"
brew "tfsec"

# AI
brew "opencode"

# ---- macOS-only apps, tools & fonts -----------------------------------------
if OS.mac?
  # Local inference engine (Apple silicon only) - https://github.com/incoai/splash
  tap "incoai/tap"
  brew "incoai/tap/splash" if Hardware::CPU.arm?

  # AI & local LLM inference: Ollama provides an easy model/runtime API,
  # llama.cpp supports GGUF models with Metal acceleration, and MLX-LM is
  # tuned for Apple Silicon and uses Apple's MLX framework.
  cask "copilot-cli"
  brew "ollama"
  brew "llama.cpp"
  if Hardware::CPU.arm?
    brew "mlx-lm"

    # whichllm recommends the best local LLM for this machine's GPU/RAM.
    # Its formula is served from a third-party tap and only ships Apple
    # Silicon wheels, so it is scoped to this block. On Linux use
    # `uv tool install whichllm` instead (uv is installed above).
    tap "andyyyy64/whichllm"
    brew "whichllm"
  end

  # Fonts
  cask "font-fira-code"
  cask "font-hack-nerd-font"
  cask "font-jetbrains-mono"

  # Media
  cask "vlc"

  # Clipboard & screenshots
  # clipaste is a tiny background daemon that makes macOS clipboard screenshots
  # pasteable in terminal AI tools (Claude Code, Codex, Cursor). pngpaste saves
  # the current clipboard image to a file and backs the `clipimg` helper defined
  # in the generated .zshrc, which stages that file's path on the clipboard.
  # `start_service: true` runs `brew services start clipaste` (a user-level
  # LaunchAgent) after install so the daemon is picked up on every `update`.
  tap "hqhq1025/clipaste"
  brew "hqhq1025/clipaste/clipaste", start_service: true
  brew "pngpaste"

  # Terminal
  cask "ghostty"

  # Editors, notes & diagramming
  cask "visual-studio-code"
  cask "obsidian"
  cask "drawio"

  # Databases
  cask "dbeaver-community"

  # Mac App Store apps. The official Homebrew cask for MQTT Explorer was
  # disabled in 2026 for failing Gatekeeper checks, so install the signed
  # Mac App Store version instead. `mas` needs the user to be signed in to
  # the Mac App Store.
  brew "mas"
  mas "MQTT Explorer", id: 1455214828

  # ---- VS Code extensions -------------------------------------------------
  # Installed via the `code` CLI shim from the visual-studio-code cask
  # above (Homebrew Bundle installs casks before vscode entries), based on
  # https://github.com/josemaia/dotfiles/blob/master/files/Brewfile

  # Python
  vscode "charliermarsh.ruff"
  vscode "ms-python.black-formatter"
  vscode "ms-python.debugpy"
  vscode "ms-python.isort"
  vscode "ms-python.python"
  vscode "ms-python.vscode-pylance"

  # Go
  vscode "casualjim.gotemplate"
  vscode "golang.go"

  # C# / .NET
  vscode "ms-dotnettools.csharp"
  vscode "ms-dotnettools.vscode-dotnet-runtime"

  # C++
  vscode "ms-vscode.cpp-devtools"

  # Markdown
  vscode "davidanson.vscode-markdownlint"
  vscode "mdickin.markdown-shortcuts"
  vscode "yzane.markdown-pdf"
  vscode "yzhang.markdown-all-in-one"

  # Git & GitHub
  vscode "eamodio.gitlens"
  vscode "github.vscode-github-actions"
  vscode "github.vscode-pull-request-github"

  # Cloud & Azure
  vscode "ms-azuretools.vscode-azurefunctions"
  vscode "ms-azuretools.vscode-azureresourcegroups"
  vscode "ms-azuretools.vscode-azurestorage"

  # Containers & remote development
  vscode "ms-azuretools.vscode-containers"
  vscode "ms-azuretools.vscode-docker"
  vscode "ms-vscode-remote.remote-containers"

  # Infrastructure as Code
  vscode "hashicorp.terraform"

  # Shell & PowerShell
  vscode "rogalmic.bash-debug"
  vscode "ms-vscode.powershell"

  # YAML & configuration
  vscode "redhat.vscode-commons"
  vscode "redhat.vscode-yaml"

  # Editing & productivity
  vscode "ban.spellright"
  vscode "editorconfig.editorconfig"
  vscode "ms-vscode.wordcount"
  vscode "ms-vsliveshare.vsliveshare"
end
