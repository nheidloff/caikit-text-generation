# FROM python:3.8
FROM registry.access.redhat.com/ubi8/ubi-minimal as python-min

USER root

ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1

RUN microdnf update -y
RUN microdnf --nodocs install -y python38 python38-devel 
RUN microdnf clean all

RUN ln -s /usr/bin/pip3.8 /usr/bin/pip
RUN pip install -U pip setuptools wheel

WORKDIR /usr/src/app

RUN echo "app:x:1001:1001:Default user:/usr/src/app:/bin/bash" >> /etc/passwd 

RUN chown -R 1001:0 /usr/src/app && \
    chmod -R g=u /usr/src/app

USER 1001

##############################################
FROM python-min as caikit-base

COPY requirements.txt .
RUN pip install -r requirements.txt

##############################################
ARG PYTHON_TAG=py39
ARG OS=ubi8
ARG BASE_IMAGE_TAG=latest
ARG GO_VERSION=1.19
ARG PROTOBUF_VERSION=3.15.8

FROM golang:1.19 as gateway-base

ARG PROTOBUF_VERSION
RUN true && \
    apt-get update && \
    apt-get install -y \
        unzip \
        python3.9 \
        python3-pip && \
    apt-get upgrade -y && \
    true

ARG PROTOBUF_VERSION=3.15.8
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protoc-${PROTOBUF_VERSION}-linux-x86_64.zip
RUN unzip protoc-3.15.8-linux-x86_64.zip -d /protoc
ENV PATH=${PATH}:/protoc/bin

##############################################
FROM caikit-base as build-protos

WORKDIR /app

COPY text_generation text_generation

ENV CONFIG_FILES=text_generation/config/config.yml
# generate the protos
RUN python -m caikit.runtime.dump_services protos

RUN ls -la 
RUN ls -la protos