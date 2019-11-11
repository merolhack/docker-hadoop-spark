# docker-hadoop-spark-python

> Docker image for running Hadoop + Spark + Python

Based on the following articles:

* [A Journey Into Big Data with Apache Spark: Part 1](https://towardsdatascience.com/a-journey-into-big-data-with-apache-spark-part-1-5dfcc2bccdd2)

And the following repository:

* [Spark Cluster](https://github.com/QwertyJack/spark-cluster)

## Steps to create a Spark cluster

Create a network:

```bash
docker network create spark_network
```

Build the image with your own tag:

```bash
docker build -t merolhack/spark:latest .
```

Enter into the bash shell:

```bash
docker run --rm -it --name spark-master --hostname spark-master \
    -p 7077:7077 -p 8080:8080 --network spark_network \
    merolhack/spark:latest /bin/sh
```

Inside the shell, run the following command to start a _Spark Master_:

```bash
/spark/bin/spark-class org.apache.spark.deploy.master.Master --ip `hostname` --port 7077 --webui-port 8080
```

Run a worker:

```bash
docker run --rm -it --name spark-worker --hostname spark-worker \
    --network spark_network \
    merolhack/spark:latest /bin/sh
```

Start the _Spark Worker_:

```bash
/spark/bin/spark-class org.apache.spark.deploy.worker.Worker \
    --webui-port 8080 spark://spark-master:7077
```

Start another _Spark Worker_:

```bash
docker run --rm -it --network spark_network \
    merolhack/spark:latest /bin/sh
```

Run the example _SparkPi_ script 1000 times:

```bash
/spark/bin/spark-submit --master spark://spark-master:7077 --class \
    org.apache.spark.examples.SparkPi \
    /spark/examples/jars/spark-examples_2.11-2.4.4.jar 1000
```

## Run with docker-compose

Run the containers in detached mode:

```bash
docker-compose up -d
```

See logs:

```bash
docker-compose logs -f
```

Scale the cluster up to 3 workers:

```bash
docker-compose up --scale spark-worker=3
```

Excecute the _SparkPi_ sample script 1000 times:

```bash
docker exec spark-master bin/spark-submit \
    --master spark://spark-master:7077 \
    --class org.apache.spark.examples.SparkPi examples/jars/spark-examples_2.11-2.4.4.jar 1000
```
