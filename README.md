# Hadoop 3 Docker build file

Referenced from [bbonnin/docker-hadoop-3](https://www.google.com/search?q=hadoop+3+docker+github&rlz=1C1GCEA_enSG887SG887&ei=IaCGYPD_JJWe9QPO76mYBQ&oq=hadoop+3+docker+github&gs_lcp=Cgdnd3Mtd2l6EAM6BwgAEEcQsAM6BwgAELADEEM6AggAOgQIABBDOgYIABAWEB46CAghEBYQHRAeUK8WWOAsYM4taANwAngAgAFaiAH2CJIBAjIxmAEAoAEBqgEHZ3dzLXdpesgBCsABAQ&sclient=gws-wiz&ved=0ahUKEwiwlKPH45vwAhUVT30KHc53ClMQ4dUDCA4&uact=5)

## Building for hadoop 3

Please, read the content of Dockerfile, because it may be possible that you have to update it. See the comments about the tgz of hadoop3.

After starting the container, you can access the web UI:

+ HDFS: http://localhost:9870
+ RM: http://localhost:8088

## How-to

+ Build the image

```bash
$ sudo docker build -t hadoop3 . 
```
+ Run the container

```bash
$ sudo docker run --hostname=hadoop3 \
  -p 8088:8088 -p 9870:9870 -p 9864:9864 \
  -p 19888:19888 -p 8042:8042 -p 8888:8888 \
  --name hadoop3 -d hadoop3
```

+ Access the container

```bash
$ sudo docker exec -it hadoop3 bash
```

+ Test a job

```bash
yarn jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.0.jar pi 10 100
```

+ Clean

```bash
sudo docker stop hadoop3 
sudo docker rm hadoop3
```