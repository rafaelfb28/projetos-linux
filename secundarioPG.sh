#!/bin/bash

versao=$(echo $1| cut -d'|' -f1);
cluster=$(echo $1 | cut -d'|' -f2);
porta=$(echo $1 | cut -d'|' -f3);
diretorio_mnt=$(echo $1 | cut -d'|' -f4);
diretorio_remoto=$(echo $1 | cut -d'|' -f5);

#echo "Porta: $porta";
echo "";
echo "$(date +%H:%M:%S) - Inicio do processo de backup com data $(date +%d-%m-%y)" >> /home/bkp_dedicado/$porta.log;
rm -rf /mnt/STORAGE/$diretorio_mnt/$porta;
mkdir /mnt/STORAGE/$diretorio_mnt/$porta;

for base in $(PGPASSWORD="10100306@" psql -h localhost -p $porta -U sisaudconadaoavestruz@0620181.0.31 -d postgres -c "select datname from pg_database where datname ilike '%sped%'" | grep -v datname | grep -v - | grep -v row)
do
	PGPASSWORD="10100306@" /usr/lib/postgresql/$versao/bin/pg_dump --host localhost --port $porta --username "sisaudconadaoavestruz@0620181.0.31"  --format custom --blobs --verbose --file "/mnt/STORAGE/$diretorio_mnt/$porta/$base.backup" "$base" &>> /dev/null
	#echo "Base: $base | Porta: $porta | Versão: $versao";
done
echo "";
echo "$(date +%H:%M:%S) - Fim do processo de backup com data $(date +%d-%m-%y)" >> /home/bkp_dedicado/$porta.log;
echo "";
