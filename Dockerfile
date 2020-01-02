FROM anapsix/alpine-java:8_jdk
LABEL maintainer="Shreejan Shrestha <shr3jn@gmail.com>"

ENV LC_ALL "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"
ENV LANG "en_US.UTF-8"

ENV VERSION_SDK_TOOLS "3859397"
ENV VERSION_BUILD_TOOLS "28.0.3"
ENV VERSION_TARGET_SDK "28"

ENV ANDROID_HOME "/sdk"
ENV NDK_ROOT "/sdk/ndk-bundle"

ENV PATH "$PATH:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools"
ENV DEBIAN_FRONTEND noninteractive

ENV HOME "/root"

RUN apk update && apk add --no-cache \
#    bash \
#    perl \
     curl \
     unzip \
     zip \
    git \
    ruby \
    ruby-dev \
    ruby-rdoc \
    ruby-irb \
    grep \
#    clang \
     openssh \
#    openssh-server \
     openssh-client \
     g++ \
     make \
#    cmake \
#    "ninja>1.9.0-r0" \
     nodejs \
     nodejs-npm \
#    python \
    && rm -rf /tmp/* /var/tmp/*

ADD https://dl.google.com/android/repository/sdk-tools-linux-${VERSION_SDK_TOOLS}.zip /tools.zip
RUN unzip /tools.zip -d /sdk && \
    rm -v /tools.zip

RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses
RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager "platforms;android-${VERSION_TARGET_SDK}"

RUN mkdir -p $HOME/.android && touch $HOME/.android/repositories.cfg
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "tools" "build-tools;${VERSION_BUILD_TOOLS}"
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository"
RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager \
        "cmake;3.6.4111459" \
        "cmake;3.10.2.4988404" \
        "ndk-bundle" >/dev/null
#RUN ${ANDROID_HOME}/tools/bin/sdkmanager "ndk-bundle"

# RUN mkdir -p $HOME/lokalise && cd $HOME/lokalise
# RUN wget -O ./inst.tgz https://s3-eu-west-1.amazonaws.com/lokalise-assets/cli/lokalise-0.44-linux-amd64.tgz
# RUN tar -xvzf ./inst.tgz
# RUN mv ./lokalise /usr/local/bin/lokalise

#fastlane_update
RUN gem install fastlane -NV
RUN gem install dotenv
RUN gem install json

# Downloading gcloud package
# RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz

# Installing the package
# RUN mkdir -p /usr/local/gcloud
# RUN tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz
# RUN /usr/local/gcloud/google-cloud-sdk/install.sh --quiet

# Adding the package path to local
# ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

RUN npm install -g plist

# ADD id_rsa $HOME/.ssh/id_rsa
# ADD id_rsa.pub $HOME/.ssh/id_rsa.pub
# ADD adbkey $HOME/.android/adbkey
# ADD adbkey.pub $HOME/.android/adbkey.pub
##
