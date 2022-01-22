#!/bin/env bash

root_path=$(dirname $0)

source $root_path/libdot.sh
source $root_path/libunity.sh

unity_exe_file=${unity_exe_file:-'/d/Unity.2021.2.0a21/Editor/Unity.exe'}
unity_log_file=${unity_log_file:-'-'}
unity_out_file=${unity_out_file:-"$root_path/u3d_out/main.apk"}
unity_out_path=$(dirname $unity_out_file)

dotnet_out_path=${dotnet_out_path:-"$root_path/dot_out"}

u3d_prj_path=${u3d_prj_path:-"$root_path"}
u3d_prj_name=${u3d_prj_name:-'slg_u3d'}

dot_sln_path=${dot_sln_path:-"$root_path"}
dot_sln_name=${dot_sln_name:-'slg_dot'}

dot_prj_path=$dot_sln_path

dot_prj_name_core=${dot_prj_name_core:?'need core module name'}
dot_prj_name_mods=${dot_prj_name_mods:?'need function module name'} # mod_name0,mod_name1,mod_name2
dot_prj_name_editor=${dot_prj_name_editor:?'need editor module name'}

# -noUpm
unity_cmd="$unity_exe_file -quit -logFile $unity_log_file -batchmode -nographics"

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
    sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list
    sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list
    apt-get update
    apt-get -y install language-pack-en

    export http_proxy=http://192.168.1.7:1080
    export https_proxy=http://192.168.1.7:1080
    wget https://dot.net/v1/dotnet-install.sh \
    && bash ./dotnet-install.sh --channel 5.0 \
    && export DOTNET_ROOT=/root/.dotnet \
    && export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools \
    && rm -rf ./dotnet-install.sh
    export -n http_proxy
    export -n https_proxy

    if [[ 0 -eq $(dotnet tool list -g | grep -oP 'wolfired.u3dot_converter' | wc -l) ]]; then
        dotnet tool install -g wolfired.u3dot_converter
    fi
}

function activate_unity() {
    local unity_version=${1:-$(unity -version)}
    local web_share_url=${2:-'https://help.wolfired.com/share'}

    local unity_alf_file=Unity_v`echo $unity_version | grep -oP '\d+\.\d+\.[0-9a-z]+(?=\.\d+)'`.alf
    local unity_ulf_file=Unity_v`echo $unity_version | grep -oP '^\d+'`.x.ulf
    
    printf '%48s: %s\n' 'Unity Version' $unity_version
    printf '%48s: %s\n' 'ALF File' $unity_alf_file
    printf '%48s: %s\n' 'ULF File' $unity_ulf_file

    curl --fail -s $web_share_url/$unity_ulf_file -o $unity_ulf_file
    if (( 0 != $? )); then
        $unity_cmd -createManualActivationFile
        scp_upload $unity_alf_file
        exit 1
    fi

    $unity_cmd -manualLicenseFile $unity_ulf_file
}

function dot_prj_create() {
    local dot_prj_name_core=${dot_prj_name_core:?'need core module name'}
    local dot_prj_name_mods=${dot_prj_name_mods:?'need function module name'} # mod_name0,mod_name1,mod_name2
    local dot_prj_name_editor=${dot_prj_name_editor:?'need editor module name'}

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

    DotProjectNew $dot_sln_path $dot_sln_name classlib "netstandard2.0" $dot_prj_path/$dot_prj_name_editor
    if [[ 0 -eq $? ]]; then
        DotProjectAddPackages $dot_prj_path/$dot_prj_name_editor Mono.Options
        DotProjectAddReference $dot_prj_path/$dot_prj_name_editor $dot_prj_path/$dot_prj_name_core

        readarray -td, arr_dot_prj_name_mod <<<"$dot_prj_name_mods,"
        unset 'arr_dot_prj_name_mod[-1]'
        for dot_prj_name in "${arr_dot_prj_name_mod[@]}"; do
            DotProjectAddReference $dot_prj_path/$dot_prj_name_editor $dot_prj_path/$dot_prj_name
        done

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
}

function u3d_prj_build() {
    rm -rf $unity_out_path
    UnityExecuteMethod $u3d_prj_path/$u3d_prj_name com.wolfired.slg_dot_editor.AndroidBuilder.Build
}

args_print

# env_prepare

# activate_unity 2019.4.6f1.0000

UnityCreateProject $u3d_prj_path/$u3d_prj_name

DotSolutionNew $dot_sln_path $dot_sln_name

dot_prj_create $dot_prj_name_core $dot_prj_name_mods $dot_prj_name_editor

dot_prj_build

u3d_prj_build