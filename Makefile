IMAGE_DEF  	?= singularity_spark.def
IMAGE_SIZE 	?= 1500
FLAG		?= spark
APACHE_SPARK_VERSION	?= 2.1.1
HADOOP_VERSION	?= 2.7
VERSION    ?= $(shell git describe --tags --always)
IMAGE_FILE ?= /tmp/$(FLAG)_$(APACHE_SPARK_VERSION)_Hadoop_$(HADOOP_VERSION).img

default: bootstrap

bootstrap:
	sudo rm -f $(IMAGE_FILE)
	sudo singularity create --size $(IMAGE_SIZE) $(IMAGE_FILE)
	sudo singularity bootstrap $(IMAGE_FILE) $(IMAGE_DEF)
	sudo chmod 655 $(IMAGE_FILE)

copy_config:
	sudo singularity copy $(IMAGE_FILE) spark_config_slurm/* /usr/local/spark/conf

run_local:
	bash run_local/run_spark.sh

export:
	sudo singularity export $(IMAGE_FILE) | gzip -9 > $(IMAGE_FILE).tar.gzip
