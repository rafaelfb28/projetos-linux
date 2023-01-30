#!/bin/bash

dataHoje=$(date +%d-%m-%y);

for base in $(PGPASSWORD="10100306@" psql -h localhost -p 5458 -U sisaudconadaoavestruz@0620181.0.31 -d postgres -c "select a.datname from (select datname from pg_database where datname ilike '%sped_%' and SUBSTRING(datname, 6, 4)::numeric BETWEEN 1::numeric and 400::numeric union select datname from pg_database where datname in ('sped','template_sped'))a order by case when a.datname not in('sped','template_sped') then SUBSTRING(datname, 6, 4)::numeric end" | grep -v datname | grep -v - | grep -v row)
do 
	PGPASSWORD="10100306@" /usr/lib/postgresql/10/bin/pg_dump --host localhost --port 5458 --username "sisaudconadaoavestruz@0620181.0.31"  --format custom --blobs --file "/mnt/STORAGE/SRV3/$dataHoje/5458/$base.backup" "$base" &>> /dev/null;
done
