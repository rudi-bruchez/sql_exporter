FROM quay.io/prometheus/golang-builder AS builder

# Get sql_exporter
ADD .   /go/src/github.com/free/sql_exporter
WORKDIR /go/src/github.com/free/sql_exporter

# Do makefile
RUN make

# Make image and copy build sql_exporter
FROM        quay.io/prometheus/busybox:glibc
MAINTAINER  The Prometheus Authors <prometheus-developers@googlegroups.com>
COPY        --from=builder /go/src/github.com/free/sql_exporter/sql_exporter  /bin/sql_exporter

# rudi
RUN mkdir -p /etc/sql_exporter

COPY examples/sql_exporter.yml /etc/sql_exporter/sql_exporter.yml
COPY examples/mssql_standard.collector.yml /etc/sql_exporter/mssql_standard.collector.yml
COPY examples/mssql_alwayson.collector.yml /etc/sql_exporter/mssql_alwayson.collector.yml

EXPOSE      9399
ENTRYPOINT  [ "/bin/sql_exporter", "-config.file=/etc/sql_exporter/sql_exporter.yml" ]
