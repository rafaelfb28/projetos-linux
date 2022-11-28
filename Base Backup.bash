#!/bin/bash

porta=$1;

cd /home/SAAM-SPED/bkp/

echo "" >> /home/bkp_dedicado/$porta.log
echo "$(date +%H:%M:%S) - Inicio do processo de backup e download com data $(date +%d-%m-%y)" >> /home/bkp_dedicado/$porta.log;
echo "" >> /home/bkp_dedicado/$porta.log
echo "$(date +%H:%M:%S) - Criando a pasta $porta" >> /home/bkp_dedicado/$porta.log;
mkdir $porta
echo "" >> /home/bkp_dedicado/$porta.log
echo "$(date +%H:%M:%S) - Criando a pasta pg_log_archive" >> /home/bkp_dedicado/$porta.log;
mkdir $porta/pg_log_archive
echo "" >> /home/bkp_dedicado/$porta.log
echo "$(date +%H:%M:%S) - Dando permissão e tornando o POSTGRES dono da pasta 'pg_log_archive'" >> /home/bkp_dedicado/$porta.log;
chown -R postgres.postgres  /home/SAAM-SPED/bkp/$porta/pg_log_archive
chmod 700 /home/SAAM-SPED/bkp/$porta/pg_log_archive
cd $porta
echo "" >> /home/bkp_dedicado/$porta.log
echo "$(date +%H:%M:%S) - Realizando o backup" >> /home/bkp_dedicado/$porta.log;
PGPASSWORD="10100306@" /usr/bin/pg_basebackup -h127.0.0.1 -p $porta -U sisaudconadaoavestruz@0620181.0.31 -D backup -Ft -z -P &>> /home/bkp_dedicado/$porta.log;
cd ..
echo "" >> /home/bkp_dedicado/$porta.log
echo "$(date +%H:%M:%S) - Realizando download do backup para o servidor da salinha" >> /home/bkp_dedicado/$porta.log;
sshpass -p "user_bkp_2022" scp -rp -P 4922 $porta user_bkp@saamauditoria.ddns.com.br:/BKP_DEDICADOS/BKP_DEDICADO_2/$(date +%d-%m-%y) &>> /home/bkp_dedicado/$porta.log;
var=$(echo $?)
if [ $var == 0 ];
then
    echo "" >> /home/bkp_dedicado/$porta.log;
    echo "$(date +%H:%M:%S) - Download realizado com sucesso" >> /home/bkp_dedicado/$porta.log;
    echo "" >> /home/bkp_dedicado/$porta.log;
    echo "$(date +%H:%M:%S) - Removendo posta" >> /home/bkp_dedicado/$porta.log;
    rm -rf $porta &>> /home/bkp_dedicado/$porta.log;
elif [ $var == 1 ] || [ $var == 2 ];
then
    echo "" >> &>> /home/bkp_dedicado/$porta.log;;
    echo "$(date +%H:%M:%S) - Erro ao realizar o download" >> &>> /home/bkp_dedicado/$porta.log;;
fi;
echo "" >> /home/bkp_dedicado/$porta.log;
echo "$(date +%H:%M:%S) - Fim do processo de backup e download com data $(date +%d-%m-%y)" >> /home/bkp_dedicado/$porta.log;
