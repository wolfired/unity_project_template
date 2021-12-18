function UnityCreateProject() {
    local path_prj=${1:?"<U3D项目路径>"}

    if [[ -d $path_prj/ProjectSettings || -d $path_prj/UserSettings || -d $path_prj/Library ]]; then
        echo "U3D项目已存在, 无须创建: $path_prj"
        return 1
    fi

    echo "正在创建U3D项目: $path_prj"

    mkdir -p $(dirname $path_prj)
    mkdir -p $path_prj/Assets/Plugins
    mkdir -p $path_prj/Assets/Scripts
    mkdir -p $path_prj/Assets/Editor/Plugins
    mkdir -p $path_prj/Assets/Editor/Scripts

cat <<EOF > $path_prj/Assets/Scripts/Placeholder.cs
// 占位文件, 让Unity自动生成工程文件
EOF

cat <<EOF > $path_prj/Assets/Editor/Scripts/Placeholder.cs
// 占位文件, 让Unity自动生成工程文件
EOF

    Unity -quit -createProject $path_prj

    local err=$?
    if (( 0 == $err )); then
        echo "成功创建U3D项目: $path_prj"
    else
        echo "创建U3D项目失败, 错误码: $err"
        return 1
    fi

    return 0
}

function UnityExecuteMethod() {
    local path_prj=${1:?"<U3D项目路径>"}
    local method=${2:?"<执行命令>"}

    mkdir -p $(dirname $file_log)

    if [[ ! -d $path_prj ]]; then
        echo "U3D项目不存在, 无法执行命令: $path_prj -> $method"
        return
    fi

    echo "正在执行命令: $method"

    # -quit
    Unity -projectPath $path_prj -executeMethod $method ${@:4}

    local err=$?
    if (( 0 == $err )); then
        echo "成功执行命令: $method"
    else
        echo "执行命令失败, 错误码: $err"
    fi
}
