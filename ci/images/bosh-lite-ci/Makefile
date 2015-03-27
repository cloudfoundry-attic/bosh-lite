TAG?=dev

all: build

push: build
	docker push cloudfoundry/bosh-lite-ci:${TAG}

build:
	docker build -t cloudfoundry/bosh-lite-ci:${TAG} .
