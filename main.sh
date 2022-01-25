#!/bin/env bash

root_path=$(dirname $0)

source $root_path/libdot.sh
source $root_path/libunity.sh

unity_exe_file=${unity_exe_file:-'/d/Unity.2021.2.0a21/Editor/Unity.exe'}
unity_log_file=${unity_log_file:-'-'}
unity_out_file=${unity_out_file:-"$root_path/out_u3d/main.apk"}
unity_out_path=$(dirname $unity_out_file)

dotnet_out_path=${dotnet_out_path:-"$root_path/out_dot"}

dlls4editor=${dlls4editor:-"$root_path/dlls4editor"}

u3d_prj_path=${u3d_prj_path:-"$root_path"}
u3d_prj_name=${u3d_prj_name:-'u3d_prj'}

dot_sln_path=${dot_sln_path:-"$root_path"}
dot_sln_name=${dot_sln_name:-'dot_prj'}

dot_prj_path=$dot_sln_path
dot_prj_name_core=${dot_prj_name_core:?'need core module name'}
dot_prj_name_mods=${dot_prj_name_mods:?'need function module name'} # mod_name0,mod_name1,mod_name2
dot_prj_name_editor=${dot_prj_name_editor:?'need editor module name'}

dot_prj_name_stage0=${dot_prj_name_stage0:-'dot_prj_stage0'}
dot_prj_name_stage1=${dot_prj_name_stage1:-'dot_prj_stage1'}

step_clean_clear=${step_clean_clear:-0}
step_env_prepare=${step_env_prepare:-0}
step_activate_unity=${step_activate_unity:-0}
step_create_unity_prj=${step_create_unity_prj:-0}
step_install_unity_package=${step_install_unity_package:-0}
step_create_dotnet_prj=${step_create_dotnet_prj:-0}
step_build_dotnet_prj=${step_build_dotnet_prj:-0}
step_build_unity_prj=${step_build_unity_prj:-0}

# -noUpm -quit
unity_cmd="$unity_exe_file -logFile $unity_log_file -batchmode -nographics"

function args_print() {
    printf '%48s: %s\n' 'Project Root Path' $root_path
    printf '%48s: %s\n' 'Unity Exe File' $unity_exe_file
    printf '%48s: %s\n' 'Unity CMD' "$unity_cmd"
    printf '%48s: %s\n' 'Unity Prj Name' $u3d_prj_name
    printf '%48s: %s\n' 'Unity Log File' $unity_log_file
    printf '%48s: %s\n' 'Unity Out Path' $unity_out_path
    printf '%48s: %s\n' 'Unity Out File' $unity_out_file
    printf '%48s: %s\n' 'Dotnet Sln Name' $dot_sln_name
    printf '%48s: %s\n' '( Core )Dotnet Prj Name' $dot_prj_name_core
    printf '%48s: %s\n' '( Mods )Dotnet Prj Name' $dot_prj_name_mods
    printf '%48s: %s\n' '(Editor)Dotnet Prj Name' $dot_prj_name_editor
    printf '%48s: %s\n' 'Dotnet Out Path' $dotnet_out_path
}

# SCP上传文件
function scp_upload() {
    local upload_file=${1:?'need upload file'}
    local upload_then_delete=${2:-0} # 上传后是否删除源文件, 0(default) | 1
    local web_share_url=${3:-'https://help.wolfired.com/share'}

    if [[ ! -f $upload_file ]]; then
        printf '%48s: %s\n' 'nothing to upload, upload_file not exist' $upload_file
        return
    fi

    local scp_id_file=scp_id_file_`date +%s`
    curl -s $web_share_url/scp_id_file -o $scp_id_file && \
    chmod 400 $scp_id_file && \
    scp -o StrictHostKeyChecking=no -P 2222 -i ./$scp_id_file $upload_file hd@ssh.mac.com:/Users/hd/nginx/html/share/ && \
    rm -f $scp_id_file && \
    if (( 0 != $upload_then_delete )); then rm -f $upload_file; fi
}

function env_prepare() {
    export http_proxy=http://192.168.1.7:1080
    export https_proxy=http://192.168.1.7:1080

    sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list
    sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list
    apt-get update
    apt-get -y install language-pack-en software-properties-common apt-transport-https

    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -
    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    apt install -y code

    wget https://dot.net/v1/dotnet-install.sh \
    && bash ./dotnet-install.sh --channel 5.0 \
    && export DOTNET_ROOT=/root/.dotnet \
    && export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools \
    && rm -rf ./dotnet-install.sh

    if [[ 0 -eq $(dotnet tool list -g | grep -oP 'wolfired.u3dot_converter' | wc -l) ]]; then
        dotnet tool install -g wolfired.u3dot_converter
    fi

    export -n http_proxy
    export -n https_proxy
}

function activate_unity() {
    local unity_version=${1:-$(unity -version)} # 2019.4.6f1.0000
    local web_share_url=${2:-'https://help.wolfired.com/share'}

    local unity_alf_file=Unity_v`echo $unity_version | grep -oP '\d+\.\d+\.[0-9a-z]+(?=\.\d+)'`.alf
    local unity_ulf_file=Unity_v`echo $unity_version | grep -oP '^\d+'`.x.ulf
    
    printf '%48s: %s\n' 'Unity Version' $unity_version
    printf '%48s: %s\n' 'ALF File' $unity_alf_file
    printf '%48s: %s\n' 'ULF File' $unity_ulf_file

    curl --fail -s $web_share_url/$unity_ulf_file -o $unity_ulf_file
    if (( 0 != $? )); then
        $unity_cmd -quit -createManualActivationFile
        scp_upload $unity_alf_file
        exit 1
    fi

    $unity_cmd -quit -manualLicenseFile $unity_ulf_file
}

function dot_prj_create() {
    local dot_prj_name_core=${1:?'need core module name'}
    local dot_prj_name_mods=${2:?'need function module name'} # mod_name0,mod_name1,mod_name2
    local dot_prj_name_editor=${3:?'need editor module name'}
    local dot_prj_name_stage0=${4:?'need stage0 module name'}
    local dot_prj_name_stage1=${5:?'need stage1 module name'}

    DotProjectNew $dot_sln_path $dot_sln_name classlib "netstandard2.0" $dot_prj_path/$dot_prj_name_core
    if [[ 0 -eq $? ]]; then
        u3dot_converter \
        --cfsrc $u3d_prj_path/$u3d_prj_name/Assembly-CSharp.csproj \
        --nssrc 'http://schemas.microsoft.com/developer/msbuild/2003' \
        --cfdst $dot_prj_path/$dot_prj_name_core/$dot_prj_name_core.csproj
    fi

    readarray -td, arr_dot_prj_name_mod <<<"$dot_prj_name_mods,"
    unset 'arr_dot_prj_name_mod[-1]'
    for dot_prj_name in "${arr_dot_prj_name_mod[@]}"; do
        DotProjectNew $dot_sln_path $dot_sln_name classlib "netstandard2.0" $dot_prj_path/$dot_prj_name
        if [[ 0 -eq $? ]]; then
            DotProjectAddReference $dot_prj_path/$dot_prj_name $dot_prj_path/$dot_prj_name_core

            u3dot_converter \
            --cfsrc $u3d_prj_path/$u3d_prj_name/Assembly-CSharp.csproj \
            --nssrc 'http://schemas.microsoft.com/developer/msbuild/2003' \
            --cfdst $dot_prj_path/$dot_prj_name/$dot_prj_name.csproj
        fi
    done

    DotProjectNew $dot_sln_path $dot_sln_name classlib "netstandard2.0" $dot_prj_path/$dot_prj_name_stage0
    if [[ 0 -eq $? ]]; then
        DotProjectAddPackage $dot_prj_path/$dot_prj_name_stage0 Mono.Options 6.12.0.148

        u3dot_converter \
        --cfsrc $u3d_prj_path/$u3d_prj_name/Assembly-CSharp-Editor.csproj \
        --nssrc 'http://schemas.microsoft.com/developer/msbuild/2003' \
        --cfdst $dot_prj_path/$dot_prj_name_stage0/$dot_prj_name_stage0.csproj \
        --skips 'Assembly-CSharp.csproj'
    fi

    DotProjectNew $dot_sln_path $dot_sln_name classlib "netstandard2.0" $dot_prj_path/$dot_prj_name_stage1
    if [[ 0 -eq $? ]]; then
        DotProjectAddPackage $dot_prj_path/$dot_prj_name_stage1 Mono.Options 6.12.0.148

        u3dot_converter \
        --cfsrc $u3d_prj_path/$u3d_prj_name/Assembly-CSharp-Editor.csproj \
        --nssrc 'http://schemas.microsoft.com/developer/msbuild/2003' \
        --cfdst $dot_prj_path/$dot_prj_name_stage1/$dot_prj_name_stage1.csproj \
        --skips 'Assembly-CSharp.csproj'
    fi

    DotProjectNew $dot_sln_path $dot_sln_name classlib "netstandard2.0" $dot_prj_path/$dot_prj_name_editor
    if [[ 0 -eq $? ]]; then
        DotProjectAddPackage $dot_prj_path/$dot_prj_name_editor Mono.Options 6.12.0.148
        DotProjectAddReference $dot_prj_path/$dot_prj_name_editor $dot_prj_path/$dot_prj_name_core

        readarray -td, arr_dot_prj_name_mod <<<"$dot_prj_name_mods,"
        unset 'arr_dot_prj_name_mod[-1]'
        for dot_prj_name in "${arr_dot_prj_name_mod[@]}"; do
            DotProjectAddReference $dot_prj_path/$dot_prj_name_editor $dot_prj_path/$dot_prj_name
        done

        DotProjectAddReference $dot_prj_path/$dot_prj_name_editor $dot_prj_path/$dot_prj_name_stage0
        DotProjectAddReference $dot_prj_path/$dot_prj_name_editor $dot_prj_path/$dot_prj_name_stage1

        u3dot_converter \
        --cfsrc $u3d_prj_path/$u3d_prj_name/Assembly-CSharp-Editor.csproj \
        --nssrc 'http://schemas.microsoft.com/developer/msbuild/2003' \
        --cfdst $dot_prj_path/$dot_prj_name_editor/$dot_prj_name_editor.csproj \
        --skips 'Assembly-CSharp.csproj'
    fi
}

function dot_prj_build() {
    DotBuild $dot_sln_path $dot_sln_name $dotnet_out_path
    DotDLLsSrc2Dst $dotnet_out_path $u3d_prj_path/$u3d_prj_name/Assets/Plugins $dot_prj_name_core true
    DotDLLsSrc2Dst $dotnet_out_path $u3d_prj_path/$u3d_prj_name/Assets/Plugins $dot_prj_name_mods true
    DotDLLsSrc2Dst $dotnet_out_path $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins $dot_prj_name_editor true

    DotDLLsSrc2Dst $dotnet_out_path $dlls4editor $dot_prj_name_stage0 true
    DotDLLsSrc2Dst $dotnet_out_path $dlls4editor $dot_prj_name_stage1 true

    DotDLLsSrc2Dst $dotnet_out_path $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins $dot_prj_name_stage0 true
    DotDLLsSrc2Dst $dotnet_out_path $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins $dot_prj_name_stage1 true
}

function u3d_prj_build() {
    rm -rf $unity_out_path
    UnityExecuteMethod $u3d_prj_path/$u3d_prj_name com.wolfired.dot_prj_editor.AndroidBuilder.Build $unity_out_file
}

args_print

if (( 0 != $step_clean_clear )); then
    rm -rf $unity_out_path
    rm -rf $dotnet_out_path

    rm -rf $u3d_prj_path/$u3d_prj_name/.vscode
    rm -rf $u3d_prj_path/$u3d_prj_name/Library
    rm -rf $u3d_prj_path/$u3d_prj_name/Temp
    rm -rf $u3d_prj_path/$u3d_prj_name/*.csproj
    rm -rf $u3d_prj_path/$u3d_prj_name/*.sln

    rm -rf $dot_prj_path/$dot_prj_name_core/bin
    rm -rf $dot_prj_path/$dot_prj_name_core/obj
    rm -rf $dot_prj_path/$dot_prj_name_core/*.csproj

    readarray -td, arr_dot_prj_name_mod <<<"$dot_prj_name_mods,"
    unset 'arr_dot_prj_name_mod[-1]'
    for dot_prj_name in "${arr_dot_prj_name_mod[@]}"; do
        rm -rf $dot_prj_path/$dot_prj_name/bin
        rm -rf $dot_prj_path/$dot_prj_name/obj
        rm -rf $dot_prj_path/$dot_prj_name/*.csproj
    done

    rm -rf $dot_prj_path/$dot_prj_name_editor/bin
    rm -rf $dot_prj_path/$dot_prj_name_editor/obj
    rm -rf $dot_prj_path/$dot_prj_name_editor/*.csproj

    rm -rf $dot_prj_path/$dot_prj_name_stage0/bin
    rm -rf $dot_prj_path/$dot_prj_name_stage0/obj
    rm -rf $dot_prj_path/$dot_prj_name_stage0/*.csproj

    rm -rf $dot_prj_path/$dot_prj_name_stage1/bin
    rm -rf $dot_prj_path/$dot_prj_name_stage1/obj
    rm -rf $dot_prj_path/$dot_prj_name_stage1/*.csproj

    rm -rf $dot_sln_path/$dot_sln_name.sln

    rm -rf *.log
fi

if (( 0 != $step_env_prepare )); then
    env_prepare
fi

if (( 0 != $step_activate_unity )); then
    activate_unity 2019.4.6f1.0000
fi

if (( 0 != $step_create_unity_prj )); then
    UnityCreateProject $u3d_prj_path/$u3d_prj_name
fi

if (( 0 != $step_install_unity_package )); then
    cp -v -u $dlls4editor/* $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins/

    UnityExecuteMethod \
    $u3d_prj_path/$u3d_prj_name \
    com.wolfired.dot_prj_stage0.UnityPackageHelper.Install --upm_i_args_package_id com.unity.ide.vscode

    UnityExecuteMethod \
    $u3d_prj_path/$u3d_prj_name \
    com.wolfired.dot_prj_stage1.UnityEditorHelper.SetupVSCode

    UnityExecuteMethod \
    $u3d_prj_path/$u3d_prj_name \
    com.wolfired.dot_prj_stage1.CodeEditorHelper.GenU3DProjectFiles
fi

if (( 0 != $step_create_dotnet_prj )); then
    DotSolutionNew $dot_sln_path $dot_sln_name

    dot_prj_create $dot_prj_name_core $dot_prj_name_mods $dot_prj_name_editor $dot_prj_name_stage0 $dot_prj_name_stage1
fi

if (( 0 != $step_build_dotnet_prj )); then
    dot_prj_build
fi

if (( 0 != $step_build_unity_prj )); then
    u3d_prj_build
fi
