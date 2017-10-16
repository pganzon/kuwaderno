FROM ubuntu:16.04
MAINTAINER Paul Ganzon <paul.ganzon@gmail.com>

LABEL "name"="Kuwaderno"

USER root

# NB user
ENV NB_USER=admin \
  NB_USER_PASS=14mR00t!

# PORTS
ENV PORT0=8787 \
  PORT1=7777 \
  PORT2=8888

# VERSIONS
ENV ZEPPELIN_VERSION=zeppelin-0.7.1-bin-all \
  SPARK_VERSION=spark-2.1.0-bin-hadoop2.7

# URLS
ENV SPARK_URL=http://d3kbcqa49mib13.cloudfront.net/$SPARK_VERSION.tgz \
  ZEPPELIN_URL=http://apache.mirror.serversaustralia.com.au/zeppelin/zeppelin-0.7.1/$ZEPPELIN_VERSION.tgz \
  RSTUDIO_URL=https://download2.rstudio.org/rstudio-server-1.0.143-amd64.deb

# Java
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# SPARK 
ENV SPARK_HOME=/opt/$SPARK_VERSION \
  MESOS_NATIVE_JAVA_LIBRARY=/usr/local/lib/libmesos.so \
  PYTHONPATH=/opt/$SPARK_VERSION/python:/opt/$SPARK_VERSION/python/lib/py4j-0.10.4-src.zip:$PYTHONPATH

# JUPYTER
ENV NOTEBOOK_HOME=/home/$NB_USER

# ZEPPELIN
ENV ZEPPELIN_NOTEBOOK_DIR=/root \
  ZEPPELIN_HOME=/opt/$ZEPPELIN_VERSION

# R

# Install Prereqs
RUN apt-get update  && apt-get -y install \
  ansible \
  apt-transport-https \
  build-essential \
  gcc-4.9 \
  gdebi-core \
  git \
  libcurl4-openssl-dev \
  libgdal-dev \
  libgmp-dev \
  libgsl0-dev \
  libnlopt-dev \
  libproj-dev \
  libssh2-1-dev \
  libssl-dev \
  libxml2-dev \
  libxt-dev \
  pandoc \
  pandoc-citeproc \
  python \
  python-dev \
  python-pip \
  software-properties-common \
  sudo \
  wget \
  && apt-add-repository ppa:ansible/ansible

# Copy files
COPY venv.sh entrypoint.sh hosts ansible.cfg build_mesos.yml requirements.txt rpackages.R /
RUN chmod +x entrypoint.sh venv.sh

# Install Mesos, oracle java and python packages
RUN ansible-playbook build_mesos.yml \
  && pip install virtualenv \
  && /venv.sh

# Install R
RUN echo "deb https://cran.rstudio.com/bin/linux/ubuntu xenial/" | tee -a  /etc/apt/sources.list \
  && gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9 \
  && gpg -a --export E084DAB9 | apt-key add - \
  && apt-get update && apt-get -y install \
    r-base \
    r-base-dev \
    r-cran-rjava \
  ## Configure R
  && R CMD javareconf \
  && Rscript rpackages.R \
  ## Install RStudio
  && wget $RSTUDIO_URL -O rstudioserver.deb \
  && gdebi -n rstudioserver.deb

# Install zeppelin
RUN wget $SPARK_URL \
  && wget $ZEPPELIN_URL \
  && tar -xvf $SPARK_VERSION.tgz  -C /opt \
  && tar -xvf $ZEPPELIN_VERSION.tgz  -C /opt

RUN rm -rf venv.sh $SPARK_VERSION.tgz $ZEPPELIN_VERSION.tgz ansible.cfg  build_mesos.yml  hosts  requirements.txt  rpackages.R  rstudioserver.deb /var/lib/apt/lists/* /tmp/*

ENTRYPOINT ["/entrypoint.sh"]
CMD ["notebook"]
