FROM twinproduction/gatus:v5.7.0 AS source

FROM scratch

COPY --from=source /gatus /gatus
COPY --from=source /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY GatusApp/config/config.yaml /config/config.yaml

ENV PORT=8080
ENV GATUS_CONFIG_PATH=/config/config.yaml

USER 65532:65532

EXPOSE 8080
ENTRYPOINT ["/gatus"]
