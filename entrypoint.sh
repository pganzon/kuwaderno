#!/bin/bash

set -e

if [ "$1" = 'notebook' ]; then 
    echo "http_proxy=$http_proxy" | tee -a /etc/R/Renviron.site
    echo "https_proxy=$https_proxy" | tee -a /etc/R/Renviron.site
    /usr/lib/rstudio-server/bin/rserver &
    /opt/zeppelin-0.6.1-bin-all/bin/zeppelin-daemon.sh start &

    source /home/dockerenv/venv/bin/activate
    mkdir -p $NOTEBOOK_HOME
    cd $NOTEBOOK_HOME
    
    export JPASS=`python -c "from notebook.auth import passwd; print passwd('$JUPYTERPASS')"`
    export JPASSCONF="c.NotebookApp.password = u'$JPASS'"
    jupyter notebook --generate-config
    echo "$JPASSCONF" >> ~/.jupyter/jupyter_notebook_config.py
    jupyter notebook --no-browser --port=$NOTEBOOK_PORT --ip=0.0.0.0
else
   exec "$@"
fi
