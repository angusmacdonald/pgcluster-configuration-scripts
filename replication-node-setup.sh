#!/bin/bash
#Used to create the config files needed for the PGCluster replication server:

echo "NOTE: ensure that all config parameters have been set in config.cfg"

source config.cfg

#pg_hba.conf:
echo "local all all trust" > $HBA_CONFIG_FILE

for i in "${IP_ADDRESSES[@]}"
do
    echo "host all all $i trust" >> $HBA_CONFIG_FILE  
done

#postgresql.conf:
echo "listen_addresses = '*' " > $POSTGRES_CONFIG_FILE
echo "port = 5432 " >> $POSTGRES_CONFIG_FILE

#pg_replicate.conf:

echo "" > $PG_REPLICATE_CONF

for i in "${DATA_NODES[@]}"
do
	echo "<Cluster_Server_Info>" >> $PG_REPLICATE_CONF
	echo "<Host_Name>$i</Host_Name>" >> $PG_REPLICATE_CONF
	echo "<Port>$DATA_NODE_PORT</Port>" >> $PG_REPLICATE_CONF
	echo "<Recovery_Port>7001</Recovery_Port>" >> $PG_REPLICATE_CONF
	echo "</Cluster_Server_Info>" >> $PG_REPLICATE_CONF
done

echo "<LoadBalance_Server_Info>" >> $PG_REPLICATE_CONF
echo "<Host_Name>$LOAD_BALANCER_NODE</Host_Name>" >> $PG_REPLICATE_CONF
echo "<Recovery_Port>6001</Recovery_Port>" >> $PG_REPLICATE_CONF
echo "</LoadBalance_Server_Info>" >> $PG_REPLICATE_CONF

echo "<Host_Name>$REPLICATION_SERVER_NODE</Host_Name>" >> $PG_REPLICATE_CONF
echo "<Replication_Port>8001</Replication_Port>" >> $PG_REPLICATE_CONF
echo "<Recovery_Port>8101</Recovery_Port>" >> $PG_REPLICATE_CONF
echo "<RLOG_Port>8301</RLOG_Port>" >> $PG_REPLICATE_CONF
echo "<Response_Mode>normal</Response_Mode>" >> $PG_REPLICATE_CONF
echo "<Use_Replication_Log>no</Use_Replication_Log>" >> $PG_REPLICATE_CONF
echo "<Replication_Timeout>1min</Replication_Timeout>" >> $PG_REPLICATE_CONF
echo "<LifeCheck_Timeout>3s</LifeCheck_Timeout>" >> $PG_REPLICATE_CONF
echo "<LifeCheck_Interval>15s</LifeCheck_Interval>" >> $PG_REPLICATE_CONF


echo "<Log_File_Info>" >> $PG_REPLICATE_CONF
echo "<File_Name>$PG_REPLICATE_LOG_FILE</File_Name>" >> $PG_REPLICATE_CONF
echo "<File_Size>1M </File_Size>" >> $PG_REPLICATE_CONF
echo "<Rotate>3</Rotate>" >> $PG_REPLICATE_CONF
echo "</Log_File_Info>" >> $PG_REPLICATE_CONF

chown -R $DATABASE_USER $PG_ROOT
