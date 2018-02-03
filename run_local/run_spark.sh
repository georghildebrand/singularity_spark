#!/bin/bash
# this file will launch spark local


# set all settng ins the spark-env-local.sh


if [[ -z ${1} ]]; then echo "first argument must be spark singularity image file";else img=$1; fi
if [[ -e ${img} ]]; then echo "using image file $1"; else echo "no image file found $1"; fi
env
echo ""
echo "running master"

host=localhost
port=7077

singularity exec $img start-master.sh --host $host --port $port &

singularity exec $img start-slave.sh -m 2000m -c 2 $host:$port

# on ctrl +c (exit 2) kill all java processes # fixme
trap $(killall java) 2
