if [ X"$1" == "X" ]; then
	echo "pls provide a valid number as param between 1 and 3 "
	exit
fi

SCALE=1

if [ $1 -gt 3 ]; then
  echo "scaling to 3 Max"
  SCALE=3
elif [ $1 -lt 1 ]; then
  echo "scaling to 1 Min"
  SCALE=1
else
  echo "scaling to $1 "
  SCALE=$1
fi

kubectl scale  --replicas=$SCALE deployment/selenium-standalone -n selenium 

sleep 3

kubectl get pods -n selenium
