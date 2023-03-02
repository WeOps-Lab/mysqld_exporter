#
# build container
#
FROM --platform=linux/amd64 golang:1.19-alpine as builder
WORKDIR /

COPY mysql_exporter /mysql_exporter

EXPOSE     9121
ENTRYPOINT [ "/mysql_exporter" ]
