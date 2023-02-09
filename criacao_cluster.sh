#!/bin/bash
#Automacao criacao de cluster
TIME=3
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
	2)      echo "Digite o nome do cluster EX: '000111_saam': "
                read cluster
		echo " "
		echo "Digite a versao do banco: "
		read versao
		echo " "
                pg_createcluster $versao $cluster
		porta=$(pg_lsclusters | grep down | awk '{print $3}')
                sed -i 's/local   all             all                                     peer/local   all             all                                     trust/' /etc/postgresql/$versao/$cluster/pg_hba.conf
		sed -i 's/32            md5/32            trust/' /etc/postgresql/$versao/$cluster/pg_hba.conf
		sed -i 's/128                 md5/128                 trust/' /etc/postgresql/$versao/$cluster/pg_hba.conf
		pg_ctlcluster $versao $cluster start
		echo " "
		clear
		echo "Alterando a senha do usuario postgres ..."
		echo " "
                sleep $TIME
		psql -h localhost -p $porta -U postgres -d postgres -c "ALTER USER postgres WITH PASSWORD '10100306@';"
		echo " "
		clear
		echo "Informe a alocacao de memoria para continuar:
(versao do banco padrao 10, para outras versoes escolha Outros,ex: 10, 14, Outros)"
		echo " "
		echo "Memoria escolhida: "
		read memoria
		if [ $memoria == '10' ];
                       then     
				echo " "
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
                                echo " "
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
				
		else [ $memoria == 'Outros' ];
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
                		echo " "
				clear
				 

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
		echo " "
		clear
                echo "Alterando codificao do banco..."
		echo " "
                psql -h localhost -p $porta -U postgres -d postgres -c "CREATE DATABASE template0b TEMPLATE template0 LC_COLLATE 'C' LC_CTYPE 'C';"
                psql -h localhost -p $porta -U postgres -d postgres -c "UPDATE pg_database SET datistemplate = false WHERE datname = 'template0';"
                psql -h localhost -p $porta -U postgres -d postgres -c "DROP DATABASE template0;"
                psql -h localhost -p $porta -U postgres -d postgres -c "ALTER DATABASE template0b RENAME TO template0;"
                psql -h localhost -p $porta -U postgres -d postgres -c "UPDATE pg_database SET datistemplate = true WHERE datname = 'template0';"
                sleep $TIME
		echo " "
		clear
                echo "Criando base ..."
		echo " "
		psql -h localhost -p $porta -U postgres -d postgres -c "CREATE DATABASE sped TEMPLATE template0 OWNER \"sisaudconadaoavestruz@0620181.0.31\" ENCODING 'WIN1252';"
                psql -h localhost -p $porta -U postgres -d postgres -c "CREATE DATABASE template_sped TEMPLATE template0 OWNER \"sisaudconadaoavestruz@0620181.0.31\" ENCODING 'WIN1252';"
		sleep $TIME
		echo "Atualizando arquivo SPEDAO ..."
                echo " "
		sshpass -p "user_bkp_2022" scp -rp -P 4922 user_bkp@saamauditoria.ddns.com.br:/BKP_DEDICADOS/BKP_SPEDAO/$(date +%d-%m-%y --date="-1 day")/sped.backup /home/SPEDAO/
                sleep $TIME
		echo "Restaurando arquivo sped ..."
                echo " "
                PGPASSWORD="10100306@" /usr/bin/pg_restore  --host localhost  --port $porta --username "sisaudconsetetatu@0820211.0.35"  --dbname "sped"  --verbose  --jobs=20  "/home/SPEDAO/sped.backup"
		PGPASSWORD="10100306@" /usr/bin/pg_restore  --host localhost  --port $porta --username "sisaudconsetetatu@0820211.0.35"  --dbname "template_sped"  --verbose  --jobs=20  "/home/SPEDAO/sped.backup"                
		sleep $TIME
		echo " "
                clear
		echo "Alterando ID do cliente no banco ..."
                echo " "
		echo "Digite o numero do serial:"
		read serial
                psql -h localhost -p $porta -U postgres -d sped -c "update reg_1102 set num_reg='${cluster:0:6}', num_serie_ecf='$serial';"
		sed -i 's/local   all             all                                     trust/local   all             all                                     peer/' /etc/postgresql/$versao/$cluster/pg_hba.conf
                sed -i 's/32            trust/32            md5/' /etc/postgresql/$versao/$cluster/pg_hba.conf
                sed -i 's/128                 trust/128                 md5/' /etc/postgresql/$versao/$cluster/pg_hba.conf
		pg_ctlcluster $versao $cluster restart
                echo "Informar o numero do servidor EX(1, 2, 3 ou 4): "
		read servidor
		echo "Inserindo dados do cluster na listagem de portas"
		sed -i "\$a$versao|$cluster|$porta|SRV$servidor|BKP_DEDICADO_$servidor" /home/bkp_dedicado/portas.txt
		sleep $TIME
		echo "Informe o nome da empresa: "
		read nomeEmpresa
		echo "Informe o limite de empresas: "
		read limite
		echo "Inserindo dados do cliente no banco da LOCAWEB"
		PGPASSWORD="cr10100306@" psql -h saam_clientes.postgresql.dbaas.com.br -p 5432 -U saam_clientes -d saam_clientes -c "INSERT INTO public.identificadors(id, situacao, limite_empresas, data_insercao, porta, ip_servidor_web, obs, ativar_pva_nuvem, obs_pva_nuvem) VALUES ('${cluster:0:6}', 1, $limite, now(), '$porta', '192.168.0.1', '$nomeEmpresa', false, '');"
		clear
		pg_lsclusters
		;;
        3)      clear
		pg_lsclusters 
		echo " "
		echo "Digite o nome do cluster a ser excluido: "
		read cluster
		echo " "
		echo -e "\e[00;31mVoce deseja realmente excluir o cluster $cluster (SIM) (NAO):\e[00m  "
		read decisao
		versao=$(pg_lsclusters | grep $cluster | awk '{print $1}')
		if [ $decisao == 'SIM' ];
		then
			pg_ctlcluster $versao $cluster stop
			echo " "
                        echo "Deletando cluster $cluster ..."
                        sleep $TIME
			pg_dropcluster $versao $cluster
			clear
			pg_lsclusters
		fi
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
		echo " "
                echo "Renomeando o $cluster para $novoCluster ..."
		echo " "
                sleep $TIME
		pg_renamecluster $versao $cluster $novoCluster
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
