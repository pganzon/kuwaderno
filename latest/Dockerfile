FROM ubuntu:16.04
MAINTAINER Paul Ganzon <paul.ganzon@gmail.com>

LABEL "name"="Kuwaderno"

USER root

ENV DEBIAN_FRONTEND=noninteractive \
  TINI_VERSION=v0.16.1

# NB user
ENV NB_USER=admin \
  NB_USER_PASS=14mR00t!

# PORTS
ENV PORT0=8787 \
  PORT1=7777 \
  PORT2=8888

# URLS
ENV ZEPPELIN_URL=http://apache.mirror.digitalpacific.com.au/zeppelin/zeppelin-0.7.3/zeppelin-0.7.3-bin-all.tgz \
  RSTUDIO_URL=https://download2.rstudio.org/rstudio-server-1.0.143-amd64.deb

# JUPYTER
ENV NOTEBOOK_HOME=/home/$NB_USER

# ZEPPELIN
ENV ZEPPELIN_NOTEBOOK_DIR=/root \
  ZEPPELIN_HOME=/opt/zeppelin-0.7.3-bin-all \
  ZEPPELIN_HOST=127.0.0.1 \
  ZEPPELIN_PORT=80 \
  ZEPPELIN_SERVER_NAME=localhost

# Add required files
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
COPY files/ /tmp/

# Install Prereqs
RUN apt-get update  && apt-get -y install \
  apache2-utils \
  apt-transport-https \
  build-essential \
  curl \
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
  nginx \
  pandoc \
  pandoc-citeproc \
  python \
  python-dev \
  python-pip \
  software-properties-common \
  sudo \
  wget \
  openjdk-8-jdk \
  && chmod +x /tini

# Install Python packages.
RUN pip install -r /tmp/requirements.txt

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
  && Rscript /tmp/rpackages.R \
  ## Install RStudio
  && wget $RSTUDIO_URL -O rstudioserver.deb \
  && gdebi -n rstudioserver.deb

# Install Zeppelin
RUN curl -fsS -o /tmp/zeppelin.tgz ${ZEPPELIN_URL} \
  && tar -xvf /tmp/zeppelin.tgz -C /opt \
  && echo "#"'!'"/bin/bash\nset -e\nexport ZEPPELIN_PORT=88" > $ZEPPELIN_HOME/conf/zeppelin-env.sh \
  && mv /tmp/templates / \
  && mv /tmp/entrypoint / \
  && mv /tmp/generate_config.py /generate_config.py \
  && rm -rf /tmp/* /var/lib/apt/lists/*

RUN rm -rf $ZEPPELIN_VERSION.tgz requirements.txt  rpackages.R  rstudioserver.deb /var/lib/apt/lists/* /tmp/*

ENTRYPOINT ["/tini", "--"]
CMD ["/entrypoint"]
