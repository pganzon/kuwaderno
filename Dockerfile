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

# Install Prereqs
RUN apt-get update  && apt-get -y install \
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
  openjdk-8-jdk

# Copy files
COPY entrypoint.sh requirements.txt rpackages.R /
RUN chmod +x entrypoint.sh \
  && pip install -r requirements.txt

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
RUN wget $ZEPPELIN_URL \
  && tar -xvf $ZEPPELIN_VERSION.tgz  -C /opt

RUN rm -rf $ZEPPELIN_VERSION.tgz requirements.txt  rpackages.R  rstudioserver.deb /var/lib/apt/lists/* /tmp/*

ENTRYPOINT ["/entrypoint.sh"]
CMD ["notebook"]
