#!/bin/bash
echo "Saving env vars for crontab"
declare -p | grep -Ev 'BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|UID' > /container.env

echo "Starting cron and filebeat"
/etc/init.d/cron restart
/etc/init.d/filebeat restart
PIDFILE=`cat /etc/pgbouncer/pgbouncer.ini  | grep pidfile | cut -d ' ' -f 3`

echo "Removing '$PIDFILE' and starting PgBouncer"
rm -f $PIDFILE
/usr/sbin/pgbouncer -d -u postgres /etc/pgbouncer/pgbouncer.ini

echo "Starting Apache"
apache2-foreground