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
        echo "Usage: get_my_files_from <machine>"
        echo "Available machines: $BACKUP_MACHINES"
        return 1
    fi
    sudo /usr/local/bin/backup-mount-helper mount "$1" "$USER"
    if [ $? -eq 0 ]; then
        echo "Your backup from $1 is now mounted at /backups/$1/$USER"
        echo "When finished, run: release_my_files $1"
    fi
}

release_my_files() {
    if [ -z "$1" ]; then
        echo "Usage: release_my_files <machine>"
        return 1
    fi
    sudo /usr/local/bin/backup-mount-helper umount "$1" "$USER"
    if [ $? -eq 0 ]; then
        echo "Backup from $1 has been unmounted."
    fi
}
