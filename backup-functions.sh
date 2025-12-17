# Functions for accessing backup files from franksinatra

# List of machines with backups available
BACKUP_MACHINES="aamy adam alexis badenpowell boyi camryn cooper evan hamilton irene2 josh justin kevin khanh mayer michael sarah thais"

view_my_files_from() {
    if [ -z "$1" ]; then
        echo "Usage: view_my_files_from <machine> [path]"
        echo "Examples:"
        echo "  view_my_files_from justin"
        echo "  view_my_files_from justin Documents"
        echo "  view_my_files_from justin Documents/projectA"
        echo "Available machines: $BACKUP_MACHINES"
        return 1
    fi
    if [ -n "$2" ]; then
        echo "Listing $2 from your backup on $1..."
    else
        echo "Listing your backup files from $1..."
    fi
    sudo /usr/local/bin/backup-mount-helper view "$1" "$USER" "$2"
}

get_my_files_from() {
    if [ -z "$1" ]; then
        echo "Usage: get_my_files_from <machine> [path]"
        echo "Examples:"
        echo "  get_my_files_from justin"
        echo "  get_my_files_from justin Documents/projectA"
        echo "Available machines: $BACKUP_MACHINES"
        return 1
    fi
    sudo /usr/local/bin/backup-mount-helper mount "$1" "$USER" "$2"
    if [ $? -eq 0 ]; then
        if [ -n "$2" ]; then
            echo "Your backup from $1 is now mounted at /backups/$1/$USER/$2"
            echo "When finished, run: release_my_files $1"
        else
            echo "Your backup from $1 is now mounted at /backups/$1/$USER"
            echo "When finished, run: release_my_files $1"
        fi
    fi
}

release_my_files() {
    # Get list of mounts
    if [ -n "$1" ]; then
        MOUNTS=$(sudo /usr/local/bin/backup-mount-helper list "$1" "$USER")
    else
        MOUNTS=$(sudo /usr/local/bin/backup-mount-helper list "" "$USER")
    fi

    if [ -z "$MOUNTS" ]; then
        if [ -n "$1" ]; then
            echo "No backups from $1 are currently mounted."
        else
            echo "No backups are currently mounted."
        fi
        return 0
    fi

    echo "The following backup(s) are mounted:"
    echo "$MOUNTS" | while read -r m; do echo "  $m"; done
    echo ""
    read -p "Unmount these? [y/N] " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        sudo /usr/local/bin/backup-mount-helper umount "$1" "$USER"
        echo "Backup(s) unmounted."
    else
        echo "Cancelled."
    fi
}
