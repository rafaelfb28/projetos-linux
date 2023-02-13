#!/bin/bash
#Automacao criacao de cluster
#Inicio Variveis Globais
TIME=4
if [ $(hostname -I) == '187.108.195.107' ];
	then
		   indicadorBKP=1
	elif [ $(hostname -I) == '187.108.203.29' ];
	then
			indicadorBKP=2
	elif [ $(hostname -I) == '187.108.200.43' ];
	then
			 indicadorBKP=3
	elif [ $(hostname -I) == '187.108.200.220' ];
	then   
			indicadorBKP=4
	else		
			indicadorBKP=5
fi
#Fim Variveis Globais
clear
while true;do
echo " "
echo -e "\e[0;35mSEJA BEM VINDO AO CRIADOR DE CLUSTER DO SAAM! \e[00m"
echo " "
echo "Escolha uma opcao abaixo para comecar!

      1 - Listar cluster.
      2 - Criar novo cluster.
      3 - Excluir cluster.
      4 - Renomear cluster.
      0 - Sair do sistema"
echo " "
echo -n "Opcao escolhida: "
read opcao 
case $opcao in
        1)      clear
		pg_lsclusters
		;;
	2)      clear
		echo "Digite o nome do cluster EX: '000111_saam': "
                read cluster
		echo " "
		echo "Digite a versao do banco: "
		read versao	
		echo " "
		echo "Informe a alocacao de memoria para continuar:
(EX: 10, 14, ou MANUAL)"
                echo " "
                echo "Memoria escolhida: "
                read memoria
		echo " "
		echo "Informe o nome da empresa: "
                read nomeEmpresa
                echo " "
                echo "Informe o limite de empresas: "
                read limite
		echo " "
		clear
                pg_createcluster $versao $cluster
		porta=$(pg_lsclusters | grep down | awk '{print $3}')
                sed -i 's/local   all             all                                     peer/local   all             all                                     trust/' /etc/postgresql/$versao/$cluster/pg_hba.conf
		sed -i 's/32            md5/32            trust/' /etc/postgresql/$versao/$cluster/pg_hba.conf
		sed -i 's/128                 md5/128                 trust/' /etc/postgresql/$versao/$cluster/pg_hba.conf
		pg_ctlcluster $versao $cluster start
		clear
		echo "Alterando a senha do usuario postgres ..."
		echo " "
                sleep $TIME
		psql -h localhost -p $porta -U postgres -d postgres -c "ALTER USER postgres WITH PASSWORD '10100306@';"
		clear
		if [ $memoria == '10' ];
                       then     
                                echo "Alterando variaveis do banco ..."
                                echo " "
				sleep $TIME
				psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET shared_buffers = '3GB';"
                		psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET effective_cache_size = '8GB';"
      	    	                psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET maintenance_work_mem = '512MB';"
               		        psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET checkpoint_completion_target = '0.9';"
                		psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET wal_buffers = '-1';"
                		psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET default_statistics_target = '500';"
                		psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET random_page_cost = '1.1';"
                		psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET effective_io_concurrency = '200';"
                		psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET work_mem = '51MB';"
                		psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET min_wal_size = '2GB';"
                		psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET max_wal_size = '3GB';"
                		psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET max_worker_processes = '8';"
                		psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET max_parallel_workers_per_gather = '2';"
                		psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET max_parallel_workers = '2';"
                		psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET enable_nestloop = 'off';"
                		psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET log_line_prefix = '%t [%p]: [%l-1] user=%u saam=%a,db=%d ';"
				clear
				
		elif [ $memoria == '14' ];
                        then
                                echo "Alterando variaveis do banco ..."
                                echo " "
				sleep $TIME
                                psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET shared_buffers = '4GB';"
                                psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET effective_cache_size = '11GB';"
                                psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET maintenance_work_mem = '717MB';"
                                psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET checkpoint_completion_target = '0.9';"
                                psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET wal_buffers = '-1';"
                                psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET default_statistics_target = '500';"
                                psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET random_page_cost = '1.1';"
                                psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET effective_io_concurrency = '200';"
                                psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET work_mem = '72MB';"
                                psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET min_wal_size = '2GB';"
                                psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET max_wal_size = '3GB';"
                                psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET max_worker_processes = '8';"
                                psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET max_parallel_workers_per_gather = '2';"
                                psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET max_parallel_workers = '2';"
                                psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET enable_nestloop = 'off';"
                                psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET log_line_prefix = '%t [%p]: [%l-1] user=%u saam=%a,db=%d ';"
				clear
		else [ $memoria == 'MANUAL' ];
				echo "Digite o valor para variavel shared_buffers: "
                		read sharedeBuffers
				echo " "
				echo "Digite o valor para variavel effective_cache_size: "
                		read effectiveCacheSize
				echo " "
				echo "Digite o valor para variavel maintenance_work_mem: "
                		read maintenanceWorkeMem
				echo " "
				echo "Digite o valor para variavel work_mem: "
                		read workMem
				echo " "
				echo "Alterando as variaveis do banco ..."
                		sleep $TIME
				echo " "
				psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET shared_buffers = '$sharedeBuffers';"
				psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET effective_cache_size = '$effectiveCacheSize';"
				psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET maintenance_work_mem = '$maintenanceWorkeMem';"
				psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET checkpoint_completion_target = '0.9';"
				psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET wal_buffers = '-1';"
				psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET default_statistics_target = '500';"
				psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET random_page_cost = '1.1';"
				psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET effective_io_concurrency = '200';"
				psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET work_mem = '$workMem';"
				psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET min_wal_size = '2GB';"
				psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET max_wal_size = '3GB';"
				psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET max_worker_processes = '8';"
				psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET max_parallel_workers_per_gather = '2';"
				psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET max_parallel_workers = '2';"
				psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET enable_nestloop = 'off';"
				psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET log_line_prefix = '%t [%p]: [%l-1] user=%u saam=%a,db=%d ';"
					if [ $versao -lt 10 ];
					then
						psql -h localhost -p $porta -U postgres -d postgres -c "ALTER SYSTEM SET jit = 'off';"
					fi
				fi
                                sleep $TIME
				clear
		pg_ctlcluster $versao $cluster restart
		echo "Criando usuarios no banco ..."
		echo " "
		psql -h localhost -p $porta -U postgres -d postgres -c "CREATE ROLE \"sisaudconjacopeixe@0520201.0.34\" LOGIN PASSWORD '10100306@' SUPERUSER CREATEDB CREATEROLE REPLICATION VALID UNTIL 'infinity';"
		psql -h localhost -p $porta -U postgres -d postgres -c "CREATE ROLE \"sisaudconabeltatu@0720191.0.33\" LOGIN PASSWORD '10100306@' SUPERUSER CREATEDB CREATEROLE REPLICATION VALID UNTIL 'infinity';" 
		psql -h localhost -p $porta -U postgres -d postgres -c "CREATE ROLE \"sisaudconevagato@1120181.0.32\" LOGIN PASSWORD '10100306@' SUPERUSER CREATEDB CREATEROLE REPLICATION VALID UNTIL 'infinity';"
		psql -h localhost -p $porta -U postgres -d postgres -c "CREATE ROLE \"sisaudconadaoavestruz@0620181.0.31\" LOGIN PASSWORD '10100306@' SUPERUSER CREATEDB CREATEROLE REPLICATION VALID UNTIL 'infinity';"
		psql -h localhost -p $porta -U postgres -d postgres -c "CREATE ROLE \"sisaudcon10100306@1120171.0.30\" LOGIN PASSWORD '10100306@' SUPERUSER CREATEDB CREATEROLE REPLICATION VALID UNTIL 'infinity';"
		psql -h localhost -p $porta -U postgres -d postgres -c "CREATE ROLE \"sisaudcon10100306@0320171.0.29\" LOGIN PASSWORD '10100306@' SUPERUSER CREATEDB CREATEROLE REPLICATION VALID UNTIL 'infinity';"
		psql -h localhost -p $porta -U postgres -d postgres -c "CREATE ROLE \"sisaudconrobo@10100306@\" LOGIN ENCRYPTED PASSWORD '10100306@' SUPERUSER CREATEDB CREATEROLE VALID UNTIL 'infinity';"
		psql -h localhost -p $porta -U postgres -d postgres -c "ALTER ROLE \"sisaudconevagato@1120181.0.32\" RENAME TO \"sisaudconsetetatu@0820211.0.35\";"
		psql -h localhost -p $porta -U postgres -d postgres -c "ALTER ROLE \"sisaudconsetetatu@0820211.0.35\" ENCRYPTED PASSWORD '10100306@';"
		psql -h localhost -p $porta -U postgres -d postgres -c "CREATE ROLE \"sisaudconsetetatubola@1020221.0.36\" LOGIN ENCRYPTED PASSWORD '10100306@' SUPERUSER CREATEDB CREATEROLE    VALID UNTIL 'infinity';"
		psql -h localhost -p $porta -U postgres -d postgres -c "CREATE ROLE \"sisaudcondavigaviao@1020222.0.00\" LOGIN ENCRYPTED PASSWORD '10100306@' SUPERUSER CREATEDB CREATEROLE VALID UNTIL 'infinity';"
		psql -h localhost -p $porta -U postgres -d postgres -c "CREATE ROLE \"sisaudconevagato@1120181.0.32\" LOGIN PASSWORD '10100306@' SUPERUSER CREATEDB CREATEROLE REPLICATION VALID UNTIL 'infinity';"
		sleep $TIME
		clear
                echo "Alterando codificao do banco..."
		echo " "
                psql -h localhost -p $porta -U postgres -d postgres -c "CREATE DATABASE template0b TEMPLATE template0 LC_COLLATE 'C' LC_CTYPE 'C';"
                psql -h localhost -p $porta -U postgres -d postgres -c "UPDATE pg_database SET datistemplate = false WHERE datname = 'template0';"
                psql -h localhost -p $porta -U postgres -d postgres -c "DROP DATABASE template0;"
                psql -h localhost -p $porta -U postgres -d postgres -c "ALTER DATABASE template0b RENAME TO template0;"
                psql -h localhost -p $porta -U postgres -d postgres -c "UPDATE pg_database SET datistemplate = true WHERE datname = 'template0';"
                sleep $TIME
		clear
                echo "Criando as bases SPED e TEMPLATE_SPED ..."
		echo " "
		psql -h localhost -p $porta -U postgres -d postgres -c "CREATE DATABASE sped TEMPLATE template0 OWNER \"sisaudconadaoavestruz@0620181.0.31\" ENCODING 'WIN1252';"
                psql -h localhost -p $porta -U postgres -d postgres -c "CREATE DATABASE template_sped TEMPLATE template0 OWNER \"sisaudconadaoavestruz@0620181.0.31\" ENCODING 'WIN1252';"
		sleep $TIME
		clear
		echo "Atualizando arquivo SPEDAO ..."
                echo " "
		sshpass -p "user_bkp_2022" scp -rp -P 4922 user_bkp@saamauditoria.ddns.com.br:/BKP_DEDICADOS/BKP_SPEDAO/$(date +%d-%m-%y --date="-1 day")/sped.backup /home/SPEDAO/
		clear
		echo "Restaurando arquivo sped ..."
                echo " "
                PGPASSWORD="10100306@" /usr/bin/pg_restore  --host localhost  --port $porta --username "sisaudconsetetatu@0820211.0.35"  --dbname "sped"  --verbose  --jobs=20  "/home/SPEDAO/sped.backup"
		PGPASSWORD="10100306@" /usr/bin/pg_restore  --host localhost  --port $porta --username "sisaudconsetetatu@0820211.0.35"  --dbname "template_sped"  --verbose  --jobs=20  "/home/SPEDAO/sped.backup"                
		sleep $TIME
                clear
		echo "Alterando ID do cliente no banco ..."
                echo " "
		psql -h localhost -p $porta -U postgres -d sped -c "update reg_1102 set num_reg='${cluster:0:6}', num_serie_ecf='$(echo ${cluster:0:6}$(date +%m%Y) | md5sum | cut -d'-' -f1)';"
		echo " "
		sed -i 's/local   all             all                                     trust/local   all             all                                     peer/' /etc/postgresql/$versao/$cluster/pg_hba.conf
                sed -i 's/32            trust/32            md5/' /etc/postgresql/$versao/$cluster/pg_hba.conf
                sed -i 's/128                 trust/128                 md5/' /etc/postgresql/$versao/$cluster/pg_hba.conf
		pg_ctlcluster $versao $cluster restart
		clear
		echo "Inserindo dados do cluster na listagem de portas"
		echo " "
		echo "$versao|$cluster|$porta|SRV$indicadorBKP|BKP_DEDICADO_$indicadorBKP" >> /home/bkp_dedicado/portas.txt
		sleep $TIME
		clear
		echo "Inserindo dados do cliente no banco da LOCAWEB"
		PGPASSWORD="cr10100306@" psql -h saam_clientes.postgresql.dbaas.com.br -p 5432 -U saam_clientes -d saam_clientes -c "INSERT INTO public.identificadors(id, situacao, limite_empresas, data_insercao, porta, ip_servidor_web, obs, ativar_pva_nuvem, obs_pva_nuvem) select b.* from identificadors a right join (select '${cluster:0:6}'::text as id, 1::SMALLINT as situacao, $limite::INTEGER as limite_empresas, now() as data_insercao, '$porta'::text as porta, '$(hostname -I)'::text as ip_servidor_web, '$nomeEmpresa'::text as obs, false, ''::text as obs_pva_nuvem)b on a.id = b.id and a.porta = b.porta and a.ip_servidor_web = b.ip_servidor_web where a.id is null;"
		systemctl restart saam
		clear
		pg_lsclusters
		;;
        3)      clear
		pg_lsclusters 
		echo " "
		echo "Digite o NOME do cluster a ser excluido: "
		read cluster
		echo " "
		echo -e "\e[00;31mVoce deseja realmente excluir o cluster $cluster (SIM) (NAO):\e[00m  "
		read decisao
		versao=$(pg_lsclusters | grep $cluster | awk '{print $1}')
		if [ $decisao == 'SIM' ];
		then
			pg_ctlcluster $versao $cluster stop
			echo " "	
						clear
                        echo "Deletando cluster $cluster ..."
                        sleep $TIME
			pg_dropcluster $versao $cluster
		fi
		clear
		echo "Removendo dados do cluster da listagem de portas"
		echo > /tmp/aux.txt && grep -v "$cluster" /home/bkp_dedicado/portas.txt > /tmp/aux.txt && cat /tmp/aux.txt > /home/bkp_dedicado/portas.txt
		sleep $TIME
		clear
		echo "Removendo dados do cliente no banco da LOCAWEB"
		PGPASSWORD="cr10100306@" psql -h saam_clientes.postgresql.dbaas.com.br -p 5432 -U saam_clientes -d saam_clientes -c "delete from identificadors where id = '${cluster:0:6}' and ip_servidor_web = '$(hostname -I)';"
		sleep $TIME
		systemctl restart saam
		clear
		pg_lsclusters
                ;;
        4)	clear
		pg_lsclusters
		echo " "
                echo "Digite o nome do cluster a ser renomeado: "
                read cluster
                echo " "
                echo "Digite o novo nome do cluster"
                read novoCluster
                versao=$(pg_lsclusters | grep $cluster | awk '{print $1}')
				porta=$(pg_lsclusters | grep $cluster | awk '{print $3}')
		echo " "
				clear
                echo "Renomeando o $cluster para $novoCluster ..."
		echo " " 
		pg_renamecluster $versao $cluster $novoCluster
		clear
		echo "Alterando dados do cliente no banco da LOCAWEB"
		PGPASSWORD="cr10100306@" psql -h saam_clientes.postgresql.dbaas.com.br -p 5432 -U saam_clientes -d saam_clientes -c "update identificadors set id = '${novoCluster:0:6}' where id = '${cluster:0:6}' and ip_servidor_web = '$(hostname -I)';"
		sleep $TIME
		clear
		echo "Alterando dados do cluster na listagem de portas"
		sed -i "s/$versao|$cluster|$porta|SRV$indicadorBKP|BKP_DEDICADO_$indicadorBKP/$versao|$novoCluster|$porta|SRV$indicadorBKP|BKP_DEDICADO_$indicadorBKP/" /home/bkp_dedicado/portas.txt
		sleep $TIME
		clear
		echo "Alterando ID e SERIAL do cliente no banco ..."
                echo " "
		PGPASSWORD="10100306@" psql -h localhost -p $porta -U sisaudconadaoavestruz@0620181.0.31 -d sped -c "update reg_1102 set num_reg='${novoCluster:0:6}', num_serie_ecf='$(echo ${novoCluster:0:6}$(date +%m%Y) | md5sum | cut -d'-' -f1)' where num_reg = '${cluster:0:6}';"
		sleep $TIME
		systemctl restart saam
		clear
                pg_lsclusters
                ;;
        0)
                echo Saindo do sistema...
		sleep $TIME
		clear
                exit 0
                ;;
        *)	clear
                echo -e "\e[00;34mOpcao invalida, tente novamente!\e[00m"
                ;;
esac
done
