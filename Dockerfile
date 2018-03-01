FROM arris/docker-android-sdk:latest

ARG HOST_IP=host.docker.internal
ARG HOST_USER=arris
ARG APT_PACKAGES='gradle' 
ARG DEBIAN_FRONTEND=noninteractive
ENV PATH="/opt/google/flutter/bin:${PATH}"

RUN \
    # Apt Packages
    apt-get update -y \
        && apt-get install -yq ${APT_PACKAGES} \
        && apt-get clean \
    # Flutter
    && mkdir -p /opt/google \
        && cd /opt/google \
        && git clone -b beta https://github.com/flutter/flutter.git flutter \
        && cd flutter \
        && flutter config --no-analytics \
        && flutter config --gradle-dir $(which gradle) \
        && flutter doctor

COPY config/ssh/ /root/.ssh
RUN ssh -4 -f ${HOST_USER}@${HOST_IP} -L 5554:localhost:5554 -N -o StrictHostKeyChecking=no \
     && ssh -4 -f ${HOST_USER}@${HOST_IP} -L 5555:localhost:5555 -N -o StrictHostKeyChecking=no

EXPOSE 5554 5555 8081 
COPY config/supervisor/app.conf /etc/supervisor/conf.d/app.conf
CMD /usr/bin/supervisord -c /etc/supervisor/conf.d/app.conf

