###
Module dependencies.
###
Canvas = require "canvas"
fs = require("fs")


outputCanvasToPNG = (canvas, filename = "text", dir = "") ->
	if canvas
		out = fs.createWriteStream(__dirname + "/" + dir + filename + ".png")
		stream = canvas.createPNGStream()
		stream.on "data", (chunk) ->
			out.write chunk


buildCanvasWithText = (text = "", options = {}) ->
	fontName = options.fontName or "Arial"
	fontSize = options.fontSizePx or 12
	lineHeight = options.lineHeight or 16
	padding = options.padding or 10
	color = options.color or "#000"
	outlineColor = options.outlineColor or undefined
	outlineWidth = (options.outlineWidth * 2) if options.outlineWidth
	opacity = options.opacity or 1

	# change dimensions later dynamically...
	canvas = new Canvas(1, 1)
	ctx = canvas.getContext("2d")

	# measure text
	ctx.font = "normal 200px " + fontName + ", serif"
	m = ctx.measureText(text)

	# ...like right here
	w = canvas.width = m.actualBoundingBoxRight - m.actualBoundingBoxLeft + padding * 2
	h = canvas.height = m.actualBoundingBoxDescent - (-m.actualBoundingBoxAscent) + padding * 2

	# draw text
	# have to re-state font property after clearing canvas when
	# size changed
	ctx.font = "normal 200px " + fontName + ", serif"
	if outlineColor
		ctx.lineWidth = outlineWidth
		ctx.strokeStyle = outlineColor
		ctx.strokeText text, padding, m.actualBoundingBoxAscent + padding
	ctx.fillStyle = color
	ctx.fillText text, padding, m.actualBoundingBoxAscent + padding

	canvas

canvas = buildCanvasWithText "hello world", 
	fontName : "Times New Roman"
	outlineColor : "#0b0"
	outlineWidth : 10

outputCanvasToPNG canvas, "hello_world", "build/"
