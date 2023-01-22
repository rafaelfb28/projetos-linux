#!/bin/bash

systemctl restart smbd;

for cluster in $(cat /home/bkp_dedicados/servidores)
do
	servidor=$(echo $cluster | cut -d'|' -f1);
	diretorio_remoto=$(echo $cluster | cut -d'|' -f2);

	if [ $servidor == 'SRV1' ];
	then
		sshpass -p "user_bkp_2022" scp -rp -P 4922 /STORAGE/$servidor/$(date +%d-%m-%y --date="-1 day") user_bkp@saamauditoria.ddns.com.br:/BKP_DEDICADOS/$diretorio_remoto
	else
		sshpass -p "user_bkp_2022" scp -rp -P 4922 /STORAGE/$servidor/$(date +%d-%m-%y --date="-2 day") user_bkp@saamauditoria.ddns.com.br:/BKP_DEDICADOS/$diretorio_remoto
	fi
done
