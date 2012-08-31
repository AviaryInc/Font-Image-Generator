SOURCE = ./source.json
BUILD_DIR = ./build/

all: clean build

build:
	./node_modules/.bin/coffee canvas.coffee $(SOURCE) $(BUILD_DIR)

install:
	npm install

clean:
	rm -rf ${BUILD_DIR}*.png

.PHONY: all build clean
