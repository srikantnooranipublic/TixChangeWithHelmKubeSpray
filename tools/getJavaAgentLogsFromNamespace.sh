#quickly gather java agent log from all the pods in the provided namespace
# author srikant.noorani@broadcom.com

mkdir CA_APM 2> /dev/null
cd CA_APM

NAMESPACE=$1

if [ X"$1" == "X" ]; then
	echo "****pls provide a valid namespace as argument"
        exit
fi

PODS=`kubectl get pods -n $NAMESPACE|grep -v NAME|awk '{print $1}'`

for POD in $PODS; 
do

        echo "****Checking $POD"
	LOG_FILES=`kubectl exec $POD -n $NAMESPACE ls /opt/wily/logs/`

        for LOG_FILE in $LOG_FILES; 
	do
                
        	echo "****Picking up $LOG_FILE from pod $POD"
		kubectl exec $POD -n $NAMESPACE cat /opt/wily/logs/$LOG_FILE > $POD-$LOG_FILE.log
	done
done

cd ..

tar cvf JavaAgent.log.tar CA_APM

echo ""
echo "Here is what I got so far ..."
tar tvf JavaAgent.log.tar

sleep 3
echo ""
echo "****pls send JavaAgent.log.tar to CA/BC***"
