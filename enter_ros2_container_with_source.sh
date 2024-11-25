#!/bin/bash

CONTAINER_NAME="ros2_container"

if docker ps | grep -q $CONTAINER_NAME; then
    echo "正在進入容器 $CONTAINER_NAME 並初始化 ROS2 環境..."
    docker exec -it $CONTAINER_NAME bash -c "if [ -f /opt/ros/humble/install/setup.bash ]; then source /opt/ros/humble/install/setup.bash; echo 'ROS2 環境已初始化'; else echo '找不到 /opt/ros/humble/install/setup.bash，請檢查容器內容'; fi; bash"
else
    echo "容器 $CONTAINER_NAME 尚未運行！請先啟動容器。"
fi

