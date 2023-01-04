#!/bin/bash

for cluster in $(cat /home/bkp_dedicados/servidores)
do
	servidor=$(echo $cluster | cut -d'|' -f1)
	diretorio_remoto=$(echo $cluster | cut -d'|' -f2)

	#echo "SERVIDOR: $servidor"
	for porta in $(ls -l /STORAGE/$servidor | grep -v total | cut -d' ' -f10)
	do	
		#echo "Copiei a porta: $porta"			
		nohup echo "" >> /home/bkp_dedicados/$servidor/$porta.log && echo "Inicio do download da porta $porta com data $(date +%d-%m-%y)" >> /home/bkp_dedicados/$servidor/$porta.log && sshpass -p "user_bkp_2022" scp -rp -P 4922 /STORAGE/$servidor/$porta user_bkp@189.15.3.32:/BKP_DEDICADOS/$diretorio_remoto/$(date +%d-%m-%y) &>> /home/bkp_dedicados/$servidor/$porta.log && echo "" >> /home/bkp_dedicados/$servidor/$porta.log && echo "Fim do download da porta $porta com data $(date +%d-%m-%y)" >> /home/bkp_dedicados/$servidor/$porta.log && echo "" >> /home/bkp_dedicados/$servidor/$porta.log &
		sleep 5
	done
done	

