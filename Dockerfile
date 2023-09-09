FROM alpine:latest

RUN    apk update \
    && apk add wireguard-tools-wg-quick iptables socat


COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

VOLUME /config

EXPOSE 5555/udp
CMD ["/entrypoint.sh"]