unity_project_template
======================

# 参数

```bash

unity_exe_file=/path/to/the/unity/exe # Unity程序路径
dot_prj_name_core=dot_prj_core # 通用核心模块名
dot_prj_name_mods=dot_prj_mod0,dot_prj_mod1 # 业务子模块名, 列表, 逗号分隔
dot_prj_name_editor=dot_prj_editor # 编辑器模块名
unity_log_file= # /path/to/the/log/file
u3d_prj_name=u3d_prj # Unity项目名
u3d_build_target=Android # Unity目标平台
u3d_out_file_name=${u3d_prj_name}_${timestamp}.apk # Unity构建输出文件名
u3d_prj_builder_script=com.wolfired.dot_prj_stage1.DefaultAndroidBuilder.Build # Unity构建脚本
server_endpoint= # Unity加速功能相关
server_namespace_prefix= # Unity加速功能相关
server_enable_download=true # Unity加速功能相关
server_enable_upload=true # Unity加速功能相关
refs4player=Mono.Options # Unity Player的外部依赖, 标准的nuget包, 列表, 逗号分隔
refs4editor= # Unity Editor的外部依赖, 标准的nuget包, 列表, 逗号分隔
step_env_prepare=0 # 环境设置, 主要用于自动化构建环境, 本地开发一般无需调用
step_activate_unity=0 # 使用授权文件激活Unity, 主要用于自动化构建环境, 本地开发一般无需调用
step_create_unity_prj=0 # 创建Unity项目, 首次调用后根据实际情况选择调用
step_dotnet_refs=0 # 生成外部依赖整合项目, 首次调用后有增删外部依赖时调用
step_install_unity_package=0 # 安装Unity插件并生成Unity项目文件, 首次调用后根据实际情况选择调用, 目前脚本内部只安装VScode插件用于生成Unity项目文件
step_create_dotnet_prj=0 # 创建全部Dotnet项目, 首次调用后根据实际情况选择调用
step_build_dotnet_prj=0 # 构建全部Dotnet项目
step_create_default_scene=0 # 创建默认场景, 首次调用后根据实际情况选择调用
step_build_unity_prj=0 # 构建Unity项目
step_upload=0 # 上传资源, 主要用于自动化构建环境, 本地开发一般无需调用

```

这是一个Unity项目模板

# 环境变量

```bash

JAVA_HOME=

ANDROID_SDK_ROOT=

ANDROID_NDK_ROOT= # or
ANDROID_NDK_HOME=

VSCODE_CMD= # 用于生成Unity项目文件, 必填

```

# 模板

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
server_endpoint= \
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
server_endpoint= \
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
server_endpoint= \
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
server_endpoint= \
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
server_endpoint= \
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

ssh -p 9022 link@192.168.100.168 -t htop

time java -jar jenkins-cli.jar -s http://192.168.180.25:58080/ -webSocket -auth admin:admin build tmp_exe -w -s -v \
| tee tmp_exe.log \
&& cat tmp_exe.log | curl $(grep -oP '(?<=Download:\s)https://.+?\.zip$') -sO \
&& filename=`ls tmp_*.zip | sort -r | head -n 1` \
&& 7z x -o${filename%.*} $filename

time java -jar jenkins-cli.jar -s http://192.168.180.25:58080/ -webSocket -auth admin:admin build tmp_apk -w -s -v \
| tee tmp_apk.log \
&& cat tmp_apk.log | curl $(grep -oP '(?<=Download:\s)https://.+?\.apk$') -sO \
&& adb install `ls tmp_*.apk | sort -r | head -n 1`

time java -jar jenkins-cli.jar -s http://192.168.180.25:58080/ -webSocket -auth admin:admin build tmp_testbed -w -s -v \
| tee tmp_testbed.log

```

# 引用

https://forum.unity.com/threads/add-an-option-to-auto-update-packages.730628/
