# https://code.visualstudio.com/remote/advancedcontainers/reduce-docker-warnings
# https://github.com/game-ci/docker/blob/main/images/ubuntu/base/Dockerfile
# https://github.com/game-ci/docker/blob/main/images/ubuntu/hub/Dockerfile
# https://github.com/game-ci/docker/blob/main/images/ubuntu/editor/Dockerfile
# https://forum.unity.com/threads/unity-on-linux-release-notes-and-known-issues.350256/
# https://forum.unity.com/threads/bug-sln-cproj-files-no-longer-generated-on-linux-in-2018.532830/
# https://unity3d.com/get-unity/download/archive

FROM ubuntu:20.04

ARG u3d_version
ARG u3d_change_set

ENV UNITY_PATH=/opt/unity

RUN echo "3830506cd1422bb1f64556cb9d258b1c" > /etc/machine-id \
    && mkdir -p /var/lib/dbus/ \
    && ln -sf /etc/machine-id /var/lib/dbus/machine-id


RUN /bin/echo -e 'pcm.!default {\n\
    type plug\n\
    slave.pcm "null"\n\
}' > /etc/asound.conf


RUN sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list \
    && sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list \
    && export DEBIAN_FRONTEND=noninteractive \
    && echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get -q update \
    && apt-get -q install -y --no-install-recommends apt-utils dialog 2>&1 \
    && apt-get -q install -y --no-install-recommends --allow-downgrades \
                                                                        apt-transport-https \
                                                                        ca-certificates \
                                                                        gpg \
                                                                        gpg-agent \
                                                                        software-properties-common \
                                                                        wget \
                                                                        xvfb \
                                                                        atop \
                                                                        curl \
                                                                        git \
                                                                        git-lfs \
                                                                        openssh-client \
                                                                        subversion \
                                                                        cifs-utils \
                                                                        p7zip-full \
                                                                        jq \
                                                                        vim \
    && apt-get -q install -y --no-install-recommends --allow-downgrades libasound2 \
                                                                        gnupg \
                                                                        libgbm1 \
                                                                        zenity \
                                                                        libxshmfence1 \
                                                                        cpio \
                                                                        libc6-dev \
                                                                        libcap2 \
                                                                        libgconf-2-4 \
                                                                        libglu1 \
                                                                        libgtk-3-0 \
                                                                        libncurses5 \
                                                                        libnotify4 \
                                                                        libnss3 \
                                                                        libxtst6 \
                                                                        libxss1 \
                                                                        lsb-release \
                                                                        python \
                                                                        python-setuptools \
                                                                        xz-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Install Deps: gpg gpg-agent wget software-properties-common
# Runtime Deps: libasound2 libxshmfence1 xvfb
RUN export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn \
    && wget -qO - https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && add-apt-repository 'deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main' \
    && apt-get -q install -y --no-install-recommends code \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mv /bin/code /bin/code.bak \
    && echo 'xvfb-run -ae /dev/stdout /usr/share/code/bin/code --no-sandbox --user-data-dir /tmp $@' > /bin/code \
    && chmod 755 /bin/code \
    && echo 'export VSCODE_CMD=/bin/code' >> /root/.bashrc


# Install Deps: gpg gpg-agent wget software-properties-common
# Runtime Deps:
RUN wget -qO - https://dot.net/v1/dotnet-install.sh | bash -s - --channel 5.0 \
    && echo 'export DOTNET_ROOT=/root/.dotnet' >> /root/.bashrc \
    && echo 'export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools' >> /root/.bashrc \
    && export DOTNET_ROOT=/root/.dotnet \
    && export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools \
    && dotnet tool install -g wolfired.u3dot_converter


# Install Deps: gpg gpg-agent wget software-properties-common
# Runtime Deps: gnupg libgbm1 xvfb zenity
RUN export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn \
    && wget -qO - https://hub.unity3d.com/linux/keys/public | apt-key add - \
    && add-apt-repository 'deb [arch=amd64] https://hub.unity3d.com/linux/repos/deb stable main' \
    && apt-get -q install -y --no-install-recommends unityhub=3.1.1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo 'xvfb-run -ae /dev/stdout /opt/unityhub/unityhub-bin --no-sandbox --headless $@' > /usr/bin/unity-hub \
    && chmod 755 /usr/bin/unity-hub


# Install Deps: ...
RUN mkdir -p $UNITY_PATH/editors \
    && unity-hub ip -s $UNITY_PATH/editors \
    && unity-hub i -v $u3d_version -c $u3d_change_set | tee /var/log/install-editor.log

RUN unity-hub im -v $u3d_version -m windows-mono --cm | tee /var/log/install-module-windows-mono.log

RUN unity-hub im -v $u3d_version -m android --cm | tee /var/log/install-module-android.log

RUN chmod -R 755 $UNITY_PATH/editors/$u3d_version/Editor/Data/PlaybackEngines \
    && mv $UNITY_PATH/editors/$u3d_version/* $UNITY_PATH/ \
    && echo 'xvfb-run -ae /dev/stdout $UNITY_PATH/Editor/Unity $@' > /usr/bin/unity-editor \
    && chmod 755 /usr/bin/unity-editor

RUN export RAW_ANDROID_SDK_ROOT=$(jq -cr '(.[] | select(.id == "android-sdk-platform-tools")).destination' $UNITY_PATH/modules.json) \
    && export ESCAPED_UNITY_PATH=$(printf '%s' "$UNITY_PATH" | sed 's/[#\/]/\\\0/g') \
    && export ANDROID_SDK_ROOT=$(echo $RAW_ANDROID_SDK_ROOT | sed -e "s/{UNITY_PATH}/$ESCAPED_UNITY_PATH/g") \
    && export ANDROID_HOME=$ANDROID_SDK_ROOT \
    && export RAW_ANDROID_NDK_ROOT=$(jq -cr '(.[] | select(.id == "android-ndk")).destination' $UNITY_PATH/modules.json) \
    && export ANDROID_NDK_HOME=$(echo $RAW_ANDROID_NDK_ROOT | sed -e "s/{UNITY_PATH}/$ESCAPED_UNITY_PATH/g") \
    && export RAW_JAVA_HOME=$(jq -cr '(.[] | select(.id == "android-open-jdk")).destination' $UNITY_PATH/modules.json) \
    && export ESCAPED_JAVA_HOME=$(echo $RAW_JAVA_HOME | sed -e "s/{UNITY_PATH}/$ESCAPED_UNITY_PATH/g") \
    && export JAVA_HOME=${ESCAPED_JAVA_HOME:-$UNITY_PATH/Editor/Data/PlaybackEngines/AndroidPlayer/Tools/OpenJDK/Linux} \
    && yes | "$ANDROID_HOME/tools/bin/sdkmanager" --licenses \
    && "$ANDROID_HOME/tools/bin/sdkmanager" --list >> "$ANDROID_HOME/tools/bin/sdkversion.txt" \
    && sed -i '2s/^/exit 0\n/' "$ANDROID_HOME/tools/bin/sdkmanager" \
    && sed -i '2s/^/cat $ANDROID_HOME\/tools\/bin\/sdkversion.txt\n/' "$ANDROID_HOME/tools/bin/sdkmanager" \
    && sed -i 's/google()/maven { url "https:\/\/maven.aliyun.com\/repository\/jcenter" }\n\tmaven { url "https:\/\/maven.aliyun.com\/repository\/google" }/' \
               $UNITY_PATH/Editor/Data/PlaybackEngines/AndroidPlayer/Tools/GradleTemplates/baseProjectTemplate.gradle \
    && sed -i 's/jcenter()/maven { url "https:\/\/maven.aliyun.com\/repository\/central" }\n\tmaven { url "https:\/\/maven.aliyun.com\/repository\/gradle-plugin" }\n/' \
               $UNITY_PATH/Editor/Data/PlaybackEngines/AndroidPlayer/Tools/GradleTemplates/baseProjectTemplate.gradle \
    && echo "export ANDROID_SDK_ROOT=$ANDROID_SDK_ROOT" >> /root/.bashrc \
    && echo "export ANDROID_HOME=$ANDROID_HOME" >> /root/.bashrc \
    && echo "export ANDROID_NDK_HOME=$ANDROID_NDK_HOME" >> /root/.bashrc \
    && echo "export JAVA_HOME=$JAVA_HOME" >> /root/.bashrc \
    && echo "export PATH=\$PATH:\$JAVA_HOME/bin:\$ANDROID_SDK_ROOT/tools:\$ANDROID_SDK_ROOT/tools/bin:\$ANDROID_SDK_ROOT/platform-tools" >> /root/.bashrc
