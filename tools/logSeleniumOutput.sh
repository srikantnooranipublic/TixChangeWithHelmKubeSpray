SELENIUM_PODS=`kubectl get pods -n selenium |grep -v grep|grep -v NAME|awk '{print $1}'`

for SELENIUM_POD in $SELENIUM_PODS;
do
	echo "****logs are in /opt/ca/TixChangeK8sDemo/logs/$SELENIUM_POD.Selenium.logs"
	kubectl logs  $SELENIUM_POD -n selenium >> /opt/ca/TixChangeK8sDemo/logs/$SELENIUM_POD.Selenium.logs
done

