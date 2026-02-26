WORK_DIR=$(cd "$(dirname "$0")"; pwd)
CONFIG_DIR="$WORK_DIR/.jupyter"
mkdir -p $CONFIG_DIR
# 先从 dockerpull.org 镜像代理拉取，然后标记为原始名称
podman pull dockerpull.org/jupyter/base-notebook:latest
podman tag dockerpull.org/jupyter/base-notebook:latest docker.io/jupyter/base-notebook:latest

podman run -itd \
    --name jupyter-notebook \
    --restart unless-stopped \
    -p 8888:8888 \
    -v $WORK_DIR:/home/jovyan/work \
    -v $CONFIG_DIR:/home/jovyan/.jupyter \
    -w /home/jovyan/work/notebooks \
    -e JUPYTER_ENABLE_LAB=yes \
    docker.io/jupyter/base-notebook 
