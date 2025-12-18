WORK_DIR=$(cd "$(dirname "$0")"; pwd)
CONFIG_DIR="$WORK_DIR/.jupyter"
mkdir -p $CONFIG_DIR
podman run -itd \
    --name jupyter-notebook \
    --restart unless-stopped \
    -p 8888:8888 \
    -v $WORK_DIR:/home/jovyan/work \
    -v $CONFIG_DIR:/home/jovyan/.jupyter \
    -w /home/jovyan/work/notebooks \
    -e JUPYTER_ENABLE_LAB=yes \
    docker.io/jupyter/base-notebook 
