function UnityCreateProject() {
    local path_prj=${1:?'need u3d prj path'}

    if [[ -d $path_prj/ProjectSettings || -d $path_prj/UserSettings || -d $path_prj/Library ]]; then
        printf '%48s: %s\n' 'u3d prj already exist' $path_prj
        return
    fi

    printf '%48s: %s\n' 'creating u3d prj' $path_prj

    mkdir -p $(dirname $path_prj)
    mkdir -p $path_prj/Assets/Plugins
    mkdir -p $path_prj/Assets/Scripts
    mkdir -p $path_prj/Assets/Editor/Plugins
    mkdir -p $path_prj/Assets/Editor/Scripts

cat <<EOF > $path_prj/Assets/Scripts/Placeholder.cs
// placeholder for Unity auto generate project file
EOF

cat <<EOF > $path_prj/Assets/Editor/Scripts/Placeholder.cs
// placeholder for Unity auto generate project file
EOF

    $unity_cmd -quit -createProject $path_prj

    local err=$?
    if (( 0 != $err )); then
        printf '%48s: %s, error code: \n' 'create u3d prj failure' $path_prj $err
        return
    fi

    printf '%48s: %s\n' 'create u3d prj success' $path_prj
}

function UnityExecuteMethod() {
    local path_prj=${1:?'need u3d prj path'}
    local method=${2:?'need execute method'}

    if [[ ! -d $path_prj ]]; then
        printf '%48s: %s, method: \n' 'nothing to execute, u3d prj path not exist' $path_prj $method
        return
    fi

    printf '%48s: %s\n' 'executing method' $method

    $unity_cmd -projectPath $path_prj -executeMethod $method ${@:3}

    local err=$?
    if (( 0 != $err )); then
        printf '%48s: %s, error code: %s\n' 'execute method failure' $method $err
        exit $err
    fi

    printf '%48s: %s\n' 'execute method success' $method
}
