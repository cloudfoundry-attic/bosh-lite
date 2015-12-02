TAG?=dev

all: build

push: build
	docker push bosh/bosh-lite-ci:${TAG}

build:
	docker build -t bosh/bosh-lite-ci:${TAG} .
