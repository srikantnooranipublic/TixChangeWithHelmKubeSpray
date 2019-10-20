#produces a mapping of namespace, pod, container, if java process exist and if wily is there or not
# useful to debug if autoattach is working or not
#
# author srikant.noorani@broadcom.com
# to run  ./getJavaAutoAttachMapping.sh &> CA_UMA_output.log


mkdir CA_APM 2> /dev/null
cd CA_APM

OUTPUT_FILE=javaAutoAttachMappingLong.csv
ERR_FILE=javaAutoAttachMapping.err.log

echo > $ERR_FILE

echo "***, Namespace, Node,  POD, container, is_Java, is_wily, is_attach, Java process detail" > $OUTPUT_FILE

NAMESPACES=`kubectl get namespaces|grep -v ingress|grep -v default|grep -v caapm|grep -v kube|awk '{print $1}'|grep -v NAME`

for NAMESPACE in $NAMESPACES; 
do
	echo "*** checking the namespace $NAMESPACE"

	PODS=`kubectl get pods -n $NAMESPACE -o wide |grep -v NAME|awk '{print $1}'`

	for POD in $PODS; 
	do

		echo "*** checking the pod $POD"
		NODE=`kubectl get pod $POD  -n $NAMESPACE -o wide |grep -v NAME|awk '{print $7}'`

		CONTAINERS=`kubectl describe pod $POD -n $NAMESPACE |grep -B 1 "Container ID:"|grep -v "Container ID:"|grep -v "\-\-"|sed "s/://g"`
	
        	for CONTAINER in $CONTAINERS; 
		do
			echo "***checking the container $CONTAINER"
	
      			IS_JAVA=`kubectl exec $POD -n $NAMESPACE -c $CONTAINER -- ps -ef |grep java|grep -v grep` #2>> $ERR_FILE
			
			if [ X"$IS_JAVA" != "X" ]; then
				IS_WILY=`kubectl exec $POD -n $NAMESPACE -c $CONTAINER  -- ls -d /opt/wily/ |grep "No such file"` #2>> $ERR_FILE
				ATTACH_COUNT=`kubectl exec $POD -n $NAMESPACE -c $CONTAINER  -- ls -l /opt/wily/logs/|wc -l` #2>> $ERR_FILE

				if [ $ATTACH_COUNT -eq 0 ]; then
					IS_ATTACH="Attach_no"	
				else
					IS_ATTACH="Attach_yes"
				fi
				
				if [ X"$IS_WILY" == "X" ]; then
					echo "***, $NAMESPACE, $NODE, $POD, $CONTAINER, Java_yes, Wily_yes, $IS_ATTACH, $IS_JAVA" >> $OUTPUT_FILE
				else
					echo "***, $NAMESPACE, $NODE, $POD, $CONTAINER, Java_yes, Wily_no, $IS_ATTACH, $IS_JAVA" >> $OUTPUT_FILE
	
				fi
	
			else
				echo "***, $NAMESPACE, $NODE, $POD, $CONTAINER, Java_no, wily_undefined, Attach_undefined" >> $OUTPUT_FILE
			fi
		done
	done
done


awk -F, '{print $1 $2 $3 $4 $5 $6 $7}' $OUTPUT_FILE |grep "^*" > javaAutoAttachMappingShort.csv

cd ..

tar cvf javaAutoAttachMapping.tar CA_APM CA_UMA_output.log
rm CA_UMA_output.log

sleep 2
echo "****share javaAutoAttachMapping.tar with CA/BC"
