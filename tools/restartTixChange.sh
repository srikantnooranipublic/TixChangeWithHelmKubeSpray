NAMESPACE=$1

POD_MYSQL=`kubectl get pods -n $NAMESPACE|grep -v NAME|awk '{print $1}'|grep mysql`
POD_WEB=`kubectl get pods -n $NAMESPACE|grep -v NAME|awk '{print $1}'|grep tix-web`
POD_WS=`kubectl get pods -n $NAMESPACE|grep -v NAME|awk '{print $1}'|grep tix-ws`

kubectl delete pod $POD_MYSQL -n $NAMESPACE
sleep 5
kubectl delete pod $POD_WS -n $NAMESPACE
sleep 4
kubectl delete pod $POD_WEB -n $NAMESPACE

