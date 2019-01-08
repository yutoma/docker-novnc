# TODO alpine
FROM ubuntu:bionic
# TODO change font
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    fonts-takao-gothic \
    locales \
    lxterminal \
    mozc-server \
    net-tools \
    obconf \
    openbox \
    python \
    supervisor \
    wget \
    x11vnc \
    xvfb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# locale and timezone
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    TZ=Asia/Tokyo
# noVNC
RUN mkdir -p /opt/noVNC/utils/websockify \
    && wget -nv -O - "https://github.com/novnc/noVNC/archive/v1.0.0.tar.gz" \
    | tar zx --strip-components=1 -C /opt/noVNC \
    && wget -nv -O - "https://github.com/novnc/websockify/archive/v0.8.0.tar.gz" \
    | tar zx --strip-components=1 -C /opt/noVNC/utils/websockify \
    && ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html
# start daemons
ENV DISPLAY=:0 \
    RESOLUTION=1200x900x24
EXPOSE 6080
COPY novnc.conf /etc/supervisor/conf.d/novnc.conf
CMD ["/usr/bin/supervisord"]
