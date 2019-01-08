# TODO alpine
FROM ubuntu

# TODO change
EXPOSE 8080

# Set correct environment variables.
ENV HOME=/root \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    net-tools \
    python \
    supervisor \
    wget \
    x11vnc \
    xvfb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download and install noVNC.
RUN mkdir -p /opt/noVNC/utils/websockify \
    && wget -qO- "http://github.com/kanaka/noVNC/tarball/master" \
    | tar -zx --strip-components=1 -C /opt/noVNC \
    && wget -qO- "https://github.com/kanaka/websockify/tarball/master" \
    | tar -zx --strip-components=1 -C /opt/noVNC/utils/websockify \
    && ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

# Install some additins.
# TODO use openbox, remove chromium, change font
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    fluxbox \
    chromium-browser \
    fonts-takao-gothic \
    mozc-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY novnc.conf /etc/supervisor/conf.d/novnc.conf
CMD ["/usr/bin/supervisord"]
