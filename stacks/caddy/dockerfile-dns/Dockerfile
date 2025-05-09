ARG VERSION=2

FROM caddy:${VERSION}-builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare

FROM alpine:3.20

# Debugging-Tools installieren
RUN apk add --no-cache \
    bash \
    curl \
    iputils \
    bind-tools \
    ca-certificates \
    vim \
    net-tools

# Caddy kopieren
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# Start-Skript kopieren
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Caddy Standard-Verzeichnisse
RUN mkdir -p /etc/caddy /data /config

EXPOSE 80 443 443/udp

# Start über Script
ENTRYPOINT ["/start.sh"]
