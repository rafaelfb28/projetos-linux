#!/bin/bash

#Recebendo e tratando o parametro que vem do arquivo primario
versao=$(echo $1 | cut -d'|' -f1);
cluster=$(echo $1 | cut -d'|' -f2);
porta=$(echo $1 | cut -d'|' -f3);
diretorio_mnt=$(echo $1 | cut -d'|' -f4);
diretorio_remoto=$(echo $1 | cut -d'|' -f5);
log=$porta"_"$cluster.log;
porta_cluster=$porta"_"$cluster;

#Entrando no diretorio principal
cd /mnt/STORAGE/

DIR_LOGS='/var/lib/postgresql/$versao/$cluster/pg_wal'
LAST_LOG=$(cd ${DIR_LOGS} ; ls -rt *.backup | tail -1)

echo "" >> /home/bkp_dedicado/$log;
echo "$(date +%H:%M:%S) - Inicio do processo de backup com data $(date +%d-%m-%y)" >> /home/bkp_dedicado/$log;
echo "" >> /home/bkp_dedicado/$log;
echo "$(date +%H:%M:%S) - Copiando 'webswing.config'" >> /home/bkp_dedicado/$log;
sshpass -p "user_bkp_2022" scp -r -P 4922 /home/webswing/webswing.config user_bkp@189.15.3.32:/BKP_DEDICADOS/$diretorio_remoto/ &>> /home/bkp_dedicado/$log;
#echo "" >> /home/bkp_dedicado/$log;
#echo "$(date +%H:%M:%S) - Criando a pasta $porta" >> /home/bkp_dedicado/$log;
#mkdir $diretorio_mnt/$porta"_"$cluster &>> /home/bkp_dedicado/$log;
cd $diretorio_mnt/ &>> /home/bkp_dedicado/$log;
echo "" >> /home/bkp_dedicado/$log;
echo "$(date +%H:%M:%S) - Limpando LOG WAL antigo" >> /home/bkp_dedicado/$log;
/usr/lib/postgresql/$versao/bin/pg_archivecleanup "${DIR_LOGS}" "${LAST_LOG}" &>> /home/bkp_dedicado/$log;
echo "" >> /home/bkp_dedicado/$log;
echo "$(date +%H:%M:%S) - Realizando o backup" >> /home/bkp_dedicado/$log;
PGPASSWORD="10100306@" /usr/lib/postgresql/$versao/bin/pg_basebackup -h127.0.0.1 -p $porta -U sisaudconadaoavestruz@0620181.0.31 -D $porta_cluster -Ft -z -P &>> /home/bkp_dedicado/$log;
var=$(echo $?);
if [ $var == 0 ];
then
	echo "" >> /home/bkp_dedicado/$log;
	echo "$(date +%H:%M:%S) - Backup realizado com sucesso" >> /home/bkp_dedicado/$log;
	echo "" >> /home/bkp_dedicado/$log;
	#cd ..;		
	echo "$(date +%H:%M:%S) - Download da porta para o servidor local" >> /home/bkp_dedicado/$log;
    sshpass -p "user_bkp_2022" scp -rp -P 4922 $porta_cluster user_bkp@189.15.3.32:/BKP_DEDICADOS/$diretorio_remoto/ &>> /home/bkp_dedicado/$log;	
	#echo "" >> /home/bkp_dedicado/$log;
	#echo "$(date +%H:%M:%S) - Removendo porta" >> /home/bkp_dedicado/$log;
	#rm -rf $porta &>> /home/bkp_dedicado/$log;
elif [ $var == 1 ] || [ $var ==2 ]:
then
	echo "" >> /home/bkp_dedicado/$log;
	echo "$(date +%H:%M:%S) - Erro ao realizar o Backup" >> /home/bkp_dedicado/$log;
fi;
echo "" >> /home/bkp_dedicado/$log;
echo "$(date +%H:%M:%S) - Fim do processo de backup com data $(date +%d-%m-%y)" >> /home/bkp_dedicado/$log;

