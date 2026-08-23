SHELL := /bin/bash
MAKEDIR := $(shell realpath $(dir $(lastword $(MAKEFILE_LIST))))

export DOCKERFILE_PATH := $(MAKEDIR)/Dockerfile
export IMAGE_BASE := labn/docker-ci-test

define build-rule
	DOCKER_TAG=$(1) IMAGE_NAME=$(IMAGE_BASE):$(1) DOCKER_EXTRA_ARGS=${DOCKER_EXTRA_ARGS} hooks/build
endef

# To force rebuild of image, specify DOCKER_EXTRA_ARGS="--no-cache"

build-2604:
	$(call build-rule,26.04)

build-2404:
	$(call build-rule,24.04)

build-2004:
	$(call build-rule,20.04)

build-1804:
	$(call build-rule,18.04)
