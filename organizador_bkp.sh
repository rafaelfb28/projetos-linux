#!/bin/bash

for cluster in $(cat /home/bkp_dedicados/servidores)
do
	dataDeletada=$(date +%d-%m-%y --date="-2 day")
	servidor=$(echo $cluster | cut -d'|' -f1);

	mkdir /STORAGE/$servidor/$(date +%d-%m-%y --date="-1 day");
	mv /STORAGE/$servidor/5* /STORAGE/$servidor/$(date +%d-%m-%y --date="-1 day")/;

	#echo "Servidor: $servidor"
	#echo "Data a ser deletada: $dataDeletada"
	for pasta in $(ls -l /STORAGE/$servidor/ | cut -d':' -f2 | grep -v total | cut -d' ' -f2)
	do
		if [ $pasta == $dataDeletada ];
		then
			#echo "Deletei a pasta $pasta"
			rm -rf /STORAGE/$servidor/$pasta
		fi
	done
done
