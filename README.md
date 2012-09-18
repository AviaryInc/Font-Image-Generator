# font-image-generator

This is a font image generator using [NodeJS](http://nodejs.org) and [node-canvas](https://github.com/LearnBoost/node-canvas). It's actually just a simple extension of the [text example](https://github.com/LearnBoost/node-canvas/blob/master/examples/text.js) in node-canvas.

## Installation

Unless previously installed you'll _need_ __Cairo__. For system-specific installation view the node-canvas [Wiki](https://github.com/LearnBoost/node-canvas/wiki/_pages) or use **homebrew**:

	$ brew install cairo
	$ brew link cairo
	$ brew link pixman	

Now install the node packages:

    $ make install


## Running it

	$ make
	
### Source

Update the `source.json` file with the text data you want to output as images
### Output

The images of the text are saved in the `build` directory with the following format:

*weight*\_*size*\_*font*\_*text*.png

## Adding fonts

### OSX

Add **.ttf** fonts to the Font Book application

### Other platforms

TBD

## License

MIT