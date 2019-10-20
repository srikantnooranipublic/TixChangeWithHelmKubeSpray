SELENIUM_PODS=`kubectl get pods -n selenium|grep -v NAME |grep -v grep |awk '{print $1}'`

for SELENIUM_POD in $SELENIUM_PODS; 
do
	kubectl delete pod $SELENIUM_POD -n selenium	
done
