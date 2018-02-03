# --WIP--

* I am working from time to time on this. Please try it out. May not work in current state ...

# ToDo:

* [ ] add security
* [ ] add connector

# Quickstart

install singularity: http://singularity.lbl.gov

    make bootstrap

    make copy_config

    tbd

## Build the image file on your local machine

Note: if you get `Permission denied` erros. Set the container image to be executable eg. `chmod 655 <image file>`

## spark configs

best is to set spark configs via env variables whenever possible...

### Where to make changes for the spark config.

Use the files in the folder spark_config
after you made your changes copy them to the container
The makefile already has a procedure `make copy_config` for that, but you can also do manually.

Note:
The slurm native way here would have been to put spark and spark root into your user home. But by this moving the container to another cluster would become a tricky task.

Therefore the current solution is to keep the spark home inside the container and to put
all configuration details there during boostrapping of the images. However, if you only want to work on slurm. The above solution is way more dynamic because the container becomes a surrogate for the java runtime.

Where are configs loaded:

{SPARK_HOME}/sbin/spark-config.sh"

{SPARK_HOME}/bin/load-spark-env.sh"

# Local files

# Process handling:

SPARK_NO_DAEMONIZE=1 in sparkroot/conf/spark-env.sh --> run in foreground


#spark on slurm

Run only one spark worker per node!!! Spark utilises cpus itself.

Note: the image given in the `run_spark.sh` should be available on all nodes!

Start spark with: `sbatch -p partition -o spark.out run_on_slurm/run_spark.sh spark_2.1.1_Hadoop_2.7.img`
