###
Module dependencies.
###
Canvas = require "canvas"
fs = require("fs")

###
Commandline inputs
###
sourceFile = process.argv[2]
buildDir = process.argv[3] or ""

###
Helpers
###
extend = exports.extend = (object, properties) ->
	for key, val of properties
		object[key] = val
	object
extendByCopy = (object, properties) ->
	objectCopy = extend({}, object)
	extend(objectCopy, properties)
	objectCopy
###
Drop out if there's no data
###
if not sourceFile
	try
		throw new Error 1, "No source file specified"
	catch error
		console.log "Error: No source file specified"
	return


defaultTextImageData = 
	fontName : "Arial"
	fontSize : 12
	fontWeight : "normal"
	lineHeight : 16
	padding : 10
	color : "#000"
	outlineColor : undefined
	outlineWidth : undefined
	opacity : 1

getTextImageDataFromSource = (pathToSource) ->
	if pathToSource
		file = fs.readFileSync pathToSource, 'utf8'
		data = JSON.parse file
		if data
			textImages = data.textImages
			if data.defaults
				defaultTextImageData = extend(defaultTextImageData, data.defaults)

	textImages

outputCanvasToPNG = (canvas, filepath) ->
	if canvas and filepath
		out = fs.createWriteStream(filepath)
		stream = canvas.createPNGStream()
		stream.on "data", (chunk) ->
			out.write chunk

makeFileNameFromData = (options = {}) ->
	options = extendByCopy(defaultTextImageData, options)
	"#{ options.fontWeight }_#{ options.fontSize }_#{ options.fontName.toLowerCase().replace(/\ /g, "_") }_#{ options.text.toLowerCase().replace(/\ /g, "_") }"

makeFilePath = (filename, dir = "") ->
	__dirname + "/" + dir + filename + ".png"

makeCanvasWithText = (options = {}) ->
	options = extendByCopy(defaultTextImageData, options)

	# doubling because half of the stroke is
	# overwritten by a fill to make a true "outline"
	outlineWidth = (options.outlineWidth * 2) if options.outlineWidth

	# change dimensions later dynamically...
	canvas = new Canvas(1, 1)
	ctx = canvas.getContext("2d")

	# measure text
	ctx.font = options.fontWeight + " " + options.fontSize + "px " + options.fontName
	m = ctx.measureText(options.text)

	# ...like right here
	w = canvas.width = m.actualBoundingBoxRight - m.actualBoundingBoxLeft + options.padding * 2
	h = canvas.height = m.actualBoundingBoxDescent - (-m.actualBoundingBoxAscent) + options.padding * 2

	# draw text
	# have to re-state font property after clearing canvas when
	# size changed
	ctx.font = options.fontWeight + " " + options.fontSize + "px " + options.fontName
	if options.outlineColor
		ctx.lineWidth = options.outlineWidth
		ctx.strokeStyle = options.outlineColor
		ctx.strokeText options.text, options.padding, m.actualBoundingBoxAscent + options.padding
	ctx.fillStyle = options.color
	ctx.fillText options.text, options.padding, m.actualBoundingBoxAscent + options.padding

	canvas

textImages = getTextImageDataFromSource sourceFile

for textImage in textImages
	canvas = makeCanvasWithText textImage
	filename = makeFileNameFromData textImage
	filepath = makeFilePath filename, buildDir
	outputCanvasToPNG canvas, filepath
