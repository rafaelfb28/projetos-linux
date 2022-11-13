#!/bin/bash	

for var in $(ls -l | cut -d':' -f2 | grep -v total |cut -d' ' -f2 | grep _ | grep -v tar);
do 
	nohup /home/bkp_dedicado/bkp_portas.sh $var & 	
done

cd /var/lib/postgresql/10 &&
echo "$(date +%H:%M:%S) - Inicio do processo de download dos clusters com data $(date +%d-%m-%y)" >> /home/bkp_dedicado/log.txt;
for cluster in $(ls -l | cut -d':' -f2 | grep -v total |cut -d' ' -f2 | grep _ | grep -v tar);
do
	echo "" >> /home/bkp_dedicado/log.txt;
	echo "$(date +%H:%M:%S) - Parando o SAAM-SERVIÇO" >> /home/bkp_dedicado/log.txt;
	systemctl stop saam;
	echo "" >> /home/bkp_dedicado/log.txt;
	echo "$(date +%H:%M:%S) - Parando o cluster $cluster" >> /home/bkp_dedicado/log.txt;
	pg_ctlcluster 10 $cluster stop;
	echo "" >> /home/bkp_dedicado/log.txt;
	echo "$(date +%H:%M:%S) - Compactando o cluster $cluster" >> /home/bkp_dedicado/log.txt;
	tar -pzcvf $cluster.tar.gz $cluster &>> /dev/null;
	echo "" >> /home/bkp_dedicado/log.txt;
	echo "$(date +%H:%M:%S) - Iniciando o cluster $cluster" >> /home/bkp_dedicado/log.txt;
	pg_ctlcluster 10 $cluster start;
	echo "" >> /home/bkp_dedicado/log.txt;
	echo "$(date +%H:%M:%S) - Fazendo BKP do cluster $cluster para o servidor da salinha" >> /home/bkp_dedicado/log.txt;
	sshpass -p "user_bkp_2022" scp -rp -P 4922 $cluster.tar.gz user_bkp@189.15.3.32:/BKP_DEDICADOS/BKP_DEDICADO_1/$(date +%d-%m-%y)/10 &>> /home/bkp_dedicado/log.txt;	
	var=$(echo $?)
	if [ $var == 0 ];
	then 
		echo "" >> /home/bkp_dedicado/log.txt;
		echo "$(date +%H:%M:%S) - Download realizado com sucesso" >> /home/bkp_dedicado/log.txt;
		echo "" >> /home/bkp_dedicado/log.txt;
		echo "$(date +%H:%M:%S) - Removendo compactado do cluster $cluster" >> /home/bkp_dedicado/log.txt;
		rm $cluster.tar.gz	
	elif [ $var == 1 ] || [ $var == 2 ];
	then
		echo "" >> /home/bkp_dedicado/log.txt;
		echo "$(date +%H:%M:%S) - Erro ao realizar download do cluster $cluster" >> /home/bkp_dedicado/log.txt;
	fi;	
	echo "" >> /home/bkp_dedicado/log.txt;
	echo "$(date +%H:%M:%S) - Iniciando o SAAM-SERVIÇO" >> /home/bkp_dedicado/log.txt;
	systemctl start saam;
	#sleep 2;
done	
echo "" >> /home/bkp_dedicado/log.txt;
echo "$(date +%H:%M:%S) - Fim do processo de download dos clusters com data $(date +%d-%m-%y)" >> /home/bkp_dedicado/log.txt;
echo "" >> /home/bkp_dedicado/log.txt;
