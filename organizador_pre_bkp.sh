#!/bin/bash

hoje=$(date +%d-%m-%y)

for diretorio in `ls -l /BKP_DEDICADOS/ | grep BKP_ | grep -v tar.gz | cut -d':' -f2 | cut -d' ' -f2`;
do
	#Inicio do BKP da pasta desenvolvimento
        if [ $diretorio == 'BKP_DESENVOLVIMENTO' ];
        then
                cd /BKP_DEDICADOS/$diretorio
                rm -rf $hoje
                mkdir $hoje
                chmod -R 777 $hoje
                cp -r /dados/samba/desenvolvimento/* $hoje
		find -mtime +1 -delete
	#Inicio do BKP do banco da LOCAWEB
        elif [ $diretorio == 'BKP_LOCAWEB' ];
        then
                cd /BKP_DEDICADOS/$diretorio
                rm -rf $hoje
                mkdir $hoje
                chmod -R 777 $hoje
                PGPASSWORD="cr10100306@"  /usr/bin/pg_dump --host saam_clientes.postgresql.dbaas.com.br --port 5432 --username "saam_clientes" --format custom --blobs --verbose --file "/BKP_DEDICADOS/$diretorio/$hoje/saam_clientes.backup" "saam_clientes"
		find -mtime +1 -delete
	#Inicio do BKP do banco SPEDAO
        elif [ $diretorio == 'BKP_SPEDAO' ];
        then
                cd /BKP_DEDICADOS/$diretorio
                rm -rf $hoje
                mkdir $hoje
                chmod -R 777 $hoje
                PGPASSWORD="10100306@"  /usr/lib/postgresql/9.6/bin/pg_dump --host localhost --port 5432 --username "sisaudconadaoavestruz@0620181.0.31" --format custom --blobs --verbose --file "/BKP_DEDICADOS/$diretorio/$hoje/sped.backup" "sped"
		find -mtime +1 -delete
	#Inicio da criação das pastas de BKP dos servidores DEDICADOS OBS(O SCP responsavel por jogar o BKP nas pastas está em cada dedicado)
        else
			#mkdir /BKP_DEDICADOS/$diretorio/$(date +%d-%m-%y --date="-1 day")
			#chmod -R 777 /BKP_DEDICADOS/$diretorio/$(date +%d-%m-%y --date="-1 day")
			#mv /BKP_DEDICADOS/$diretorio/5* /BKP_DEDICADOS/$diretorio/$(date +%d-%m-%y --date="-1 day")
			
			dataDeletada=$(date +%d-%m-%y --date="-4 day")
			#echo "Servidor: $diretorio"
			#echo "Data a ser deletada: $dataDeletada"
			for pasta in $(ls -l /BKP_DEDICADOS/$diretorio/ | cut -d':' -f2 | grep -v total | cut -d' ' -f2)
			do
				if [ $pasta == $dataDeletada ];
				then
					#echo "Deletei a pasta $pasta"
					rm -rf /BKP_DEDICADOS/$diretorio/$pasta
				fi
			done
        fi
done

