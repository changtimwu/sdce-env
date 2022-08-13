#!/bin/sh
mapport=8910
echo "your local ($mapport) <-(ssh tunnel)-> this host ($mapport) <--> this container 8888" 
#echo "in ssh/config ---   LocalForward $mapport localhost:$mapport"
echo "please open http://localhost:$mapport/"
port_opts="-p $mapport:8888"
nbdir=`realpath ./workbooks`
export CDIR_DATASETS="/root/datasets"
export CDIR_WMD="/root/waymo-open-dataset-coderepo"
export CDIR_WORKBOOKS="/tf/workbooks"
env_opts="-e CDIR_DATASETS -e CDIR_WMD -e CDIR_WORKBOOKS" 
vol_opt1="-v ${nbdir}:$CDIR_WORKBOOKS"
vol_opt2="-v $(realpath ../waymo-open-dataset-coderepo):$CDIR_WMD"
vol_opt3="-v $(realpath ../datasets):$CDIR_DATASETS"


vol_opts="$vol_opt1 $vol_opt2 $vol_opt3"
#cam_opts=" --device=/dev/video0"
#gpu_opts="--gpus all"

docker run $gpu_opts -it --rm $asroot_opts $env_opts $port_opts $vol_opts $cam_opts  sdce_labs:latest $1

