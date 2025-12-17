# Backup Mount Helper

Tools for users to access their backed-up home directories from franksinatra NAS.

## Components

- `backup-mount-helper` - sudo helper script (install to `/usr/local/bin/`)
- `backup-functions.sh` - user-facing functions (install to `/etc/profile.d/`)
- `backup-mount.sudoers` - sudoers config (install to `/etc/sudoers.d/backup-mount`)

## Installation

### On NAS (trueuser)
```bash
cp backup-mount-helper /mnt/usrlocal/8/bin/
chmod 755 /mnt/usrlocal/8/bin/backup-mount-helper
```

### On each workstation
```bash
# Create mount point
mkdir -p /backups
chmod 755 /backups
chown root:root /backups

# Install functions
cp backup-functions.sh /etc/profile.d/

# Install sudoers
cp backup-mount.sudoers /etc/sudoers.d/backup-mount
chmod 440 /etc/sudoers.d/backup-mount
```

### Bulk deployment
```bash
# Deploy functions to all workstations
for host in $my_computers; do
    scp backup-functions.sh root@${host}:/etc/profile.d/
done

# Deploy sudoers to all workstations
on_all_computers 'echo "ALL ALL=(root) NOPASSWD: /usr/local/bin/backup-mount-helper" > /etc/sudoers.d/backup-mount && chmod 440 /etc/sudoers.d/backup-mount'

# Validate sudoers
on_all_computers "visudo -cf /etc/sudoers.d/backup-mount"
```

## NFS Export Configuration

On franksinatra, ensure `/mnt/everything/backup-testing` is exported:
```
/mnt/everything/backup-testing -alldirs -ro -quiet -maproot="root":"wheel" -network 141.166.180.0/22
/mnt/everything/backup-testing -alldirs -ro -quiet -maproot="root":"wheel" -network 141.166.184.0/22
/mnt/everything/backup-testing -alldirs -ro -quiet -maproot="root":"wheel" -network 141.166.220.0/22
/mnt/everything/backup-testing -alldirs -ro -quiet -maproot="root":"wheel" -network 141.166.224.0/22
```

After editing, reload exports:
```bash
service mountd reload
```

## User Commands

### view_my_files_from

List backup contents without mounting permanently.
```bash
view_my_files_from <machine> [path]
```

Examples:
```bash
view_my_files_from justin                     # List top level
view_my_files_from justin Documents           # List Documents/
view_my_files_from justin Documents/projectA  # List Documents/projectA/
```

### get_my_files_from

Mount backup to `/backups/<machine>/$USER/[path]`.
```bash
get_my_files_from <machine> [path]
```

Examples:
```bash
get_my_files_from justin                      # Mount entire home backup
get_my_files_from justin Documents/projectA   # Mount only projectA
```

### release_my_files

Unmount backups with confirmation.
```bash
release_my_files [machine]
```

Examples:
```bash
release_my_files                              # Show all mounts, confirm unmount
release_my_files justin                       # Unmount all justin mounts only
```

## Available Machines

aamy adam alexis badenpowell boyi camryn cooper evan hamilton irene2 josh justin kevin khanh mayer michael sarah thais

## Directory Structure
```
franksinatra:/mnt/everything/backup-testing/
├── justin/              # machine name
│   ├── jsmith/          # user's backed up home
│   ├── mjones/
│   └── ...
├── evan/
│   ├── jsmith/
│   └── ...
└── ...

/backups/                # mount point on workstations
├── justin/
│   └── jsmith/          # mounted NFS share
└── evan/
    └── jsmith/
```

## Mount Options

- `ro` - read-only (backups should not be modified)
- `noexec` - cannot execute files from mount
- `nosuid` - no setuid bits honored
- `vers=3` - NFSv3 for FreeBSD/Linux compatibility

## Troubleshooting

### "access denied by server"
Check NFS exports on franksinatra and reload with `service mountd reload`.

### "Protocol not supported"
NFS version mismatch - the helper uses `vers=3` for compatibility.

### User directory not found
Verify the user's backup exists on franksinatra:
```bash
ssh root@franksinatra "ls -la /mnt/everything/backup-testing/<machine>/<username>"
```
