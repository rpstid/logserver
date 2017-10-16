PROJECT = logserver

DOCKER ?= $(shell which docker)
DOCKER_COMPOSE ?= $(shell which docker-compose)
ARTIFACTORYURL = dockerhub.hi.inet
PUBLISHREPO = smartdigits
IMAGE_NAME = $(ARTIFACTORYURL)/$(PUBLISHREPO)/$(PROJECT)
PORT ?= 5000
REMOTE_DOCKER ?= false
ifeq ($(REMOTE_DOCKER), false)
  WORKDIR = --workdir=/code
endif

#RELEASE = $(shell git log --pretty=oneline | wc -l | tr -d ' ')
#GITCURTAG = $(shell git describe --exact-match --tags HEAD 2>/dev/null)
LATESTTAG = latest
#VERSIONTAG = $(shell echo $(GITCURTAG) | tr -cd '[[:digit:]].')-$(RELEASE)

.PHONY: shell
shell:
	-$(DOCKER_COMPOSE) run --rm $(WORKDIR) $(PROJECT) bash

.PHONY: package
package:
	$(DOCKER) build -t $(IMAGE_NAME):$(LATESTTAG) .

.PHONY: test
test:
#	$(DOCKER_COMPOSE) run --name mvpejenkins --entrypoint "nosetests --with-xunit --with-coverage --cover-package=dapter_peru --cover-xml tests" $(PROJECT)
#	$(DOCKER) cp mvpejenkins:/app/coverage.xml coverage.xml
#	$(DOCKER) cp mvpejenkins:/app/nosetests.xml nosetests.xml
#	$(DOCKER_COMPOSE) down

.PHONY: run
run:
	-$(DOCKER_COMPOSE) run --rm -p $(PORT):5000 $(WORKDIR) $(PROJECT) \
	  python -m logserver/main

.PHONY: clean
clean:
	-$(DOCKER_COMPOSE) down --rmi local
	-$(DOCKER) rmi $(IMAGE_NAME):$(LATESTTAG)

.PHONY: deploy
deploy: package
	docker push $(IMAGE_NAME):$(LATESTTAG)
#ifneq ($(GITCURTAG),)
#	docker tag $(IMAGE_NAME) $(IMAGE_NAME):$(VERSIONTAG)
#	docker push $(IMAGE_NAME):$(VERSIONTAG)
#endif
