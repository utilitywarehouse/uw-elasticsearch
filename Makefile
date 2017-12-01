VERSION=6.0.0

DOCKER_REGISTRY=registry.uw.systems
DOCKER_CONTAINER_NAME=elasticsearch
DOCKER_REPOSITORY=$(DOCKER_REGISTRY)/$(DOCKER_CONTAINER_NAME)

docker-build:
	docker build --build-arg VERSION=$(VERSION) -t $(DOCKER_CONTAINER_NAME):$(VERSION) .
	echo To run the image locally: docker run --rm -ti -e xpack.security.enabled=false -p 9200:9200 $(DOCKER_CONTAINER_NAME):$(VERSION)

ci-docker-auth:
	@docker login -u $(DOCKER_ID) -p $(DOCKER_PASSWORD) $(DOCKER_REGISTRY)

ci-docker-build:
	@docker build --build-arg VERSION=$(VERSION) -t $(DOCKER_REPOSITORY):$(CIRCLE_SHA1) .
	docker tag $(DOCKER_REPOSITORY):$(CIRCLE_SHA1) $(DOCKER_REPOSITORY):$(VERSION)

ci-docker-push: ci-docker-auth
	docker push $(DOCKER_REPOSITORY):$(VERSION)
