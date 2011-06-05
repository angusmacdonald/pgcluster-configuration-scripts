#!/bin/bash
#Used to create the config files needed for the PGCluster load balancer:

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

#pglb.conf:


echo "" > $LB_CONFIG_FILE

for i in "${DATA_NODES[@]}"
do
    echo "<Cluster_Server_Info>" >> $LB_CONFIG_FILE
	echo "<Host_Name>$i</Host_Name>" >> $LB_CONFIG_FILE
	echo "<Port>$DATA_NODE_PORT</Port>" >> $LB_CONFIG_FILE
	echo "<Max_Connect>32</Max_Connect>" >> $LB_CONFIG_FILE
	echo "</Cluster_Server_Info>" >> $LB_CONFIG_FILE
done

echo "<Host_Name>$LOAD_BALANCER_NODE</Host_Name>" >> $LB_CONFIG_FILE
echo "<Backend_Socket_Dir>/tmp</Backend_Socket_Dir>" >> $LB_CONFIG_FILE
echo "<Receive_Port>5432</Receive_Port>" >> $LB_CONFIG_FILE
echo "<Recovery_Port>6001</Recovery_Port>" >> $LB_CONFIG_FILE
echo "<Max_Cluster_Num>128</Max_Cluster_Num>" >> $LB_CONFIG_FILE
echo "<Use_Connection_Pooling>	no</Use_Connection_Pooling>" >> $LB_CONFIG_FILE
echo "<LifeCheck_Timeout>3s</LifeCheck_Timeout>" >> $LB_CONFIG_FILE
echo "<LifeCheck_Interval>15s</LifeCheck_Interval>" >> $LB_CONFIG_FILE


echo "<Log_File_Info>" >> $LB_CONFIG_FILE
echo "<File_Name>$LB_LOG_FILE</File_Name>" >> $LB_CONFIG_FILE
echo "<File_Size>1M</File_Size>" >> $LB_CONFIG_FILE
echo "<Rotate>3	</Rotate>" >> $LB_CONFIG_FILE
echo "</Log_File_Info>" >> $LB_CONFIG_FILE

chown -R $DATABASE_USER $PG_ROOT
