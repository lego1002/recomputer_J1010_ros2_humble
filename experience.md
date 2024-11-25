# 在 Jetson Nano 上使用 Docker 安裝 ROS 2 Humble 的完整歷程

## 前言

我的第一個困難點是 **ReComputer J1010** 並沒有 SD 卡槽，也不能使用 M.2 SSD。安裝完 JetPack 後，系統根本沒有多餘空間讓我進行其他操作。後來，我參考了 [這篇文章](https://ithelp.ithome.com.tw/articles/10295135?sc=rss.iron) 的方法，成功讓 USB 成為 J1010 的一部分儲存空間。

由於我想學習 **ROS 2**，我開始尋找適合 **Ubuntu 18.04** 的 ROS 2 版本，結果發現幾乎沒有廣為人知或通用的版本，更不用說 LTS 版本了。於是，我決定在 J1010 上安裝 **Ubuntu 20.04** 並嘗試 ROS 2 Humble，但意識到可能無法安裝 JetPack，這個方案最終被我放棄。

後來，我想到利用 **Docker**。在探索過程中，我發現了專為 Jetson Nano 掛載的 ROS 2 映像檔。雖然有一次偶然成功運行，但由於忙於其他事情，退出容器後我不清楚如何再次運行它，因此這段學習一度擱置。直到 **2024 年 11 月 24 日**，我決定重新開始學習。

---

## 我的嘗試與挫折

在重新學習之前，我找到了一個 [GitHub 項目](https://github.com/Qengineering/Jetson-Nano-Ubuntu-20-image)，並嘗試按照文檔的說明操作，將系統掛載到已格式化的 USB 上，但由於無法開機而失敗。我猜測問題出在之前更改了開機盤設置。再次格式化時，發現 USB 的分區被切成很多塊。於是，我用 Windows 的分區小精靈將它們全部刪除並重新建立了一個簡單分區。雖然可以重新燒錄系統，但依然無法成功啟動。

現在想想，也許用 Linux 格式化會更正確，但每次嘗試失敗都需要花費數小時刷新系統，實在是太耗時了，所以放棄了這種方法。

最終，我根據 [這篇文檔](https://blog.cavedu.com/2024/05/21/amr-ros2-img-dds/) 的指導，雖然它的主機是 Orin Nano 且原生系統是 Ubuntu 20.04，但裡面的 Docker 操作指令對 Jetson Nano 也是適用的。我發現可以直接使用映像檔建立一個容器，並自動掛載所需的環境和資源包，大大簡化了流程。

---

## 安裝 ROS 2 Humble 的步驟

### 1. 拉取 Docker 映像檔
使用以下指令拉取適用於 Jetson Nano 的 ROS 2 Humble 映像檔：
```
sudo docker pull dustynv/ros:humble-desktop-l4t-r32.7.1

sudo docker run --runtime nvidia -it --rm --privileged \
  --network=host \
  --name ros2_container \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $HOME/.Xauthority:/root/.Xauthority \
  -v $HOME/ros_ws:/ros_ws \
  dustynv/ros:humble-desktop-l4t-r32.7.1
```

注意： 目前尚未解決無需使用 sudo 的執行方式。


### 2. 容器啟動後會自動載入 ROS 的環境變數，輸出以下內容：

```
sourcing   /opt/ros/humble/install/setup.bash
ROS_DISTRO humble
ROS_ROOT   /opt/ros/humble
```

### 3. 解決顯示問題
運行 ROS 2 程式時可能會遇到顯示問題（例如無法連接到 DISPLAY）。退出容器後，在本機終端執行以下指令：

```
xhost +local:root
```


然後重新啟動容器：

```
sudo docker run --runtime nvidia -it --rm --privileged --network=host \
  --name ros2_container \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $HOME/.Xauthority:/root/.Xauthority \
  dustynv/ros:humble-desktop-l4t-r32.7.1
  ```

###  4. 確保顯示正常
進入容器後，檢查 DISPLAY 環境變數是否正確設置：
```
echo $DISPLAY
```

---
通過這次折騰，我學到了許多有關 Jetson Nano 和 Docker 的知識。雖然過程中遇到許多問題，但最終通過 dustynv/ros:humble-desktop-l4t-r32.7.1 映像檔成功運行了 ROS 2 Humble。如果你也遇到類似的問題，希望這篇文章能對你有所幫助！

