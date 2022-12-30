#!/bin/bash

#Recebendo e tratando o parametro que vem do arquivo primario
versao=$(echo $1 | cut -d'|' -f1);
cluster=$(echo $1 | cut -d'|' -f2);
porta=$(echo $1 | cut -d'|' -f3);
diretorio_mnt=$(echo $1 | cut -d'|' -f4);
diretorio_remoto=$(echo $1 | cut -d'|' -f5);

#Entrando no diretorio principal
cd /mnt/STORAGE/

DIR_LOGS='/var/lib/postgresql/$versao/$cluster/pg_wal'
LAST_LOG=$(cd ${DIR_LOGS} ; ls -rt *.backup | tail -1)

echo "" >> /home/bkp_dedicado/$porta.log;
echo "$(date +%H:%M:%S) - Inicio do processo de backup com data $(date +%d-%m-%y)" >> /home/bkp_dedicado/$porta.log;
echo "" >> /home/bkp_dedicado/$porta.log;
echo "$(date +%H:%M:%S) - Copiando 'webswing.config'" >> /home/bkp_dedicado/$porta.log;
sshpass -p "user_bkp_2022" scp -r -P 4922 /home/webswing/webswing.config user_bkp@189.15.3.32:/BKP_DEDICADOS/$diretorio_remoto/$(date +%d-%m-%y);
echo "" >> /home/bkp_dedicado/$porta.log;
echo "$(date +%H:%M:%S) - Criando a pasta $porta" >> /home/bkp_dedicado/$porta.log;
mkdir $diretorio_mnt/$porta &>> /home/bkp_dedicado/$porta.log;
cd $diretorio_mnt/$porta &>> /home/bkp_dedicado/$porta.log;
echo "" >> /home/bkp_dedicado/$porta.log;
echo "$(date +%H:%M:%S) - Limpando LOG WAL antigo" >> /home/bkp_dedicado/$porta.log;
/usr/lib/postgresql/12/bin/pg_archivecleanup "${DIR_LOGS}" "${LAST_LOG}"
echo "" >> /home/bkp_dedicado/$porta.log;
echo "$(date +%H:%M:%S) - Realizando o backup" >> /home/bkp_dedicado/$porta.log;
PGPASSWORD="10100306@" /usr/lib/postgresql/$versao/bin/pg_basebackup -h127.0.0.1 -p $porta -U sisaudconadaoavestruz@0620181.0.31 -D backup -Ft -z -P &>> /home/bkp_dedicado/$porta.log;
var=$(echo $?);
if [ $var == 0 ];
then
	echo "" >> /home/bkp_dedicado/$porta.log;
	echo "$(date +%H:%M:%S) - Backup realizado com sucesso" >> /home/bkp_dedicado/$porta.log;
	echo "" >> /home/bkp_dedicado/$porta.log;
	cd ..;		
	echo "$(date +%H:%M:%S) - Download da porta para o servidor local" >> /home/bkp_dedicado/$porta.log;
    sshpass -p "user_bkp_2022" scp -rp -P 4922 $porta user_bkp@189.15.3.32:/BKP_DEDICADOS/$diretorio_remoto/$(date +%d-%m-%y) &>> /home/bkp_dedicado/$porta.log;	
	echo "" >> /home/bkp_dedicado/$porta.log;
	echo "$(date +%H:%M:%S) - Removendo porta" >> /home/bkp_dedicado/$porta.log;
	rm -rf $porta &>> /home/bkp_dedicado/$porta.log;
elif [ $var == 1 ] || [ $var ==2 ]:
then
	echo "" >> /home/bkp_dedicado/$porta.log;
	echo "$(date +%H:%M:%S) - Erro ao realizar o Backup" >> /home/bkp_dedicado/$porta.log;
fi;
echo "" >> /home/bkp_dedicado/$porta.log;
echo "$(date +%H:%M:%S) - Fim do processo de backup com data $(date +%d-%m-%y)" >> /home/bkp_dedicado/$porta.log;

