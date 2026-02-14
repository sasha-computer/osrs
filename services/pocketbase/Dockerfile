FROM alpine:3.20

ARG PB_VERSION=0.36.3

RUN apk add --no-cache ca-certificates unzip wget

RUN wget -q https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip -O /tmp/pb.zip \
    && unzip /tmp/pb.zip -d /usr/local/bin/ \
    && rm /tmp/pb.zip \
    && chmod +x /usr/local/bin/pocketbase

# Copy migrations for schema setup
COPY pb_migrations /pb_migrations

EXPOSE 8080

CMD ["pocketbase", "serve", "--http=0.0.0.0:8080", "--dir=/pb_data", "--migrationsDir=/pb_migrations"]
