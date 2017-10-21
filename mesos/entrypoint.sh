#!/bin/bash

set -e

useradd -m $NB_USER -G sudo -s /bin/bash && echo "$NB_USER:$NB_USER_PASS" | chpasswd

if [ "$1" = 'notebook' ]; then 
    echo "www-port=$PORT0" >> /etc/rstudio/rserver.conf
    echo "server-app-armor-enabled=0" >> /etc/rstudio/rserver.conf 
    /usr/lib/rstudio-server/bin/rserver &

    echo -e "#"'!'"/bin/bash\nset -e\nexport ZEPPELIN_PORT=$PORT2" > $ZEPPELIN_HOME/conf/zeppelin-env.sh
    $ZEPPELIN_HOME/bin/zeppelin-daemon.sh start &

    source /venv/bin/activate
    mkdir -p $NOTEBOOK_HOME
    cd $NOTEBOOK_HOME
    
    export JPASS=`python -c "from notebook.auth import passwd; print passwd('$NB_USER_PASS')"`
    export JPASSCONF="c.NotebookApp.password = u'$JPASS'"
    jupyter notebook --allow-root --generate-config
    echo "$JPASSCONF" >> ~/.jupyter/jupyter_notebook_config.py
    jupyter notebook --no-browser --port=$PORT1 --ip=0.0.0.0 --allow-root
else
   exec "$@"
fi
