#---------------------------
# Cron for Corona  V2.1
#---------------------------

    #-----------------------------------------------
    LOG=`date +"%Y%m%d"`
    LOGFILE="../logs/Cron.dat.${LOG}";
    LDATE=`date +"%Y%m%d %H:%M"`

    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
    export LANG=C

    cd /svc/web_app/CORONA/bin

    # Get Remote Servers Status and Save into RRD.
    #-----------------------------------------------

    ./Corona 2>/dev/null | ./Get_log.pl  >/dev/null

    echo -n "$LDATE : Query $SECONDS  / " >> $LOGFILE;

    # Get RRD data and Generate image

    ./Gen_img.pl  >/dev/null
    echo " GenIMG : $SECONDS " >> $LOGFILE;

