DOCKER_IMAGE := kuwaderno
VARIANTS     := latest mesos
GIT_HASH     ?= $(shell git rev-parse --short HEAD)
VARIDS       := $(patsubst %, .%.id,$(VARIANTS))
RELEASES     := $(patsubst %, .%.id,$(VARIANTS))

.PHONY: build

local:
	@echo $(VARIDS)

build: $(VARIDS)
release: $(RELEASES)

$(VARIDS): .%.id:
	@echo $@
	@echo $*
	docker build --no-cache \
		--idfile $@ \
		$*

$(RELEASES): .%.id
	docker tag $(shell cat $<) $(DOCKER_IMAGE):$*

