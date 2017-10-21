FROM ubuntu:16.04
MAINTAINER Paul Ganzon <paul.ganzon@gmail.com>

LABEL "name"="Kuwaderno-lite"

USER root

# NB user
ENV NB_USER=admin \
  NB_USER_PASS=14mR00t!

# PORTS
ENV PORT0=8787 \
  PORT1=7777 \
  PORT2=8888

# VERSIONS
ENV ZEPPELIN_VERSION=zeppelin-0.7.1-bin-all

# URLS
ENV ZEPPELIN_URL=http://archive.apache.org/dist/zeppelin/zeppelin-0.7.1/$ZEPPELIN_VERSION.tgz \
  RSTUDIO_URL=https://download2.rstudio.org/rstudio-server-1.0.143-amd64.deb

# JUPYTER
ENV NOTEBOOK_HOME=/home/$NB_USER

# ZEPPELIN
ENV ZEPPELIN_NOTEBOOK_DIR=/root \
  ZEPPELIN_HOME=/opt/$ZEPPELIN_VERSION

