FROM ubuntu:16.04
MAINTAINER Paul Ganzon <paul.ganzon@gmail.com>

LABEL "name"="Kuwaderno"

USER root

# NB user
ENV NB_USER admin 
ENV NB_USER_PASS 14mR00t!

# PORTS
ENV PORT0 8787
ENV PORT1 7777
ENV PORT2 8888


# HADOOP
ENV HADOOP_URL http://apache.mirror.serversaustralia.com.au/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# SPARK 
ENV SPARK_VERSION spark-2.1.0-bin-hadoop2.7
ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so
ENV SPARK_URL http://d3kbcqa49mib13.cloudfront.net/$SPARK_VERSION.tgz
ENV SPARK_HOME /opt/$SPARK_VERSION
ENV PYTHONPATH /opt/$SPARK_VERSION/python:/opt/$SPARK_VERSION/python/lib/py4j-0.10.4-src.zip:$PYTHONPATH

# JUPYTER
ENV NOTEBOOK_HOME /home/$NB_USER

# ZEPPELIN
ENV ZEPPELIN_VERSION zeppelin-0.7.1-bin-all
ENV ZEPPELIN_URL http://apache.mirror.serversaustralia.com.au/zeppelin/zeppelin-0.7.1/$ZEPPELIN_VERSION.tgz
ENV ZEPPELIN_NOTEBOOK_DIR /root
ENV ZEPPELIN_HOME /opt/$ZEPPELIN_VERSION

# R
ENV RSTUDIO_URL https://download2.rstudio.org/rstudio-server-1.0.143-amd64.deb



# Install
RUN apt-get update  && \
    apt-get -y install apt-transport-https \
    software-properties-common && \
    apt-add-repository ppa:ansible/ansible

RUN echo "deb https://cran.rstudio.com/bin/linux/ubuntu xenial/" | tee -a  /etc/apt/sources.list
RUN gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9
RUN gpg -a --export E084DAB9 | apt-key add -

RUN  apt-get update && apt-get -y install python \
    ansible \
    wget \
    gcc-4.9 \
    gdebi-core \
    r-base \
    build-essential \
    python-dev \
    python-pip \
    git \
    libxml2-dev \
    libcurl4-openssl-dev \
    libnlopt-dev \
    libgsl0-dev \
    libssl-dev \
    libxt-dev \
    libgdal-dev \
    libproj-dev \
    pandoc \
    pandoc-citeproc \
    libssh2-1-dev \
    libgmp-dev



# Copy files
COPY venv.sh entrypoint.sh hosts ansible.cfg build_mesos.yml requirements.txt  /
RUN chmod +x entrypoint.sh venv.sh

RUN ansible-playbook build_mesos.yml

RUN pip install virtualenv
RUN /venv.sh

# Install java
RUN R CMD javareconf
RUN apt-get -y install r-cran-rjava

COPY rpackages.R /
RUN Rscript rpackages.R

# Install RStudio
RUN wget $RSTUDIO_URL -O rstudioserver.deb
RUN gdebi -n rstudioserver.deb


RUN wget $HADOOP_URL
RUN wget $SPARK_URL
RUN wget $ZEPPELIN_URL
RUN tar -xvf hadoop-2.7.2.tar.gz  -C /opt
RUN tar -xvf $SPARK_VERSION.tgz  -C /opt
RUN tar -xvf $ZEPPELIN_VERSION.tgz  -C /opt

RUN rm -f venv.sh $SPARK_VERSION.tgz hadoop-2.7.2.tar.gz  $ZEPPELIN_VERSION.tgz ansible.cfg  build_mesos.yml  hosts  requirements.txt  rpackages.R  rstudioserver.deb

ENTRYPOINT ["/entrypoint.sh"]
CMD ["notebook"]
