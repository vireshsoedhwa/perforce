FROM ubuntu:24.04

WORKDIR /app

RUN set -ex; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
            ca-certificates \
            wget \
            gpg; \
        wget -qO - https://package.perforce.com/perforce.pubkey | \
        gpg --dearmor | tee /usr/share/keyrings/perforce.gpg; \
        echo "deb [signed-by=/usr/share/keyrings/perforce.gpg] https://package.perforce.com/apt/ubuntu  noble  release" \
        > /etc/apt/sources.list.d/perforce.list; \
        apt-get update; \
        apt-get install -y --no-install-recommends \
            helix-p4d;

            
COPY typemap .            
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
EXPOSE 1666
ENTRYPOINT [ "/app/entrypoint.sh" ]

CMD ["tail", "-f", "/opt/perforce/servers/gaming/logs/log"]