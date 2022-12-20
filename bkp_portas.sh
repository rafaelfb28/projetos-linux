#!/bin/bash

porta=$1;

sshpass -p "user_bkp_2022" scp -r -P 4922 /home/webswing/webswing.config user_bkp@189.15.3.32:/BKP_DEDICADOS/BKP_DEDICADO_2/$(date +%d-%m-%y);

#sshpass -p "user_bkp_2022" scp -rp -P 4922 /home/SAAM-SPED/bkp/* user_bkp@189.15.3.32:/BKP_DEDICADOS/BKP_DEDICADO_2/$(date +%d-%m-%y)

cd /home/SAAM-SPED/bkp
echo "" >> /home/bkp_dedicado/$porta.log;
echo "$(date +%H:%M:%S) - Inicio do processo de download das portas com data $(date +%d-%m-%y)" >> /home/bkp_dedicado/$porta.log;
#for porta in $(seq 5432 5461);
#do
echo "" >> /home/bkp_dedicado/$porta.log;
echo "$(date +%H:%M:%S) - Realizando download da porta" >> /home/bkp_dedicado/$porta.log;
#Copiá de teste
#cp -r $porta /home/diretorio_salinha/ &>> /home/bkp_dedicado/$porta.log;
sshpass -p "user_bkp_2022" scp -rp -P 4922 $porta user_bkp@saamauditoria.ddns.com.br:/BKP_DEDICADOS/BKP_DEDICADO_2/$(date +%d-%m-%y) &>> /home/bkp_dedicado/$porta.log;
var=$(echo $?);
if [ $var == 0 ];
then
	echo "" >> /home/bkp_dedicado/$porta.log;
	echo "$(date +%H:%M:%S) - Download realizado com sucesso" >> /home/bkp_dedicado/$porta.log;
	echo "" >> /home/bkp_dedicado/$porta.log;
	echo "$(date +%H:%M:%S) - Removendo porta" >> /home/bkp_dedicado/$porta.log;
	rm -rf $porta &>> /home/bkp_dedicado/$porta.log;
elif [ $var == 1 ] || [ $var == 2 ];
then
	echo "" >> /home/bkp_dedicado/$porta.log;
	echo "$(date +%H:%M:%S) - Erro ao realizar download da porta" >> /home/bkp_dedicado/$porta.log;
fi;
#done
echo "" >> /home/bkp_dedicado/$porta.log;
echo "$(date +%H:%M:%S) - Fim do processo de download das portas com data $(date +%d-%m-%y)" >> /home/bkp_dedicado/$porta.log;


