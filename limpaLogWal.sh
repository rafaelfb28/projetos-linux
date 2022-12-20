#!/bin/bash

DIR_LOGS="/var/lib/postgresql/$1/$2/pg_wal";
LAST_LOG=$(cd ${DIR_LOGS} ; ls -rt *.backup | tail -1);
/usr/lib/postgresql/12/bin/pg_archivecleanup "${DIR_LOGS}" "${LAST_LOG}" &>> /home/bkp_dedicado/$3.log;;
