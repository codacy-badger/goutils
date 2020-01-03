# Go parameters
GOCMD=go
GOINSTALL=$(GOCMD) install
GORUN=$(GOCMD) run
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
GOMOD=$(GOCMD) mod
GOTOOL=$(GOCMD) tool
BINARY_NAME=go-release
BINARY_UNIX=$(BINARY_NAME)_unix
DOCKER_COMPOSE=docker-compose

dc-up:
	$(DOCKER_COMPOSE) up -d
dc-down:
	$(DOCKER_COMPOSE) down

dc-stop:
	$(DOCKER_COMPOSE) stop

dc-restart:
	$(DOCKER_COMPOSE) restart

dc-build:
	$(DOCKER_COMPOSE) build

all: test build

install:
	$(GOINSTALL) ./...

update:
	$(GOGET) -u && $(GOMOD) tidy

update-all:
	$(GOGET) -u all && $(GOMOD) tidy

build: 
	$(GOBUILD) -o $(BINARY_NAME) -v

test: 
	$(GOTEST) -cover ./...

test-cover-count: 
	$(GOTEST) -covermode=count -coverprofile=cover-count.out ./...

test-cover-atomic: 
	$(GOTEST) -covermode=atomic -coverprofile=cover-atomic.out ./...

cover-count:
	$(GOTOOL) cover -func=cover-count.out

cover-atomic:
	$(GOTOOL) cover -func=cover-atomic.out

html-cover-count:
	$(GOTOOL) cover -html=cover-count.out

html-cover-atomic:
	$(GOTOOL) cover -html=cover-atomic.out

run-cover-count: test-cover-count cover-count
run-cover-atomic: test-cover-atomic cover-atomic
view-cover-count: test-cover-count html-cover-count
view-cover-atomic: test-cover-atomic html-cover-atomic

bench: 
	$(GOTEST) -bench=. ./...

clean: 
	$(GOCLEAN)
	rm -f $(BINARY_NAME)
	rm -f $(BINARY_UNIX)

run-prod:
	$(GOBUILD) -o $(BINARY_NAME) -v
	./$(BINARY_NAME)