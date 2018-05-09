DOCKER = docker
IMAGE = erwinchang/aosp-800

aosp: Dockerfile
	$(DOCKER) build -t $(IMAGE) .

all: aosp

.PHONY: all
