unity_project_template
======================

这是一个Unity项目模板

# 用法

* 编辑`main.sh`

```bash

# Windows build exe
timestamp=`date +%Y%m%d_%H%M%S` \
unity_exe_file=/d/Unity.2019.4.6f1/Editor/Unity.exe \
dot_prj_name_core=dot_prj_core \
dot_prj_name_mods=dot_prj_mod0,dot_prj_mod1 \
dot_prj_name_editor=dot_prj_editor \
unity_log_file= \
u3d_prj_name=u3d_prj \
u3d_build_target=Win64 \
u3d_out_file_name=${u3d_prj_name}_${timestamp}.exe \
u3d_prj_builder_script=com.wolfired.dot_prj_stage1.DefaultWindowsBuilder.Build \
server_endpoint=192.168.180.25:10080 \
server_namespace_prefix= \
server_enable_download=true \
server_enable_upload=true \
step_env_prepare=0 \
step_activate_unity=0 \
step_create_unity_prj=0 \
step_dotnet_refs=0 \
step_install_unity_package=0 \
step_create_dotnet_prj=0 \
step_build_dotnet_prj=0 \
step_create_default_scene=0 \
step_build_unity_prj=0 \
step_upload=0 \
bash ./main.sh

# Windows build apk
timestamp=`date +%Y%m%d_%H%M%S` \
unity_exe_file=/d/Unity.2019.4.6f1/Editor/Unity.exe \
dot_prj_name_core=dot_prj_core \
dot_prj_name_mods=dot_prj_mod0,dot_prj_mod1 \
dot_prj_name_editor=dot_prj_editor \
unity_log_file= \
u3d_prj_name=u3d_prj \
u3d_build_target=Android \
u3d_out_file_name=${u3d_prj_name}_${timestamp}.apk \
u3d_prj_builder_script=com.wolfired.dot_prj_stage1.DefaultAndroidBuilder.Build \
server_endpoint=192.168.180.25:10080 \
server_namespace_prefix= \
server_enable_download=true \
server_enable_upload=true \
step_env_prepare=0 \
step_activate_unity=0 \
step_create_unity_prj=0 \
step_dotnet_refs=0 \
step_install_unity_package=0 \
step_create_dotnet_prj=0 \
step_build_dotnet_prj=0 \
step_create_default_scene=0 \
step_build_unity_prj=0 \
step_upload=0 \
bash ./main.sh

# Windows build testbed
timestamp=`date +%Y%m%d_%H%M%S` \
unity_exe_file=/d/Unity.2019.4.6f1/Editor/Unity.exe \
dot_prj_name_core=dot_prj_core \
dot_prj_name_mods=dot_prj_mod0,dot_prj_mod1 \
dot_prj_name_editor=dot_prj_editor \
unity_log_file= \
u3d_prj_name=u3d_prj \
u3d_build_target=Win64 \
u3d_out_file_name=${u3d_prj_name}_${timestamp}.apk \
u3d_prj_builder_script=com.wolfired.dot_prj_stage1.Testbed.Test \
server_endpoint=192.168.180.25:10080 \
server_namespace_prefix= \
server_enable_download=true \
server_enable_upload=true \
step_env_prepare=0 \
step_activate_unity=0 \
step_create_unity_prj=0 \
step_dotnet_refs=0 \
step_install_unity_package=0 \
step_create_dotnet_prj=0 \
step_build_dotnet_prj=0 \
step_create_default_scene=0 \
step_build_unity_prj=0 \
step_upload=0 \
bash ./main.sh

# Windows
timestamp=`date +%Y%m%d_%H%M%S` \
unity_exe_file=/d/Unity.2021.2.0a21/Editor/Unity.exe \
dot_prj_name_core=dot_prj_core \
dot_prj_name_mods=dot_prj_mod0,dot_prj_mod1 \
dot_prj_name_editor=dot_prj_editor \
unity_log_file= \
u3d_prj_name=u3d_prj \
u3d_build_target=Android \
u3d_out_file_name=${u3d_prj_name}_${timestamp}.apk \
u3d_prj_builder_script=com.wolfired.dot_prj_stage1.DefaultAndroidBuilder.Build \
server_endpoint=192.168.180.25:10080 \
server_namespace_prefix= \
server_enable_download=true \
server_enable_upload=true \
step_env_prepare=0 \
step_activate_unity=0 \
step_create_unity_prj=0 \
step_dotnet_refs=0 \
step_install_unity_package=0 \
step_create_dotnet_prj=0 \
step_build_dotnet_prj=0 \
step_create_default_scene=0 \
step_build_unity_prj=0 \
step_upload=0 \
bash ./main.sh

# Ubuntu
timestamp=`date +%Y%m%d_%H%M%S` \
unity_exe_file=/usr/bin/unity-editor \
dot_prj_name_core=dot_prj_core \
dot_prj_name_mods=dot_prj_mod0,dot_prj_mod1 \
dot_prj_name_editor=dot_prj_editor \
unity_log_file= \
u3d_prj_name=u3d_prj \
u3d_build_target=Android \
u3d_out_file_name=${u3d_prj_name}_${timestamp}.apk \
u3d_prj_builder_script=com.wolfired.dot_prj_stage1.DefaultAndroidBuilder.Build \
server_endpoint=192.168.180.25:10080 \
server_namespace_prefix= \
server_enable_download=true \
server_enable_upload=true \
step_env_prepare=0 \
step_activate_unity=0 \
step_create_unity_prj=0 \
step_dotnet_refs=0 \
step_install_unity_package=0 \
step_create_dotnet_prj=0 \
step_build_dotnet_prj=0 \
step_create_default_scene=0 \
step_build_unity_prj=0 \
step_upload=0 \
bash ./main.sh

dot_prj_name_core=dot_prj_core \
dot_prj_name_mods=dot_prj_mod0,dot_prj_mod1 \
dot_prj_name_editor=dot_prj_editor \
step_clean_clear=1 \
bash ./main.sh

```

# 注意

1. `main.sh` -> `env_prepare()` 要用到代理
2. 如果使用下面的Docker容器配置, `step_env_prepare=0`, `step_activate_unity=0`

# Docker

`docker-compose.yml`

```yml
version: "3"

services:
  unity_2019_4_36f1_android_0_17:
    container_name: unity_2019_4_36f1_android_0_17
    image: unityci/editor:ubuntu-2019.4.36f1-android-0.17
    restart: always
    volumes:
    - /data/workspace_labs/gameci:/gameci
    dns:
    - 192.168.180.25
    networks:
      default:
        ipv4_address: 192.168.1.88
    privileged: true
    command:
    - bash 
    - -c 
    - |
      unity-editor -quit -batchmode -logfile - -manualLicenseFile /gameci/Unity_v2019.x.ulf
      export http_proxy=http://192.168.73.39:1080
      export https_proxy=http://192.168.73.39:1080
      sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list
      sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list
      apt-get update && apt-get -y install language-pack-en software-properties-common apt-transport-https subversion cifs-utils p7zip-full tzdata
      locale-gen en_US.UTF-8
      ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
      wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -
      add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
      apt install -y code
      echo 'export VSCODE_CMD=/usr/bin/code' >> /root/.bashrc
      wget https://dot.net/v1/dotnet-install.sh && chmod 755 ./dotnet-install.sh && ./dotnet-install.sh --channel 5.0 && rm -rf ./dotnet-install.sh
      echo 'export DOTNET_ROOT=/root/.dotnet' >> /root/.bashrc
      echo 'export PATH=$$PATH:$$DOTNET_ROOT:$$DOTNET_ROOT/tools' >> /root/.bashrc
      source /root/.bashrc
      dotnet tool install -g wolfired.u3dot_converter
      unset http_proxy
      unset https_proxy
      wget http://jenkins.builder.com/jnlpJars/agent.jar
      java -jar agent.jar -jnlpUrl http://jenkins.builder.com/computer/xen_unity_2019_4_36f1_android_0_17/slave-agent.jnlp -secret d86f1e1424106821d64f422d4aa8c3d8e1398e52c56b69ea6344a7c508e252ac -workDir /gameci/unity_2019_4_36f1_android_0_17

  unity_2019_4_36f1_windows_mono_0_17_2:
    container_name: unity_2019_4_36f1_windows_mono_0_17_2
    image: unityci/editor:ubuntu-2019.4.36f1-windows-mono-0.17.2
    restart: always
    volumes:
    - /data/workspace_labs/gameci:/gameci
    dns:
    - 192.168.180.25
    networks:
      default:
        ipv4_address: 192.168.1.99
    privileged: true
    command:
    - bash 
    - -c 
    - |
      unity-editor -quit -batchmode -logfile - -manualLicenseFile /gameci/Unity_v2019.x.ulf
      chmod 777 /tmp
      export http_proxy=http://192.168.73.39:1080
      export https_proxy=http://192.168.73.39:1080
      sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list
      sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list
      apt-get update && apt-get -y install language-pack-en software-properties-common apt-transport-https subversion cifs-utils p7zip-full tzdata default-jre
      locale-gen en_US.UTF-8
      ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
      wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -
      add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
      apt install -y code
      echo 'export VSCODE_CMD=/usr/bin/code' >> /root/.bashrc
      wget https://dot.net/v1/dotnet-install.sh && chmod 755 ./dotnet-install.sh && ./dotnet-install.sh --channel 5.0 && rm -rf ./dotnet-install.sh
      echo 'export DOTNET_ROOT=/root/.dotnet' >> /root/.bashrc
      echo 'export PATH=$$PATH:$$DOTNET_ROOT:$$DOTNET_ROOT/tools' >> /root/.bashrc
      source /root/.bashrc
      dotnet tool install -g wolfired.u3dot_converter
      unset http_proxy
      unset https_proxy
      wget http://jenkins.builder.com/jnlpJars/agent.jar
      java -jar agent.jar -jnlpUrl http://jenkins.builder.com/computer/xen_unity_2019_4_36f1_windows_mono_0_17_2/slave-agent.jnlp -secret 66730e037b2250e19b06ce62d652a459fe9b3388121fdcee5050ad9ffa10a842 -workDir /gameci/unity_2019_4_36f1_windows_mono_0_17_2


networks:
  default:
    external: true
    name: lanet
```

# 其它

```bash

# 创建网络
sudo docker network create --gateway 192.168.1.1 --subnet 192.168.1.0/24 lanet

# 容器列表
sudo docker ps -a

# 进入容器, 指定容器ID
sudo docker exec -it 容器ID bash

# 使用授权文件激活Unity
unity-editor -quit -batchmode -logfile - -manualLicenseFile 授权文件

```

# 引用

https://forum.unity.com/threads/add-an-option-to-auto-update-packages.730628/