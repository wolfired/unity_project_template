function DotSolutionNew() {
    local path_sln=${1:?'need dotnet sln path'}
    local name_sln=${2:?'need dotnet sln name'}

    if [[ -f $path_sln/$name_sln.sln ]]; then
        printf '%48s: %s\n' 'dotnet sln already exist' $path_sln/$name_sln.sln
        return
    fi

    mkdir -p $(dirname $path_sln)

    printf '%48s: %s\n' 'creating dotnet sln' $path_sln/$name_sln.sln
    dotnet new sln -o $path_sln -n $name_sln
    printf '%48s: %s\n' 'created dotnet sln' $path_sln/$name_sln.sln
}

function DotSolutionDelete() {
    local path_sln=${1:?'need dotnet sln path'}
    local name_sln=${2:?'need dotnet sln name'}
    local path_sln_out_path=${3:-} # dotnet sln out path

    if [[ -d $path_sln ]]; then
        printf '%48s: %s\n' 'deleting dotnet sln' $path_sln/$name_sln.sln
        rm -rf $path_sln/*.sln
        printf '%48s: %s\n' 'deleted dotnet sln' $path_sln/$name_sln.sln
    else
        printf '%48s: %s\n' 'nothing to delete, dotnet sln not exist' $path_sln/$name_sln.sln
    fi

    if [[ -d $path_sln_out_path ]]; then
        printf '%48s: %s\n' 'deleting dotnet sln out path' $path_sln_out_path
        rm -rf $path_sln_out_path
        printf '%48s: %s\n' 'deleted dotnet sln out path' $path_sln_out_path
    else
        printf '%48s: %s\n' 'nothing to delete, dotnet sln out path not exist' $path_sln_out_path
    fi
}

function DotSolutionClean() {
    local path_sln=${1:?'need dotnet sln path'}
    local name_sln=${2:?'need dotnet sln name'}
    local path_sln_out_path=${3:-} # dotnet sln out path

    if [[ -d $path_sln && -d $path_sln_out_path ]]; then
        printf '%48s: %s\n' 'cleaning dotnet sln' $path_sln_out_path
        dotnet clean -o $path_sln_out_path $path_sln
        printf '%48s: %s\n' 'cleaned dotnet sln' $path_sln_out_path
    elif [[ -d $path_sln ]]; then
        printf '%48s: %s\n' 'cleaning dotnet sln' $path_sln/$name_sln.sln
        dotnet clean $path_sln
        printf '%48s: %s\n' 'cleaned dotnet sln' $path_sln/$name_sln.sln
    else
        printf '%48s: %s\n' 'nothing to clean, dotnet sln not exist' $path_sln/$name_sln.sln
    fi
}

function DotProjectNew() {
    local path_sln=${1:?'need dotnet sln path'}
    local name_sln=${2:?'need dotnet sln name'}
    local type_prj=${3:?'need dotnet prj type, classlib | console'}
    local framework_prj=${4:?'need dotnet framework, netstandard2.0 | net5.0'}
    local path_prj=${5:?'need dotnet prj path'}

    local name_prj=$(basename $path_prj)

    if [[ -f $path_prj/$name_prj.csproj ]]; then
        printf '%48s: %s\n' 'dotnet prj already exist' $path_prj
        return 1
    fi

    mkdir -p $(dirname $path_prj)

    dotnet new $type_prj --framework $framework_prj --force -o $path_prj -n $name_prj

    rm -rf $path_prj/*.cs

    mkdir -p $path_prj/src

    if [[ "classlib" == $type_prj && ! -f $path_prj/src/Lib.cs ]]; then
cat <<EOF > $path_prj/src/Lib.cs
using System;

namespace com.wolfired.$name_prj {
    public class Lib { }
}
EOF
    elif [[ 'console' == $type_prj && ! -f $path_prj/src/Main.cs ]]; then
cat <<EOF > $path_prj/src/Main.cs
using System;

namespace com.wolfired.$name_prj
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
        }
    }
}
EOF
    fi

    dotnet sln $path_sln/$name_sln.sln add $path_prj

    return 0
}

function DotProjectAddPackage() {
    local path_prj=${1:?'need dotnet prj path'}
    local package_name=${2:?'need package name'}
    local package_version=${3:?'need package version'}

    dotnet add $path_prj package -v $package_version $package_name
}

function DotProjectAddPackages() {
    local path_prj=${1:?'need dotnet prj path'}
    local package_names=${2:-""} # pack_name0,pack_name1,pacak_name2

    if [[ ! -n $package_names || -z $package_names ]]; then
        return
    fi

    readarray -td, arr_package_name <<<"$package_names,"
    unset 'arr_package_name[-1]'
    for package_name in "${arr_package_name[@]}"; do
        dotnet add $path_prj package $package_name
    done
}

function DotProjectAddReference() {
    local path_prj=${1:?'need dotnet prj path'}
    local path_prj_depeds=${2:?"need dotnet prj path list"} # prj_path0,prj_path1,prj_path2

    readarray -td, arr_path_prj_deped <<<"$path_prj_depeds,"
    unset 'arr_path_prj_deped[-1]'
    for path_prj_deped in "${arr_path_prj_deped[@]}"; do
        dotnet add $path_prj reference $path_prj_deped
    done
}

function DotProjectDelete() {
    local path_prj=${1:?'need dotnet prj path'}

    if [[ ! -d $path_prj ]]; then
        printf '%48s: %s\n' 'nothing to delete, dotnet prj not exist' $path_prj
        return
    fi

    printf '%48s: %s\n' 'deleting dotnet prj' $path_prj
    rm -rf $path_prj/bin $path_prj/obj $path_prj/*.csproj
    printf '%48s: %s\n' 'deleted dotnet prj' $path_prj
}

function DotProjectClean() {
    local path_prj=${1:?'need dotnet prj path'}

    if [[ ! -d $path_prj ]]; then
        printf '%48s: %s\n' 'nothing to clean, dotnet prj not exist' $path_prj
        return
    fi

    printf '%48s: %s\n' 'cleaning dotnet prj' $path_prj
    dotnet clean $path_prj
    printf '%48s: %s\n' 'cleaned dotnet prj' $path_prj
}

function DotBuild() {
    local path_sln_or_prj=${1:?'need dotnet sln/prj path'}
    local name_sln_or_prj=${2:?'need dotnet sln/prj name'}
    local path_out=${3:-} # dotnet project out path

    if [[ -n $path_out && ! -d $path_out ]]; then
        mkdir -p $path_out
    fi

    if [[ -d $path_sln_or_prj && -d $path_out ]]; then
        printf '%48s: %s\n' 'building dotnet sln' $path_sln_or_prj/$name_sln_or_prj
        dotnet build -o $path_out $path_sln_or_prj/$name_sln_or_prj
        printf '%48s: %s\n' 'built dotnet sln' $path_sln_or_prj/$name_sln_or_prj
    elif [[ -d $path_sln_or_prj ]]; then
        printf '%48s: %s\n' 'building dotnet sln' $path_sln_or_prj/$name_sln_or_prj
        dotnet build $path_sln_or_prj/$name_sln_or_prj
        printf '%48s: %s\n' 'built dotnet sln' $path_sln_or_prj/$name_sln_or_prj
    else
        printf '%48s: %s\n' 'nothing to build, dotnet sln not exist' $path_sln_or_prj/$name_sln_or_prj
    fi
}

function DotDLLsSrc2Dst() {
    local path_src=${1:?'need dlls src path'}
    local path_dst=${2:?'need dlls dst path'}
    local name_dlls=${3:?'need dll list'} # mod0,mod1,mod2
    local need_copy_pdb=${4:?'need copy pdb file, true | false'}

    readarray -td, arr_name_dll <<<"$name_dlls,"
    unset 'arr_name_dll[-1]'
    for name_dll in "${arr_name_dll[@]}"; do
        cp -v -u $path_src/$name_dll.dll $path_dst/
        if [[ 'true' == $need_copy_pdb ]]; then
            cp -v -u $path_src/$name_dll.pdb $path_dst/
        fi
    done
}
