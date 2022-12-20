#!/bin/bash	

for porta in $(cat /home/bkp_dedicado/portas.txt);
do
	nohup /home/bkp_dedicado/secundario.sh $porta &
	sleep 10
done
