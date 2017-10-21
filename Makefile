DOCKER_IMAGE := kuwaderno
DOCKER_REPO  := paulganzon
VARIANTS     := latest
GIT_HASH     ?= $(shell git rev-parse --short HEAD)

VARIDS       := $(patsubst %, .%.id,$(VARIANTS))
TAGS         := $(patsubst %, tag-.%.id,$(VARIANTS))
RELEASES     := $(patsubst %, rls-.%.id,$(VARIANTS))
CLEANS       := $(patsubst %, cln-.%.id,$(VARIANTS))

.PHONY: build $(VARIANTS)

local: lint build tag

lint:    $(VARIANTS)
build:   $(VARIDS)
tag:     $(TAGS)
release: $(RELEASES)
clean:   $(CLEANS)

$(VARIANTS): 
	docker run -it --rm -v "$(PWD)/$@/Dockerfile:/Dockerfile:ro" redcoolbeans/dockerlint

$(VARIDS): .%.id:
	docker build --no-cache --iidfile $@ $*

$(TAGS): tag-.%.id: $(VARIDS)
	docker tag $(shell cat $<) $(DOCKER_REPO)/$(DOCKER_IMAGE):$*

$(RELEASES): rls-.%.id: $(VARIDS)
	docker tag $(shell cat $<) $(DOCKER_REPO)/$(DOCKER_IMAGE):$*
	docker tag $(shell cat $<) $(DOCKER_REPO)/$(DOCKER_IMAGE):$*-$(GIT_HASH)
	docker push $(DOCKER_REPO)/$(DOCKER_IMAGE):$*
	docker push $(DOCKER_REPO)/$(DOCKER_IMAGE):$*-$(GIT_HASH)

$(CLEANS): cln-.%.id: $(VARIDS)
	docker rmi -f $(shell cat $<)
	rm -f .*.id

