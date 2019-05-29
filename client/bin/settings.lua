settings = {}

--------------Define the Color Picker Array--------------

settings.colorPicker = {}
settings.colorPicker.triangle = {}
settings.colorPicker.ring = {}
settings.colorPicker.innerCircle = {}
settings.colorPicker.tinyCircle = {}

--------------Create Final Canvas--------------

settings.colorPicker.canvas = love.graphics.newCanvas(200, 200)

--------------Define Shapes through Constructor Classes (gui.lua)--------------

settings.colorPicker.ring = CircleButton(100, 100, 100, "fill", "", jLib.color.red)
settings.colorPicker.innerCircle = CircleButton(100, 100, 80, "fill", "", jLib.color.white) --Whatever the color of the background is
settings.colorPicker.triangle = TriangleButton(100, 100, 140)
settings.colorPicker.tinyCircle = RingButton(100, 100, 5, "fill", "", jLib.color.grey)

--------------Draw Function--------------

settings.colorPicker.draw = function(x, y, r) --WE NEED TO GET THE POSITION OF THIS X AND Y FOR THE HITBOXES
	x = x or jLib.window.width / 2
	y = y or jLib.window.height / 2
	r = r or 0
	
	local w, h = settings.colorPicker.canvas:getDimensions()
	
	love.graphics.setCanvas(settings.colorPicker.canvas)
		settings.colorPicker.ring:draw()
		settings.colorPicker.innerCircle:draw()
		settings.colorPicker.triangle:draw()
		settings.colorPicker.tinyCircle:draw()
	love.graphics.setCanvas()
	
	love.graphics.draw(settings.colorPicker.canvas, x - (w / 2), y - (h / 2))
end

--------------Scaling Function--------------

settings.colorPicker.resize = function(scale) --Multiplier; scale of 1 is regular size, scale of 2x is twice as big, and so on
	local size = scale * 200
	
	settings.colorPicker.canvas = love.graphics.newCanvas(size, size)
	settings.colorPicker.ring.r = size * .5
	settings.colorPicker.innerCircle.r = size * .4
	settings.colorPicker.triangle.size = size * .7
	settings.colorPicker.tinyCircle.r = size * 0.025
	
end