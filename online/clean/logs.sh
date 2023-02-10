DAYS=30
echo "Removing all files older than $DAYS days from /var/log"
sudo find /var/log -type f -mtime +$DAYS -delete
