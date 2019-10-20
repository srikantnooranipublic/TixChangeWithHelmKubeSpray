PID=`ps -ef |grep -i sele|grep -v grep|awk '{ print $2}'`
kill -9 $PID
