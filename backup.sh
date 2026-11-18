#!/bin/bash
set -euo pipefail

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="/opt/backups"
LOG_FILE="/var/log/wp_backup.log"

set -a
source /opt/wordpress/.env
set +a

echo "[$DATE] Starting WordPress and MySQL backup..." >> "$LOG_FILE"

docker compose -f /opt/wordpress/docker-compose.yml exec -T db \
  mysqldump --no-tablespaces -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" \
  | gzip > "$BACKUP_DIR/db_$DATE.sql.gz"

docker run --rm \
  -v wordpress_wp_data:/data:ro \
  -v "$BACKUP_DIR":/backup \
  alpine tar czf "/backup/wp_files_$DATE.tar.gz" -C /data .

find "$BACKUP_DIR" -type f -mtime +7 -delete

echo "[$DATE] Backup completed successfully: db_$DATE.sql.gz & wp_files_$DATE.tar.gz" >> "$LOG_FILE"
