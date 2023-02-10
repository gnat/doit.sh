DAYS=7
sudo find /var/log -type f -mtime +$DAYS -delete
