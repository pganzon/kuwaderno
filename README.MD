# Kuwaderno

[![Build Status](https://travis-ci.org/pganzon/kuwaderno.svg?branch=master)](https://travis-ci.org/pganzon/kuwaderno)

Docker image containing the following **Data Science** notebooks Jupyter, RStudio and Apache Zeppelin. 

NOTE: If you are looking for the previous version of `Kuwaderno` with Apache Spark and Apache Mesos for deployment on a Mesos cluster please refer to this [link](mesos/README.MD).

## Building the Docker image.
To build the image, clone this repo and run code below.
```
make local
```

If you would not like to build this repository you can use the built image on docker hub.
```
docker run -d \
  -p 8787:8787 \
  -p 7777:7777 \
  -p 80:80 \
paulganzon/kuwaderno
```

After the execution of the code above the following applications should now be accessible.
* Rstudio Server  - http://ip.address:8787/
* Jupyter         - http://ip.address:7777/
* Apache Zeppelin - http://ip.address:80/

Default user and password to access the url are as follows:
* User: admin
* Password: 14mR00t!

You can change both of the user name and password by using the environment variables NB_USER and NB_USER_PASS. For example, if you want the user to be *user1* and *password1* then run the following:
```
docker run  -d \
  -e NB_USER=user1 \
  -e NB_USER_PASS=password1 \
  -p 8787:8787 \
  -p 7777:7777 \
  -p 80:80 \
paulganzon/kuwaderno
```

### Application Versions

|Application|Version|
| ------------- |-------------|
| Rstudio Server | 1.0.143|
| Jupyter        | 4.3.0|
| Apache Zeppelin| 0.7.3|

### R Packages Installed
1. data.table
1. devtools
1. dplyr
1. ggplot2
1. httr
1. knitr
1. lubridate
1. markdown
1. reshape2
1. RJDBC
1. rmarkdown
1. shiny
1. stringr

### Python Packages Installed
1. ipython
1. jupyter
1. matplotlib
1. pandas
1. sklearn
