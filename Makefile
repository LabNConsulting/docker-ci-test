SHELL := /bin/bash
MAKEDIR := $(shell realpath $(dir $(lastword $(MAKEFILE_LIST))))

export DOCKERFILE_PATH := $(MAKEDIR)/Dockerfile
export IMAGE_BASE := labn/docker-ci-test

define build-rule
	DOCKER_TAG=$(1) IMAGE_NAME=$(IMAGE_BASE):$(1) hooks/build
endef

build-2004:
	$(call build-rule,20.04)

build-1804:
	$(call build-rule,18.04)
