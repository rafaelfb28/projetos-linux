#!/bin/bash

versao=$(echo $1 | cut -d'|' -f1);
cluster=$(echo $1 | cut -d'|' -f2);
porta=$(echo $1 | cut -d'|' -f3);

cd /mnt/STORAGE/

echo "" >> /home/bkp_dedicado/$porta.log;
echo "$(date +%H:%M:%S) - Inicio do processo de backup com data $(date +%d-%m-%y)" >> /home/bkp_dedicado/$porta.log;
echo "" >> /home/bkp_dedicado/$porta.log;
echo "$(date +%H:%M:%S) - Copiando 'webswing.config'" >> /home/bkp_dedicado/$porta.log;
sshpass -p "user_bkp_2022" scp -r -P 4922 /home/webswing/webswing.config user_bkp@189.15.3.32:/BKP_DEDICADOS/BKP_DEDICADO_2/$(date +%d-%m-%y);
echo "" >> /home/bkp_dedicado/$porta.log;
echo "$(date +%H:%M:%S) - Criando a pasta $porta" >> /home/bkp_dedicado/$porta.log;
mkdir $porta &>> /home/bkp_dedicado/$porta.log;
echo "" >> /home/bkp_dedicado/$porta.log;
echo "$(date +%H:%M:%S) - Criando a pasta pg_log_archive" >> /home/bkp_dedicado/$porta.log;
mkdir $porta/pg_log_archive &>> /home/bkp_dedicado/$porta.log;
cd $porta &>> /home/bkp_dedicado/$porta.log;
echo "" >> /home/bkp_dedicado/$porta.log;
echo "$(date +%H:%M:%S) - Realizando o backup" >> /home/bkp_dedicado/$porta.log;
PGPASSWORD="10100306@" /usr/lib/postgresql/12/bin/pg_basebackup -h127.0.0.1 -p $porta -U sisaudconadaoavestruz@0620181.0.31 -D backup -Ft -z -P &>> /home/bkp_dedicado/$porta.log;
var=$(echo $?);
if [ $var == 0 ];
then
	echo "" >> /home/bkp_dedicado/$porta.log;
	echo "$(date +%H:%M:%S) - Backup realizado com sucesso" >> /home/bkp_dedicado/$porta.log;
	echo "" >> /home/bkp_dedicado/$porta.log;
	cd ..;
	echo "$(date +%H:%M:%S) - Download da porta para o servidor local" >> /home/bkp_dedicado/$porta.log;
    sshpass -p "user_bkp_2022" scp -rp -P 4922 $porta user_bkp@189.15.3.32:/BKP_DEDICADOS/BKP_DEDICADO_2/$(date +%d-%m-%y) &>> /home/bkp_dedicado/$porta.log;
	echo "$(date +%H:%M:%S) - Limpando LOG´s WAL antigos" >> /home/bkp_dedicado/$porta.log;
	/home/bkp_dedicado/limpaLogWal.sh $versao $cluster $porta &>> /home/bkp_dedicado/$porta.log;
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

