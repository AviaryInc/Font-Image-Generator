build:
	./node_modules/.bin/coffee canvas.coffee

install:
	npm install

all: build

.PHONY: all build
