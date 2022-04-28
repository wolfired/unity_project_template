#!/bin/env bash

root_full=$(readlink -f "$0")
root_path=$(dirname $root_full)

source $root_path/libdot.sh
source $root_path/libunity.sh

timestamp=${timestamp:-`date +%Y%m%d_%H%M%S`}

unity_exe_file=${unity_exe_file:-'/d/Unity.2020.3.33f1/Editor/Unity.exe'}
unity_log_file=${unity_log_file:-"$timestamp.log"}

dot_prj_name4player=refs4player
refs4player=${refs4player:-'Mono.Options'} # DLL_NAME0,DLL_NAME1
dot_prj_name4editor=refs4editor
refs4editor=${refs4editor:-''} # DLL_NAME0,DLL_NAME1

#
u3d_build_target=${u3d_build_target:-'Win64'}
u3d_build_target_file_suffix=
if [[ ! -n $u3d_prj_builder_script ]]; then
    case $u3d_build_target in
        'Win'|'Win64')
            u3d_prj_builder_script=${u3d_prj_builder_script:-'com.wolfired.dot_prj_stage1.DefaultWindowsBuilder.Build'}
            u3d_build_target_file_suffix='.exe'
        ;;
        'Android')
            u3d_prj_builder_script=${u3d_prj_builder_script:-'com.wolfired.dot_prj_stage1.DefaultAndroidBuilder.Build'}
            u3d_build_target_file_suffix='.apk'
        ;;
        *)
            echo "Error Build Target: $u3d_build_target"
            exit 1
        ;;
    esac
fi
u3d_build_target=${u3d_build_target:+"-buildTarget $u3d_build_target"}

#
u3d_prj_path=${u3d_prj_path:-$root_path}

u3d_prj_prefix=${u3d_prj_prefix:-'u3d_prj_'}

u3d_prj_name=${u3d_prj_name:-'game'}
u3d_prj_name=${u3d_prj_name:+$u3d_prj_prefix$u3d_prj_name}

u3d_out_path=${u3d_out_path:-$u3d_prj_path/out_u3d}
u3d_out_file_name=${u3d_out_file_name:-${u3d_prj_name}_${timestamp}$u3d_build_target_file_suffix}
u3d_out_file=${u3d_out_file:-$u3d_out_path/$u3d_out_file_name}

#
dot_sln_path=${dot_sln_path:-$root_path}

dot_sln_prefix=${dot_sln_prefix:-'dot_sln_'}

dot_sln_name=${dot_sln_name:-'full'}
dot_sln_name=${dot_sln_name:+$dot_sln_prefix$dot_sln_name}

#
dot_prj_path=${dot_prj_path:-$root_path}

dot_prj_prefix=${dot_prj_prefix:-'dot_prj_'}
export DOT_PRJ_PREFIX=$dot_prj_prefix # CS构建脚本使用

dot_prj_name_core=${dot_prj_name_core:-'core'}
dot_prj_name_core=${dot_prj_name_core:+$dot_prj_prefix$dot_prj_name_core}
export DOT_PRJ_NAME_CORE=$dot_prj_name_core # CS构建脚本使用

dot_prj_name_mods=${dot_prj_name_mods-'mod0,mod1'} # mod_name0,mod_name1,mod_name2
readarray -td, arr_dot_prj_name_mod <<< "$dot_prj_name_mods"
unset dot_prj_name_mods
for dot_prj_name_mod in ${arr_dot_prj_name_mod[@]}; do
    dot_prj_name_mods+=$dot_prj_prefix$dot_prj_name_mod,
done
dot_prj_name_mods=${dot_prj_name_mods:0:-1}
export DOT_PRJ_NAME_MODS=$dot_prj_name_mods # CS构建脚本使用

dot_prj_name_editor=${dot_prj_name_editor:-'editor'}
dot_prj_name_editor=${dot_prj_name_editor:+$dot_prj_prefix$dot_prj_name_editor}

dot_prj_name_stage0=${dot_prj_name_stage0:-'dot_prj_stage0'}
dot_prj_name_stage1=${dot_prj_name_stage1:-'dot_prj_stage1'}

dot_out_path=${dot_out_path:-$dot_prj_path/out_dot}

#
server_endpoint=${server_endpoint:-}
adb2_enable=${server_endpoint:+'-adb2'}
cache_server_enable=${server_endpoint:+'-enableCacheServer'}
cache_server_endpoint=${server_endpoint:+"-cacheServerEndpoint $server_endpoint"}
server_namespace_prefix=${server_namespace_prefix:-"$u3d_prj_name"}
cache_server_namespace_prefix=${server_endpoint:+"-cacheServerNamespacePrefix $server_namespace_prefix"}
server_enable_download=${server_enable_download:-true}
cache_server_enable_download=${server_endpoint:+"-cacheServerEnableDownload $server_enable_download"}
server_enable_upload=${server_enable_upload:-true}
cache_server_enable_upload=${server_endpoint:+"-cacheServerEnableUpload $server_enable_upload"}

# -noUpm -quit -disable-gpu-skinning -nographics -job-worker-count 8
unity_cmd_args="$adb2_enable $cache_server_enable $cache_server_endpoint $cache_server_namespace_prefix $cache_server_enable_download $cache_server_enable_upload -logFile $unity_log_file $u3d_build_target -batchmode -nographics"
unity_cmd="$unity_exe_file $unity_cmd_args"

#
step_clean_clear=${step_clean_clear:-0}
step_clean_clear_all=${step_clean_clear_all:-0}
step_env_prepare=${step_env_prepare:-0}
step_activate_unity=${step_activate_unity:-0}
step_create_unity_prj=${step_create_unity_prj:-0}
step_dotnet_refs=${step_dotnet_refs:-0}
setp_prepare_stage=${setp_prepare_stage:-0}
step_create_dotnet_prj=${step_create_dotnet_prj:-0}
step_build_dotnet_prj=${step_build_dotnet_prj:-0}
step_create_default_scene=${step_create_default_scene:-0}
step_build_unity_ab=${step_build_unity_ab:-0}
step_build_unity_prj=${step_build_unity_prj:-0}
step_upload=${step_upload:-0}
step_zipprj=${step_zipprj:-0}

function u3d_amend_dlls() {
    UnityExecuteMethod \
    $u3d_prj_path/$u3d_prj_name \
    com.wolfired.dot_prj_stage0.U3DEditorUtils.RefreshAssets

    find $u3d_prj_path/$u3d_prj_name/Assets/Plugins -name "$dot_prj_prefix*.dll.meta" -type f -exec sed -i "s/isExplicitlyReferenced: 0/isExplicitlyReferenced: 1/g" {} \;
    find $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins -name "$dot_prj_prefix*.dll.meta" -type f -exec sed -i "s/isExplicitlyReferenced: 0/isExplicitlyReferenced: 1/g" {} \;

    find $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins -name "$dot_prj_name_stage0.dll.meta" -type f -exec sed -i "s/isExplicitlyReferenced: 0/isExplicitlyReferenced: 1/g" {} \;
    find $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins -name "$dot_prj_name_stage1.dll.meta" -type f -exec sed -i "s/isExplicitlyReferenced: 0/isExplicitlyReferenced: 1/g" {} \;
}

function args_print() {
    printf '%48s: %s\n' 'Project Root Path' $root_path
    printf '%48s: %s\n' 'Unity CMD File' $unity_exe_file
    printf '%48s: %s\n' 'Unity CMD Args' ''
    IFS=' ' read -ra args <<< "$unity_cmd_args"
    for arg in "${args[@]}"; do
        printf '%48s  %s\n' '' $arg
    done
    printf '%48s: %s\n' 'Unity Prj Name' $u3d_prj_name
    printf '%48s: %s\n' 'Unity Log File' $unity_log_file
    printf '%48s: %s\n' 'Unity Out Path' $u3d_out_path
    printf '%48s: %s\n' 'Unity Out File' $u3d_out_file
    printf '%48s: %s\n' 'Unity Build Script' $u3d_prj_builder_script
    printf '%48s: %s\n' 'Dotnet Sln Name' $dot_sln_name
    printf '%48s: %s\n' '( Core )Dotnet Prj Name' $dot_prj_name_core
    printf '%48s: %s\n' '( Mods )Dotnet Prj Name' $dot_prj_name_mods
    printf '%48s: %s\n' '(Editor)Dotnet Prj Name' $dot_prj_name_editor
    printf '%48s: %s\n' 'Dotnet Out Path' $dot_out_path
}
args_print

function step_clean_clear() {
    local cc_all=${1:-0}

    rm -rf $u3d_out_path
    rm -rf $dot_out_path

    rm -rf $u3d_prj_path/$u3d_prj_name/.vscode
    rm -rf $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins/*.{dll,dll.meta,pdb,pdb.meta}
    rm -rf $u3d_prj_path/$u3d_prj_name/Assets/Plugins/*.{raw,raw.meta,dll,dll.meta,pdb,pdb.meta}
    rm -rf $u3d_prj_path/$u3d_prj_name/Assets/StreamingAssets/*
    rm -rf $u3d_prj_path/$u3d_prj_name/Library
    rm -rf $u3d_prj_path/$u3d_prj_name/Logs
    rm -rf $u3d_prj_path/$u3d_prj_name/Temp
    if (( 1 == $cc_all )); then
        rm -rf $u3d_prj_path/$u3d_prj_name/*.csproj
        rm -rf $u3d_prj_path/$u3d_prj_name/*.sln
    fi


    rm -rf $dot_prj_path/$dot_prj_name_core/.vscode
    rm -rf $dot_prj_path/$dot_prj_name_core/bin
    rm -rf $dot_prj_path/$dot_prj_name_core/obj
    if (( 1 == $cc_all )); then
        rm -rf $dot_prj_path/$dot_prj_name_core/*.csproj
    fi

    readarray -td, arr_dot_prj_name_mod <<< "$dot_prj_name_mods"
    for dot_prj_name_mod in ${arr_dot_prj_name_mod[@]}; do
        rm -rf $dot_prj_path/$dot_prj_name_mod/.vscode
        rm -rf $dot_prj_path/$dot_prj_name_mod/bin
        rm -rf $dot_prj_path/$dot_prj_name_mod/obj
        if (( 1 == $cc_all )); then
            rm -rf $dot_prj_path/$dot_prj_name_mod/*.csproj
        fi
    done

    rm -rf $dot_prj_path/$dot_prj_name_editor/.vscode
    rm -rf $dot_prj_path/$dot_prj_name_editor/bin
    rm -rf $dot_prj_path/$dot_prj_name_editor/obj
    if (( 1 == $cc_all )); then
        rm -rf $dot_prj_path/$dot_prj_name_editor/*.csproj
    fi

    rm -rf $dot_prj_path/$dot_prj_name_stage0/.vscode
    rm -rf $dot_prj_path/$dot_prj_name_stage0/bin
    rm -rf $dot_prj_path/$dot_prj_name_stage0/obj
    if (( 1 == $cc_all )); then
        rm -rf $dot_prj_path/$dot_prj_name_stage0/*.csproj
    fi

    rm -rf $dot_prj_path/$dot_prj_name_stage1/.vscode
    rm -rf $dot_prj_path/$dot_prj_name_stage1/bin
    rm -rf $dot_prj_path/$dot_prj_name_stage1/obj
    if (( 1 == $cc_all )); then
        rm -rf $dot_prj_path/$dot_prj_name_stage1/*.csproj
    fi

    rm -rf $dot_prj_path/$dot_prj_name4player/.vscode
    rm -rf $dot_prj_path/$dot_prj_name4player/bin
    rm -rf $dot_prj_path/$dot_prj_name4player/obj
    if (( 1 == $cc_all )); then
        rm -rf $dot_prj_path/$dot_prj_name4player/*.csproj
    fi

    rm -rf $dot_prj_path/$dot_prj_name4editor/.vscode
    rm -rf $dot_prj_path/$dot_prj_name4editor/bin
    rm -rf $dot_prj_path/$dot_prj_name4editor/obj
    if (( 1 == $cc_all )); then
        rm -rf $dot_prj_path/$dot_prj_name4editor/*.csproj
    fi

    if (( 1 == $cc_all )); then
        rm -rf $dot_sln_path/$dot_sln_name.sln
    fi

    rm -rf *.log

    rm -rf *.zip
}
if (( 0 != $step_clean_clear )); then
    step_clean_clear 0
fi
if (( 0 != $step_clean_clear_all )); then
    step_clean_clear 1
fi

function step_env_prepare() {
    export http_proxy=http://192.168.1.7:1080
    export https_proxy=http://192.168.1.7:1080

    sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list
    sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list
    apt-get update
    apt-get -y install language-pack-en software-properties-common apt-transport-https

    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -
    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    apt install -y code

    export VSCODE_CMD=/usr/bin/code

    wget https://dot.net/v1/dotnet-install.sh \
    && bash ./dotnet-install.sh --channel 5.0 \
    && export DOTNET_ROOT=/root/.dotnet \
    && export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools \
    && rm -rf ./dotnet-install.sh

    if [[ 0 -eq $(dotnet tool list -g | grep -oP 'wolfired.u3dot_converter' | wc -l) ]]; then
        dotnet tool install -g wolfired.u3dot_converter
    fi

    # export -n http_proxy
    # export -n https_proxy
}
if (( 0 != $step_env_prepare )); then
    step_env_prepare
fi

function step_activate_unity() {
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
if (( 0 != $step_activate_unity )); then
    step_activate_unity 2019.4.6f1.0000
fi

function step_create_unity_prj() {
    UnityCreateProject $u3d_prj_path/$u3d_prj_name
}
if (( 0 != $step_create_unity_prj )); then
    step_create_unity_prj
fi

function step_dotnet_refs() {
    DotSolutionNew $dot_sln_path $dot_sln_name

    #
    DotProjectNew $dot_sln_path $dot_sln_name classlib "netstandard2.0" $dot_prj_path/$dot_prj_name4player

    if [[ 0 -eq $? ]]; then
        DotProjectAddPackages $dot_prj_path/$dot_prj_name4player $refs4player

        u3dot_converter \
        --cfdst $dot_prj_path/$dot_prj_name4player/$dot_prj_name4player.csproj
    fi

    DotBuild $dot_prj_path/$dot_prj_name4player $dot_prj_name4player.csproj $dot_out_path

    if [[ -n $refs4player && ! -z $refs4player ]]; then
        mkdir -p $dot_out_path $u3d_prj_path/$u3d_prj_name/Assets/Plugins
        DotDLLsSrc2Dst $dot_out_path $u3d_prj_path/$u3d_prj_name/Assets/Plugins $refs4player false
    fi

    #
    DotProjectNew $dot_sln_path $dot_sln_name classlib "netstandard2.0" $dot_prj_path/$dot_prj_name4editor

    if [[ 0 -eq $? ]]; then
        DotProjectAddReference $dot_prj_path/$dot_prj_name4editor $dot_prj_path/$dot_prj_name4player

        DotProjectAddPackages $dot_prj_path/$dot_prj_name4editor $refs4editor

        u3dot_converter \
        --cfdst $dot_prj_path/$dot_prj_name4editor/$dot_prj_name4editor.csproj
    fi

    DotBuild $dot_prj_path/$dot_prj_name4editor $dot_prj_name4editor.csproj $dot_out_path

    if [[ -n $refs4editor && ! -z $refs4editor ]]; then
        mkdir -p $dot_out_path $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins
        DotDLLsSrc2Dst $dot_out_path $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins $refs4editor false
    fi
}
if (( 0 != $step_dotnet_refs )); then
    step_dotnet_refs
fi

function setp_prepare_stage() {
    if [[ ! -f $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins/$dot_prj_name_stage0.dll ]]; then
        mkdir -p $u3d_prj_path/$u3d_prj_name/Assets/Editor/Scripts/$dot_prj_name_stage0
        cp -v -u $dot_prj_path/$dot_prj_name_stage0/src/*.cs $u3d_prj_path/$u3d_prj_name/Assets/Editor/Scripts/$dot_prj_name_stage0

        rm -rf $u3d_prj_path/$u3d_prj_name/Assets/Editor/Scripts/$dot_prj_name_stage1*
    else
        DotBuild $dot_prj_path/$dot_prj_name_stage0 $dot_prj_name_stage0.csproj $dot_out_path
        DotDLLsSrc2Dst $dot_out_path $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins $dot_prj_name_stage0 true
        u3d_amend_dlls
    fi

    UnityExecuteMethod \
    $u3d_prj_path/$u3d_prj_name \
    com.wolfired.dot_prj_stage0.U3DPackageUtils.Install --uph_i_args_package_id com.unity.ide.vscode

    if [[ ! -f $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins/$dot_prj_name_stage1.dll ]]; then
        mkdir -p $u3d_prj_path/$u3d_prj_name/Assets/Editor/Scripts/$dot_prj_name_stage1
        cp -v -u $dot_prj_path/$dot_prj_name_stage1/src/*.cs $u3d_prj_path/$u3d_prj_name/Assets/Editor/Scripts/$dot_prj_name_stage1
    else
        DotBuild $dot_prj_path/$dot_prj_name_stage1 $dot_prj_name_stage1.csproj $dot_out_path
        DotDLLsSrc2Dst $dot_out_path $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins $dot_prj_name_stage1 true
        u3d_amend_dlls
    fi

    UnityExecuteMethod \
    $u3d_prj_path/$u3d_prj_name \
    com.wolfired.dot_prj_stage1.CodeEditorHelper.GenU3DProjectFiles

    rm -rf $u3d_prj_path/$u3d_prj_name/Assets/Editor/Scripts/$dot_prj_name_stage0*
    rm -rf $u3d_prj_path/$u3d_prj_name/Assets/Editor/Scripts/$dot_prj_name_stage1*

    DotProjectNew $dot_sln_path $dot_sln_name classlib "netstandard2.0" $dot_prj_path/$dot_prj_name_stage0
    if [[ 0 -eq $? ]]; then
        u3dot_converter \
        --cfsrc $u3d_prj_path/$u3d_prj_name/Assembly-CSharp-Editor.csproj \
        --nssrc 'http://schemas.microsoft.com/developer/msbuild/2003' \
        --cfdst $dot_prj_path/$dot_prj_name_stage0/$dot_prj_name_stage0.csproj \
        --skips 'Assembly-CSharp.csproj'
    fi
    if [[ ! -f "$dot_out_path $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins/$dot_prj_name_stage0.dll" ]]; then
        DotBuild $dot_prj_path/$dot_prj_name_stage0 $dot_prj_name_stage0.csproj $dot_out_path
        DotDLLsSrc2Dst $dot_out_path $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins $dot_prj_name_stage0 true
    fi

    DotProjectNew $dot_sln_path $dot_sln_name classlib "netstandard2.0" $dot_prj_path/$dot_prj_name_stage1
    if [[ 0 -eq $? ]]; then
        DotProjectAddReference $dot_prj_path/$dot_prj_name_stage1 $dot_prj_path/$dot_prj_name_stage0

        u3dot_converter \
        --cfsrc $u3d_prj_path/$u3d_prj_name/Assembly-CSharp-Editor.csproj \
        --nssrc 'http://schemas.microsoft.com/developer/msbuild/2003' \
        --cfdst $dot_prj_path/$dot_prj_name_stage1/$dot_prj_name_stage1.csproj \
        --skips 'Assembly-CSharp.csproj'
    fi
    if [[ ! -f "$dot_out_path $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins/$dot_prj_name_stage1.dll" ]]; then
        DotBuild $dot_prj_path/$dot_prj_name_stage1 $dot_prj_name_stage1.csproj $dot_out_path
        DotDLLsSrc2Dst $dot_out_path $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins $dot_prj_name_stage1 true
    fi
}
if (( 0 != $setp_prepare_stage )); then
    setp_prepare_stage
fi

function step_create_dotnet_prj() {
    DotProjectNew $dot_sln_path $dot_sln_name classlib "netstandard2.0" $dot_prj_path/$dot_prj_name_core
    if [[ 0 -eq $? ]]; then
        u3dot_converter \
        --cfsrc $u3d_prj_path/$u3d_prj_name/Assembly-CSharp.csproj \
        --nssrc 'http://schemas.microsoft.com/developer/msbuild/2003' \
        --cfdst $dot_prj_path/$dot_prj_name_core/$dot_prj_name_core.csproj
    fi

    readarray -td, arr_dot_prj_name_mod <<< "$dot_prj_name_mods"
    for dot_prj_name_mod in ${arr_dot_prj_name_mod[@]}; do
        DotProjectNew $dot_sln_path $dot_sln_name classlib "netstandard2.0" $dot_prj_path/$dot_prj_name_mod
        if [[ 0 -eq $? ]]; then
            DotProjectAddReference $dot_prj_path/$dot_prj_name_mod $dot_prj_path/$dot_prj_name_core

            u3dot_converter \
            --cfsrc $u3d_prj_path/$u3d_prj_name/Assembly-CSharp.csproj \
            --nssrc 'http://schemas.microsoft.com/developer/msbuild/2003' \
            --cfdst $dot_prj_path/$dot_prj_name_mod/$dot_prj_name_mod.csproj
        fi
    done

    DotProjectNew $dot_sln_path $dot_sln_name classlib "netstandard2.0" $dot_prj_path/$dot_prj_name_editor
    if [[ 0 -eq $? ]]; then
        readarray -td, arr_dot_prj_name_mod <<< "$dot_prj_name_mods"
        for dot_prj_name_mod in ${arr_dot_prj_name_mod[@]}; do
            DotProjectAddReference $dot_prj_path/$dot_prj_name_editor $dot_prj_path/$dot_prj_name_mod
        done

        DotProjectAddReference $dot_prj_path/$dot_prj_name_editor $dot_prj_path/$dot_prj_name_stage1

        u3dot_converter \
        --cfsrc $u3d_prj_path/$u3d_prj_name/Assembly-CSharp-Editor.csproj \
        --nssrc 'http://schemas.microsoft.com/developer/msbuild/2003' \
        --cfdst $dot_prj_path/$dot_prj_name_editor/$dot_prj_name_editor.csproj \
        --skips 'Assembly-CSharp.csproj'
    fi
}
if (( 0 != $step_create_dotnet_prj )); then
    step_create_dotnet_prj
fi

function step_build_dotnet_prj() {
    DotBuild $dot_sln_path $dot_sln_name.sln $dot_out_path

    DotDLLsSrc2Dst $dot_out_path $u3d_prj_path/$u3d_prj_name/Assets/Plugins $dot_prj_name_core true
    DotDLLsSrc2Dst $dot_out_path $u3d_prj_path/$u3d_prj_name/Assets/Plugins $dot_prj_name_mods true

    DotDLLsSrc2Dst $dot_out_path $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins $dot_prj_name_stage0 true
    DotDLLsSrc2Dst $dot_out_path $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins $dot_prj_name_stage1 true
    DotDLLsSrc2Dst $dot_out_path $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins $dot_prj_name_editor true
}
if (( 0 != $step_build_dotnet_prj )); then
    step_build_dotnet_prj
fi

function step_create_default_scene() {
    UnityExecuteMethod \
    $u3d_prj_path/$u3d_prj_name \
    com.wolfired.dot_prj_stage1.UnityEditorHelper.CreateDefaultScene
}
if (( 0 != $step_create_default_scene )); then
    step_create_default_scene
fi

function step_build_unity_ab() {
    UnityExecuteMethod \
    $u3d_prj_path/$u3d_prj_name \
    com.wolfired.dot_prj_stage1.ABBuilder.Build
}
if (( 0 != $step_build_unity_ab )); then
    step_build_unity_ab
fi

function step_build_unity_prj() {
    rm -rf $u3d_out_path
    mkdir -p $u3d_out_path

    u3d_amend_dlls

    UnityExecuteMethod \
    $u3d_prj_path/$u3d_prj_name \
    $u3d_prj_builder_script --builder_args_outfile $u3d_out_file
}
if (( 0 != $step_build_unity_prj )); then
    step_build_unity_prj
fi

function step_upload() {
    local name=${u3d_out_file_name%%.*}
    local suffix=${u3d_out_file_name##*.}
    if [[ "exe" == $suffix ]]; then
        if type "7z" &> /dev/null; then
            7z a -tzip $name $u3d_out_path/*
        else
            echo "you need 7z to zip the $u3d_out_path"
        fi
        scp_upload $name.zip 1
    else
        scp_upload $u3d_out_file
    fi
}
if (( 0 != $step_upload )); then
    step_upload
fi

function step_zipprj() {
    step_clean_clear 0

    local name=`basename $root_path`

    if type "7z" &> /dev/null; then
        7z a -tzip $name $root_path/*
    else
        echo "you need 7z to zip the $u3d_out_path"
    fi
}
if (( 0 != $step_zipprj )); then
    step_zipprj
fi
