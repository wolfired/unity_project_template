# https://code.visualstudio.com/remote/advancedcontainers/reduce-docker-warnings
# https://github.com/game-ci/docker/blob/main/images/ubuntu/base/Dockerfile
# https://github.com/game-ci/docker/blob/main/images/ubuntu/hub/Dockerfile
# https://github.com/game-ci/docker/blob/main/images/ubuntu/editor/Dockerfile
# https://forum.unity.com/threads/unity-on-linux-release-notes-and-known-issues.350256/

FROM ubuntu:20.04


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
    && echo 'xvfb-run -ae /dev/stdout /usr/share/code/bin/code --no-sandbox --user-data-dir /tmp $@' > /usr/bin/vscode \
    && chmod 755 /usr/bin/vscode \
    && echo 'export VSCODE_CMD=/usr/bin/vscode' >> /root/.bashrc


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
    && apt-get -q install -y --no-install-recommends unityhub=3.0.0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo 'xvfb-run -ae /dev/stdout /opt/unityhub/unityhub-bin --no-sandbox --headless $@' > /usr/bin/unity-hub \
    && chmod 755 /usr/bin/unity-hub


# Install Deps: ...
RUN mkdir -p /opt/unity/editors \
    && unity-hub ip -s /opt/unity/editors \
    && unity-hub i -v 2021.2.17f1 -c efb8f635e7b1 | tee /var/log/install-editor.log \
    && unity-hub im -v 2021.2.17f1 -m windows-mono --cm | tee /var/log/install-module-windows-mono.log \
    && unity-hub im -v 2021.2.17f1 -m android --cm | tee /var/log/install-module-android.log \
    && chmod -R 755 /opt/unity/editors/2021.2.17f1/Editor/Data/PlaybackEngines \
    && mv /opt/unity/editors/2021.2.17f1/* /opt/unity/ \
    && echo 'xvfb-run -ae /dev/stdout /opt/unity/Editor/Unity $@' > /usr/bin/unity-editor \
    && chmod 755 /usr/bin/unity-editor
