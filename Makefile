SHELL := /bin/bash

.PHONY: build forcebuild up down shell status

export IMAGE_NAME = arris/flutter:latest
export CONTAINER_NAME = flutter

build:
	docker build -t ${IMAGE_NAME} .

forcebuild:
	docker build --no-cache -t ${IMAGE_NAME} .

up:
	docker run --rm -it --privileged \
		--name ${CONTAINER_NAME} \
                -e LINES=$(tput lines) \
                -e COLUMNS=$(tput cols) \
		-v /Users/arris/Code:/code \
		-p 5554:5554 \
		-p 5555:5555 \
		-p 8081:8081 \
		${IMAGE_NAME} 

down: export CONTAINER_IDS := $(shell docker ps -qa --no-trunc --filter "status=exited")
down:
	docker stop $(CONTAINER_NAME)

clean: export CONTAINER_IDS=$(shell docker ps -qa --no-trunc --filter "status=exited")
clean:
	docker rm $(CONTAINER_NAME)

shell:
	docker exec -it $(CONTAINER_NAME) bash

status:
	docker ps -a
