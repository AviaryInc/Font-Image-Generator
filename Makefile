SOURCE = ./source.json
BUILD_DIR = ./build/

build:
	./node_modules/.bin/coffee canvas.coffee $(SOURCE) $(BUILD_DIR)

install:
	npm install

clean:
	rm -rf ${BUILD_DIR}*.png

all: clean build

.PHONY: all build clean
