FROM ubuntu:14.04.4
MAINTAINER Paul Ganzon <paul.ganzon@gmail.com>

LABEL "name"="Kuwaderno"

USER root

# HADOOP
ENV HADOOP_URL http://apache.mirror.serversaustralia.com.au/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# SPARK 
ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so
ENV SPARK_URL http://d3kbcqa49mib13.cloudfront.net/spark-2.0.2-bin-hadoop2.7.tgz
ENV SPARK_HOME /opt/spark-2.0.2-bin-hadoop2.7
ENV PYTHONPATH /opt/spark-2.0.2-bin-hadoop2.7/python:/opt/spark-2.0.2-bin-hadoop2.7/python/lib/py4j-0.10.3-src.zip:$PYTHONPATH

# JUPYTER
ENV NOTEBOOK_HOME /home/jupyter
ENV NOTEBOOK_PORT 7777
ENV JUPYTERPASS notebookuser123

# ZEPPELIN
ENV ZEPPELIN_URL http://apache.osuosl.org/zeppelin/zeppelin-0.6.1/zeppelin-0.6.1-bin-all.tgz
ENV ZEPPELIN_NOTEBOOK_DIR /jupyternb

# R
ENV RSTUDIO_URL https://download2.rstudio.org/rstudio-server-0.99.903-amd64.deb

RUN useradd -m ruser -G sudo -s /bin/bash


RUN apt-get update  && \
    apt-get -y install apt-transport-https

RUN echo "deb https://cran.rstudio.com/bin/linux/ubuntu trusty/" | sudo tee -a  /etc/apt/sources.list
RUN gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9
RUN gpg -a --export E084DAB9 | sudo apt-key add -


RUN apt-get update && \
    apt-get install -y software-properties-common \
    wget \
    gcc-4.9  \
    gdebi-core \
    r-base && \
    apt-add-repository ppa:ansible/ansible
RUN apt-get update && apt-get install -y \
    python \
    ansible \
    build-essential \
    python-pip \
    python-dev \
    sudo \
    git \
    libxml2-dev \
    libcurl4-openssl-dev \
    libnlopt-dev \
    libgsl0-dev \
    libssl-dev \
    libxt-dev \
    libgdal-dev\
    libproj-dev\
    pandoc \
    pandoc-citeproc\
    libssh2-1-dev\
    libgmp-dev



RUN apt-get build-dep -y pam

RUN export CONFIGURE_OPTS=--disable-audit && cd /root && apt-get -b source pam && dpkg -i libpam-doc*.deb libpam-modules*.deb libpam-runtime*.deb libpam0g*.deb

RUN echo "ruser:notebookuser123" | chpasswd

RUN pip install virtualenv

WORKDIR /home/dockerenv
COPY zeppelin-env.sh rpackages.R hosts ansible.cfg build_notebook.yml requirements.txt venv.sh  /home/dockerenv/
RUN ./venv.sh
RUN ansible-playbook build_notebook.yml

# Install java
RUN R CMD javareconf
RUN apt-get -y install r-cran-rjava

RUN Rscript rpackages.R

# Install RStudio
RUN wget $RSTUDIO_URL -O rstudioserver.deb
RUN gdebi -n rstudioserver.deb


RUN wget $HADOOP_URL
RUN wget $SPARK_URL
RUN wget $ZEPPELIN_URL
RUN tar -xvf hadoop-2.7.2.tar.gz  -C /opt
RUN tar -xvf spark-2.0.2-bin-hadoop2.7.tgz  -C /opt
RUN tar -xvf zeppelin-0.6.1-bin-all.tgz  -C /opt
RUN mv zeppelin-env.sh /opt/zeppelin-0.6.1-bin-all/conf/zeppelin-env.sh

RUN rm -f spark-2.0.2-bin-hadoop2.7.tgz hadoop-2.7.2.tar.gz  zeppelin-0.6.1-bin-all.tgz ansible.cfg  build_notebook.yml  hosts  requirements.txt  rpackages.R  rstudioserver.deb


EXPOSE 7777 8787 8888
VOLUME ["/jupyternb","/data"]
COPY entrypoint.sh /home/dockerenv/
RUN chmod -R +x /home/dockerenv
ENTRYPOINT ["/home/dockerenv/entrypoint.sh"]
CMD ["notebook"]
