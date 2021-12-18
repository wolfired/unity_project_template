#!/bin/env bash

root_path=$(dirname $0)

source $root_path/libdot.sh
source $root_path/libunity.sh

unity_path=${unity_path:-/d/Unity.2021.2.0a21/Editor}
unity_exe_file=${unity_exe_file:-$unity_path/Unity.exe}
unity_log_file=${unity_log_file:--}
unity_out_path=${unity_out_path:-$root_path/out}

dotnet_out_path=${dotnet_out_path:-$root_path/bin}

if [[ ! -d $unity_path || ! -f $unity_exe_file ]]; then
    exit 0
fi

# -batchmode -nographics
alias unity="$unity_exe_file -logFile $unity_log_file -batchmode -nographics"

echo 'The Unity Version:'
unity_version=$(unity -quit -version)
echo

unity_alf_file=${unity_alf_file:-Unity_v`echo $unity_version | grep -oP '^\d+\.\d+.[0-9a-z]+'`.alf}

if [[ ! -f $root_path/$unity_alf_file ]]; then
    unity -createManualActivationFile
fi

unity_ulf_file=${unity_ulf_file:-Unity_v`echo $unity_version | grep -oP '^\d+'`.x.ulf}

if [[ ! -f $root_path/$unity_ulf_file ]]; then
    echo "You need the $unity_ulf_file"
    exit 0
fi

if [[ 0 -eq $(dotnet tool list -g | grep -oP 'wolfired.u3dot_converter' | wc -l) ]]; then
    dotnet tool install -g wolfired.u3dot_converter
fi

u3d_prj_path=$root_path
u3d_prj_name=slg_u3d
UnityCreateProject $u3d_prj_path/$u3d_prj_name

dot_sln_path=$root_path
dot_sln_name=slg_dot
DotSolutionNew $dot_sln_path $dot_sln_name

dot_prj_path=$root_path

dot_prj_name_core=slg_dot_core
DotProjectNew $dot_sln_path classlib "netstandard2.0" $dot_prj_path/$dot_prj_name_core
if [[ 0 -eq $? ]]; then
    u3dot_converter \
    --cfsrc $u3d_prj_path/$u3d_prj_name/Assembly-CSharp.csproj \
    --nssrc 'http://schemas.microsoft.com/developer/msbuild/2003' \
    --cfdst $dot_prj_path/$dot_prj_name_core/$dot_prj_name_core.csproj
fi

dot_prj_names=slg_dot_bag,slg_dot_chat
readarray -td, arr_dot_prj_name <<<"$dot_prj_names,"
unset 'arr_dot_prj_name[-1]'
for dot_prj_name in "${arr_dot_prj_name[@]}"; do
    DotProjectNew $dot_sln_path classlib "netstandard2.0" $dot_prj_path/$dot_prj_name
    if [[ 0 -eq $? ]]; then
        DotProjectAddReference $dot_prj_path/$dot_prj_name $dot_prj_path/$dot_prj_name_core

        u3dot_converter \
        --cfsrc $u3d_prj_path/$u3d_prj_name/Assembly-CSharp.csproj \
        --nssrc 'http://schemas.microsoft.com/developer/msbuild/2003' \
        --cfdst $dot_prj_path/$dot_prj_name/$dot_prj_name.csproj
    fi
done

dot_prj_name_editor=slg_dot_editor
DotProjectNew $dot_sln_path classlib "netstandard2.0" $dot_prj_path/$dot_prj_name_editor
if [[ 0 -eq $? ]]; then
    DotProjectAddPackages $dot_prj_path/$dot_prj_name_editor Mono.Options
    DotProjectAddReference $dot_prj_path/$dot_prj_name_editor $dot_prj_path/$dot_prj_name_core

    readarray -td, arr_dot_prj_name <<<"$dot_prj_names,"
    unset 'arr_dot_prj_name[-1]'
    for dot_prj_name in "${arr_dot_prj_name[@]}"; do
        DotProjectAddReference $dot_prj_path/$dot_prj_name_editor $dot_prj_path/$dot_prj_name
    done

    u3dot_converter \
    --cfsrc $u3d_prj_path/$u3d_prj_name/Assembly-CSharp-Editor.csproj \
    --nssrc 'http://schemas.microsoft.com/developer/msbuild/2003' \
    --cfdst $dot_prj_path/$dot_prj_name_editor/$dot_prj_name_editor.csproj \
    --skips 'Assembly-CSharp.csproj'
fi

DotBuild $dot_sln_path $dotnet_out_path
DotDLLsSrc2Dst $dotnet_out_path $u3d_prj_path/$u3d_prj_name/Assets/Plugins $dot_prj_name_core true
DotDLLsSrc2Dst $dotnet_out_path $u3d_prj_path/$u3d_prj_name/Assets/Plugins $dot_prj_names true
DotDLLsSrc2Dst $dotnet_out_path $u3d_prj_path/$u3d_prj_name/Assets/Editor/Plugins $dot_prj_name_editor true

# -quit
unity -quit -projectPath $u3d_prj_path/$u3d_prj_name -buildTarget Win -buildWindowsPlayer $unity_out_path/out/out.exe
