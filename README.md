unity_project_template
======================

这是一个Unity项目模板

# dot_prj_stage0

只依赖`UnityEngine`, `UnityEditor`, 负责安装`Unity Package`

# dot_prj_stage1

依赖`UnityEngine`, `UnityEditor`

# 用法

* 编辑`main.sh`

```bash

# Unity程序
unity_exe_file=

# Unity项目名
u3d_prj_name=

# Dotnet解决方案名
dot_sln_name=

# Dotnet项目, 无依赖
dot_prj_name_core=

# 多个Dotnet项目, 依赖 dot_prj_name_core
dot_prj_names=

# Dotnet项目, 依赖 dot_prj_name_core, dot_prj_names
dot_prj_name_editor=

# Windows
unity_exe_file=/d/Unity.2019.4.6f1/Editor/Unity.exe \
dot_prj_name_core=dot_prj_core \
dot_prj_name_mods=dot_prj_mod0,dot_prj_mod1 \
dot_prj_name_editor=dot_prj_editor \
unity_log_file=u3d_editor_`date +%Y%m%d_%H%M%S`.log \
step_env_prepare=0 \
step_activate_unity=0 \
step_create_unity_prj=1 \
step_dotnet_refs=1 \
step_install_unity_package=1 \
step_create_dotnet_prj=1 \
step_build_dotnet_prj=1 \
step_build_unity_prj=1 \
step_upload=0 \
bash ./main.sh

# Windows
unity_exe_file=/d/Unity.2021.2.0a21/Editor/Unity.exe \
dot_prj_name_core=dot_prj_core \
dot_prj_name_mods=dot_prj_mod0,dot_prj_mod1 \
dot_prj_name_editor=dot_prj_editor \
unity_log_file=u3d_editor_`date +%Y%m%d_%H%M%S`.log \
step_env_prepare=0 \
step_activate_unity=0 \
step_create_unity_prj=0 \
step_dotnet_refs=1 \
step_install_unity_package=0 \
step_create_dotnet_prj=0 \
step_build_dotnet_prj=1 \
step_build_unity_prj=0 \
step_upload=0 \
bash ./main.sh

# Ubuntu
unity_exe_file=/usr/bin/unity-editor \
dot_prj_name_core=dot_prj_core \
dot_prj_name_mods=dot_prj_mod0,dot_prj_mod1 \
dot_prj_name_editor=dot_prj_editor \
unity_log_file=u3d_editor_`date +%Y%m%d_%H%M%S`.log \
step_env_prepare=1 \
step_activate_unity=1 \
step_create_unity_prj=1 \
step_dotnet_refs=1 \
step_install_unity_package=1 \
step_create_dotnet_prj=1 \
step_build_dotnet_prj=1 \
step_build_unity_prj=1 \
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
  unity:
    container_name: unity
    image: unityci/editor:ubuntu-2019.4.36f1-android-0.17
    restart: always
    volumes:
    - /home/link/workspace_labs/gameci:/gameci
    dns:
    - 192.168.180.25
    networks:
      default:
        ipv4_address: 192.168.1.8
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
      apt-get update && apt-get -y install language-pack-en software-properties-common apt-transport-https subversion cifs-utils
      locale-gen en_US.UTF-8
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
      java -jar agent.jar -jnlpUrl http://jenkins.builder.com/computer/xen/slave-agent.jnlp -secret df4ca69bedaf48f744fc419bcd327edb6774264841cff931712da0c5366a4995 -workDir /gameci


networks:
  default:
    external: true
    name: lanet
```

# 其它

```bash

# 容器列表
sudo docker ps -a

# 进入容器, 指定容器ID
sudo docker exec -it 容器ID bash

# 使用授权文件激活Unity
unity-editor -quit -batchmode -logfile - -manualLicenseFile 授权文件

```
