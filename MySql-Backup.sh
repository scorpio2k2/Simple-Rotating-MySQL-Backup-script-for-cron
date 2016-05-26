    #!/bin/bash
    #Simple mySQL backup script for cron – updated version

    # Modify the following to suit your environment
    export DB_BACKUP="/home/user/mysql_backup"
    export DB_USER="root"
    export DB_PASSWD="***********"
    export DATE="'date +"%d%b"'"
    export MYSQL="/usr/bin/mysql"
    export MYSQLDUMP="/usr/bin/mysqldump"

    # Backup part
    echo "mySQL_backup"
    echo "———————-"
    echo "* Rotating backups…"
    rm -rf $DB_BACKUP/04
    mv $DB_BACKUP/03 $DB_BACKUP/04
    mv $DB_BACKUP/02 $DB_BACKUP/03
    mv $DB_BACKUP/01 $DB_BACKUP/02
    mkdir $DB_BACKUP/01

    cd $DB_BACKUP/ && cd $DB_BACKUP/01
    $MYSQL -u $DB_USER -p=$DB_PASSWD -Bse "show databases" |while read m; \
    do $MYSQLDUMP -u $DB_USER -password=$DB_PASSWD `echo $m` > `echo $m`.sql;done
    bzip2 *sql

    echo "* Creating new backup…"
    echo "Backup done! `date`" > /tmp/my_report.log

    # You can set the script to send you mail when backup it’s finished.
    mail -s "MySql Backup report" you@yourmail.com < /tmp/my_report.log
    echo "----------------------"
    echo "Done"
    exit 0
