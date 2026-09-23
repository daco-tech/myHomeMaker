# Copilot Instructions for myHomeMaker

## What this repo is

`myHomeMaker` is a personal dev-machine bootstrapper: shell scripts detect the
host OS/distro, install prerequisites (git, curl, python, ansible), clone this
repo onto the target machine, then run an Ansible playbook that installs and
configures tools (zsh, VSCodium, Docker, cloud CLIs, fonts, kube tools, etc).
There is no application code, build system, or test suite in the usual sense —
changes here are validated by running the scripts/playbook against a real or
VM target (see Vagrantfile for a VirtualBox VM you can test against).

## Entry points and flow

1. `configure.sh` — one-time personal setup run *before* the main installer:
   copies SSH keys, sets `~/.ssh/config`, configures `sudo` (Linux) and global
   git config. Interactive (reads from stdin).
2. `installLinuxMac.sh` (macOS/Linux) — the main bootstrapper:
   `envDetector` → `amIop` → `installReq` → `installAnsible` → `downloadRepo`
   → `runPlaybooks` → `endinstall`. It clones/updates
   `~/.myhomemaker/myHomeMaker` and then runs
   `ansible-playbook ansible/playbook.yml --ask-become-pass`.
3. `installVM.sh` — trimmed-down variant of the above used as the Vagrant
   provisioning script (see `Vagrantfile`); has no `--ask-become-pass` flow.
4. `installWindows.bat` — stub only, Windows is not implemented.
5. `ansible/playbook.yml` — the actual list of roles/packages, keyed by
   `ansible_system` (`Darwin` vs `Linux`) and, for Linux, package manager
   (`install_arch_linux_aur_packages`, `install_debian_linux_packages`,
   `install_linux_packages` for common ones across distros).

All three shell scripts (`configure.sh`, `installLinuxMac.sh`, `installVM.sh`)
duplicate the same `logmsg`, `displayAsciiDisclaimer`, `envDetector`,
`installTool` helper functions independently — when fixing a bug in one
(e.g. OS/distro detection, package-installed checks), check whether the same
bug exists in the others before considering it fixed.

## Ansible conventions

- `ansible/ansible.cfg` fixes `inventory = localhost` and runs everything
  `connection: local` against `hosts: localhost` — this repo is never used to
  configure remote machines.
- The playbook's first play just asserts it's being run from inside the
  `ansible/` directory (`ansible_env.PWD.endswith('/ansible')`); always `cd`
  into `ansible/` before running `ansible-playbook playbook.yml`.
- Roles under `ansible/roles/<name>/` follow the standard Ansible role layout
  (`tasks/main.yml`, `defaults/main.yml`, `vars/`, `templates/*.j2`,
  `handlers/main.yml`). Most roles branch on `ansible_system` /
  `ansible_os_family` inside `tasks/main.yml` and include an OS-specific task
  file (e.g. `docker/tasks/{macos,debian,centos}.yml`,
  `nerdfonts/tasks/{darwin,debian}.yml`).
- Role variables consumed from the playbook (e.g. `install_mac_packages`,
  `install_debian_linux_packages`, `repo_brew_tap`, `rpm_repo`) are defined
  as playbook-level `vars:` and read by the `crossplatform-package-manager`
  role — add new packages there rather than hardcoding them inside a role.
- When a role is disabled/experimental, it's commented out in
  `ansible/playbook.yml` (e.g. `docker`, `terraform`, `packer`, `joplinapp-linux`)
  rather than deleted — follow this pattern instead of removing roles outright.
- Only `crossplatform-package-manager` has a test scaffold
  (`roles/crossplatform-package-manager/tests/test.yml`), and it is a
  standard `role_under_test` stub, not currently runnable standalone.

## Validating changes

There is no CI/lint tooling in this repo. To validate:
- Shell scripts: `bash -n <script>.sh` for a syntax check; prefer testing
  interactively in a disposable VM/container since scripts install packages
  and mutate `~/.ssh`, `~/.gitconfig`, `/etc/sudoers`, etc.
- Ansible changes: `cd ansible && ansible-playbook playbook.yml --syntax-check`
  for a quick sanity check, and `ansible-playbook playbook.yml --ask-become-pass`
  (or via the Vagrant VM: `vagrant up`) to actually exercise roles.
