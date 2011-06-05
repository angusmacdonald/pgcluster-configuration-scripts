#!/bin/bash
#Used to create the config files needed for PGCluster data nodes:

echo "NOTE: ensure that all config parameters have been set in config.cfg"

DATA_NODE_NAME=`hostname`

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

## Cluster.conf setup:
echo "<Replicate_Server_Info>" > $CLUSTER_CONFIG_FILE
echo "<Host_Name>$REPLICATION_SERVER_NODE</Host_Name>" >> $CLUSTER_CONFIG_FILE
echo "<Port>8001</Port>" >> $CLUSTER_CONFIG_FILE
echo "<Recovery_Port>8101</Recovery_Port>" >> $CLUSTER_CONFIG_FILE
echo "</Replicate_Server_Info>" >> $CLUSTER_CONFIG_FILE

echo "<Host_Name>$DATA_NODE_NAME</Host_Name>" >> $CLUSTER_CONFIG_FILE
echo "<Recovery_Port>7001</Recovery_Port>" >> $CLUSTER_CONFIG_FILE
echo "<Rsync_Path>/usr/bin/rsync</Rsync_Path>" >> $CLUSTER_CONFIG_FILE
echo "<Rsync_Option>ssh -1</Rsync_Option>" >> $CLUSTER_CONFIG_FILE
echo "<Rsync_Compress>yes</Rsync_Compress>" >> $CLUSTER_CONFIG_FILE
echo "<Pg_Dump_Path>/usr/local/pgsql/bin/pg_dump</Pg_Dump_Path>" >> $CLUSTER_CONFIG_FILE
echo "<When_Stand_Alone>read_only</When_Stand_Alone>" >> $CLUSTER_CONFIG_FILE
echo "<Replication_Timeout>1min</Replication_Timeout>" >> $CLUSTER_CONFIG_FILE
echo "<LifeCheck_Timeout>3s</LifeCheck_Timeout>" >> $CLUSTER_CONFIG_FILE
echo "<LifeCheck_Interval>11s</LifeCheck_Interval>" >> $CLUSTER_CONFIG_FILE

chown -R $DATABASE_USER $PG_ROOT
