# dbeaver

Pre-seeds DBeaver's Maven driver cache with the **latest** SQLite,
PostgreSQL, and MySQL JDBC drivers so new connections work immediately
without the "download driver" prompt on first use.

DBeaver itself is installed separately, not by this role:

- **macOS**: `cask "dbeaver-community"` in the repo-root `Brewfile`
  (installed via `brew bundle` before this playbook runs).
- **Arch Linux**: `dbeaver` in `install_arch_linux_aur_packages`
  (`ansible/playbook.yml`), installed via `yay`.

## Variables

| Variable               | Default                                   | Description                                   |
| ----------------------- | ------------------------------------------ | ---------------------------------------------- |
| `dbeaver_data_dir`      | `{{ ansible_env.HOME }}/.local/share/DBeaverData` | DBeaver's data/config directory               |
| `dbeaver_jdbc_drivers`  | sqlite-jdbc, postgresql, mysql-connector-j | Maven `group`/`artifact` pairs to pre-download |
