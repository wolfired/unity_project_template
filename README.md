unity_project_template
======================

这是一个Unity项目模板

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

unity_exe_file=/d/Unity.2021.2.0a21/Editor/Unity.exe \
dot_prj_name_core=slg_dot_core \
dot_prj_name_mods=slg_dot_mod0,slg_dot_mod1 \
dot_prj_name_editor=slg_dot_editor \
unity_log_file=unity_log.txt \
bash ./main.sh

unity_exe_file=/d/Unity.2019.4.6f1/Editor/Unity.exe \
dot_prj_name_core=slg_dot_core \
dot_prj_name_mods=slg_dot_mod0,slg_dot_mod1 \
dot_prj_name_editor=slg_dot_editor \
unity_log_file=unity_log.txt \
bash ./main.sh

```

# 注意

`main.sh` -> `env_prepare()` 安装 `dotnet` 要用到代理
