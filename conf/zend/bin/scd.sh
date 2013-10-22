#!/bin/bash 
NAME="Session Clustering daemon"
if [ -f /app/etc/zce.rc ];then
    . /app/etc/zce.rc
else
    echo "/app/etc/zce.rc doesn't exist!"
    exit 1;
fi
if [ -f $ZCE_PREFIX/bin/shell_functions.rc ];then
    . $ZCE_PREFIX/bin/shell_functions.rc
else
    echo "$ZCE_PREFIX/bin/shell_functions.rc doesn't exist!"
    exit 1;
fi
check_root_privileges
WD_UID=vcap
WD_GID=vcap
. ${ZCE_PREFIX}/bin/shell_functions.rc
WD_INI=${ZCE_PREFIX}/etc/watchdog-sc.ini
WATCHDOG="${ZCE_PREFIX}/bin/watchdog -c $WD_INI"
BINARY=scd



start()
{
    launch
}

stop()
{
    _kill
}
status()
{
    $WATCHDOG -i $BINARY
}
case "$1" in
	start)
		start
		sleep 1
                status
		;;
	stop)
		stop
		rm -f ${ZCE_PREFIX}/tmp/scd.{app,wd}
		;;
	restart)
		stop
		rm -f ${ZCE_PREFIX}/tmp/scd.{app,wd}
		sleep 1
		start
		;;
	status)
                status
		;;
	*)
		usage
esac

exit $?
