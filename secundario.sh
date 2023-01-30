#!/bin/bash

versao=$(echo $1| cut -d'|' -f1);
cluster=$(echo $1 | cut -d'|' -f2);
porta=$(echo $1 | cut -d'|' -f3);
diretorio_mnt=$(echo $1 | cut -d'|' -f4);
diretorio_remoto=$(echo $1 | cut -d'|' -f5);
dataHoje=$(date +%d-%m-%y);

#echo "Porta: $porta";
#echo "";
#echo "$(date +%H:%M:%S) - Inicio do processo de backup com data $(date +%d-%m-%y)" >> /home/bkp_dedicado/$porta.log;
rm -rf /mnt/STORAGE/$diretorio_mnt/$dataHoje/$porta;
mkdir /mnt/STORAGE/$diretorio_mnt/$dataHoje/$porta;

if [ $porta == '5458' ];
then
	#echo "Entrei na porta $porta" >> /home/bkp_dedicado/$porta"_teste".log
	nohup /home/bkp_dedicado/cooperativoPlanning.sh &
		
	for base in $(PGPASSWORD="10100306@" psql -h localhost -p $porta -U sisaudconadaoavestruz@0620181.0.31 -d postgres -c "select datname from pg_database where datname ilike '%sped_%' and SUBSTRING(datname, 6, 4)::numeric not BETWEEN 1::numeric and 400::numeric order by SUBSTRING(datname, 6, 4)::numeric" | grep -v datname | grep -v - | grep -v row)
	do
		PGPASSWORD="10100306@" /usr/lib/postgresql/$versao/bin/pg_dump --host localhost --port $porta --username "sisaudconadaoavestruz@0620181.0.31"  --format custom --blobs --file "/mnt/STORAGE/$diretorio_mnt/$dataHoje/$porta/$base.backup" "$base" &>> /dev/null
		#echo "Base: $base | Porta: $porta | Versão: $versao";
	done
else
	#echo "Não entrei na porta 5458" >> /home/bkp_dedicado/$porta"_teste".log
	for base in $(PGPASSWORD="10100306@" psql -h localhost -p $porta -U sisaudconadaoavestruz@0620181.0.31 -d postgres -c "select a.datname from (select datname from pg_database where datname ilike '%sped%')a order by case when a.datname not in('sped','template_sped') then SUBSTRING(datname, 6, 4)::numeric end" | grep -v datname | grep -v - | grep -v row)
	do
		PGPASSWORD="10100306@" /usr/lib/postgresql/$versao/bin/pg_dump --host localhost --port $porta --username "sisaudconadaoavestruz@0620181.0.31"  --format custom --blobs --file "/mnt/STORAGE/$diretorio_mnt/$dataHoje/$porta/$base.backup" "$base" &>> /dev/null
		#echo "Base: $base | Porta: $porta | Versão: $versao";
	done
fi
#echo "";
#echo "$(date +%H:%M:%S) - Fim do processo de backup com data $(date +%d-%m-%y)" >> /home/bkp_dedicado/$porta.log;
#echo "";
