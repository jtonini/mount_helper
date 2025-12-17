# Backup Mount Helper

Tools for users to access their backed-up home directories from franksinatra.

## Components

- `backup-mount-helper` - sudo helper script (install to `/usr/local/bin/`)
- `backup-functions.sh` - user-facing functions (install to `/etc/profile.d/`)
- `backup-mount.sudoers` - sudoers config (install to `/etc/sudoers.d/backup-mount`)

## User Commands
```bash
view_my_files_from <machine> [path]   # List backup contents
get_my_files_from <machine>           # Mount backup to /backups/<machine>/$USER
release_my_files <machine>            # Unmount backup
```

## Examples
```bash
view_my_files_from justin                     # List top level
view_my_files_from justin Documents           # List Documents/
get_my_files_from justin                      # Mount backup
cd /backups/justin/$USER                      # Browse files
release_my_files justin                       # Unmount when done
```
