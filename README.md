unity_project_template
======================

这是一个Unity项目模板

# dot_prj_stage0

只依赖`UnityEngine`, `UnityEditor`, 负责安装`Unity Package`

# dot_prj_stage1

依赖`UnityEngine`, `UnityEditor`, 另外也依赖

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

`main.sh` -> `env_prepare()` 要用到代理
