#!/bin/bash

# 設定變數
IMAGE_NAME="dustynv/ros:humble-desktop-l4t-r32.7.1"
CONTAINER_NAME="ros2_container"
WORKSPACE_DIR="$HOME/ros_ws"

# 配置 X11 訪問
xhost +local:root

# 創建工作目錄（如果尚未存在）
if [ ! -d "$WORKSPACE_DIR" ]; then
    mkdir -p "$WORKSPACE_DIR"
    echo "已創建工作目錄：$WORKSPACE_DIR"
fi

# 下載映像檔（如果尚未存在）
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
    echo "正在下載 Docker 映像檔..."
    docker pull $IMAGE_NAME
fi

# 啟動容器
docker run --runtime nvidia -it --rm --privileged \
    --network=host --name $CONTAINER_NAME -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $HOME/.Xauthority:/root/.Xauthority \
    -v $WORKSPACE_DIR:/ros_ws \
    $IMAGE_NAME

