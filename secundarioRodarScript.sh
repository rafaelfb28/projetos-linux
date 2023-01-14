#!/bin/bash

script=$(cat /home/rodarScriptTodosClusters/script.txt)
cluster=$(echo $1 | cut -d'|' -f2);
porta=$(echo $1 | cut -d'|' -f3);

echo "" >> /home/rodarScriptTodosClusters/$porta"_"$cluster.log;
echo "$(date +%H:%M:%S) - Inicio Porta: $porta | Cluster: $cluster" >> /home/rodarScriptTodosClusters/$porta"_"$cluster.log;
echo "" >> /home/rodarScriptTodosClusters/$porta"_"$cluster.log;
echo "SCRIPT: $script" >> /home/rodarScriptTodosClusters/$porta"_"$cluster.log;
echo "" >> /home/rodarScriptTodosClusters/$porta"_"$cluster.log;
for base in $(PGPASSWORD="10100306@" psql -h localhost -p $porta -U sisaudconadaoavestruz@0620181.0.31 -d postgres -c "select datname from pg_database where datname ilike '%sped%'" | grep -v datname | grep -v - | grep -v row)
do
	echo "$(date +%H:%M:%S) - Base: $base" >> /home/rodarScriptTodosClusters/$porta"_"$cluster.log;
	echo "" >> /home/rodarScriptTodosClusters/$porta"_"$cluster.log;
	echo "$(date +%H:%M:%S) - Vou rodar o SCRIPT" >> /home/rodarScriptTodosClusters/$porta"_"$cluster.log;
	echo "" >> /home/rodarScriptTodosClusters/$porta"_"$cluster.log;
	PGPASSWORD="10100306@" psql -h localhost -p $porta -U sisaudconadaoavestruz@0620181.0.31 -d $base -c "$script" &>> /home/rodarScriptTodosClusters/$porta"_"$cluster.log
	echo "" >> /home/rodarScriptTodosClusters/$porta"_"$cluster.log;
	echo "$(date +%H:%M:%S) - Terminei de rodar o SCRIPT " >> /home/rodarScriptTodosClusters/$porta"_"$cluster.log;
	echo "" >> /home/rodarScriptTodosClusters/$porta"_"$cluster.log;
done
echo "$(date +%H:%M:%S) - Fim Porta: $porta | Cluster: $cluster" >> /home/rodarScriptTodosClusters/$porta"_"$cluster.log;