# Kuwaderno
Docker image containing the following **Data Science** notebooks Jupyter, RStudio and Apache Zeppelin. This also contains  Apache Spark and Apache Mesos for Spark job submission locally or on a Mesos cluster.

## Building the Docker image.
To build the image, clone this repo and run code below.
```
docker build -t kuwaderno .
```

If you would not like to build this repository you can use the built image on docker hub.
```
docker run  -d -p 8787:8787 -p 7777:7777  -p 8888:8888 paulganzon/kuwaderno
```


## Using the Docker image
Using bridge networking
```
docker run  -d -p 8787:8787 -p 7777:7777  -p 8888:8888 kuwaderno
```

or using host networking


```
docker run  -d --net=host kuwaderno
```

If you wish to change the port on host networking you can run the following instead.
```
docker run -d -e PORT0=<rstudio.server.port> -e PORT1=<jupyter.port> -e PORT2=<zeppelin.port> --net=host kuwaderno
```

After the execution of the code above the following applications should now be accessible.
* Rstudio Server  - http://ip.address:8787/
* Jupyter         - http://ip.address:7777/
* Apache Zeppelin - http://ip.address:8888/

Default user and password to access the url are as follows:
* User: admin
* Password: 14mR00t!

You can change both of the user name and password by using the environment variables NB_USER and NB_USER_PASS. For example, if you want the user to be *user1* and *password1* then run the following:
```
docker run  -d -e NB_USER=user1 -e NB_USER_PASS=password1 --net=host kuwaderno
```




### Application Versions

|Application|Version|
| ------------- |-------------|
| Rstudio Server | 1.0.143|
| Jupyter        | 4.3.0|
| Apache Zeppelin| 0.7.1|
| Apache Spark   | 2.1.0|
| Apache Mesos   | 1.1.0-2.0.107|

### R Packages Installed
1. dplyr
1. ggplot2
1. plotly
1. stringr
1. lubridate
1. reshape2
1. gmodels
1. httr
1. BoomSpikeSlab
1. dygraphs
1. shiny
1. RJDBC
1. markdown
1. knitr
1. rmarkdown
1. devtools
1. data.table
1. CausalImpact

### Python Packages Installed
1. ipython
1. jupyter
1. pandas
1. requests
1. plotly
1. cufflinks
1. scipy
