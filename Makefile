VERSION=5.6.3

DOCKER_REGISTRY=registry.uw.systems
DOCKER_CONTAINER_NAME=elasticsearch
NAMESPACE=prm
DOCKER_REPOSITORY=$(DOCKER_REGISTRY)/$(NAMESPACE)/$(DOCKER_CONTAINER_NAME)

docker-build:
	docker build -t $(DOCKER_CONTAINER_NAME) .

ci-docker-auth:
	@docker login -u $(DOCKER_ID) -p $(DOCKER_PASSWORD) $(DOCKER_REGISTRY)

ci-docker-build:
	@docker build --build-arg VERSION=$(VERSION) -t $(DOCKER_REPOSITORY):$(CIRCLE_SHA1) .
	docker tag $(DOCKER_REPOSITORY):$(CIRCLE_SHA1) $(DOCKER_REPOSITORY):$(VERSION)

ci-docker-push: ci-docker-auth
	docker push $(DOCKER_REPOSITORY):$(VERSION)
