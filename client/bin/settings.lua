settings = {}

--------------Define the Color Picker Array--------------

settings.colorPicker = {}
settings.colorPicker.triangle = {}
settings.colorPicker.ring = {}
settings.colorPicker.innerCircle = {}
settings.colorPicker.tinyCircle = {}

--------------Create Final Canvas--------------

settings.colorPicker.canvas = love.graphics.newCanvas()

--------------Define Shapes through Constructor Classes (gui.lua)--------------

settings.colorPicker.ring = CircleButton(0, 0, 100, "fill", "", jLib.color.red)
settings.colorPicker.innerCircle = CircleButton(0, 0, 80, "fill", "", jLib.color.white) --Whatever the color of the background is
settings.colorPicker.triangle = TriangleButton(0, 0, 140)
settings.colorPicker.tinyCircle = RingButton(0, 0, 5, "fill", "", jLib.color.grey)

--------------Draw Function--------------

settings.colorPicker.draw = function(x, y, r, scale)

	love.graphics.setCanvas(settings.colorPicker.canvas)
		settings.colorPicker.ring:draw()
		settings.colorPicker.innerCircle:draw()
		settings.colorPicker.triangle:draw()
		settings.colorPicker.tinyCircle:draw()
	love.graphics.setCanvas()
	
	love.graphics.draw(settings.colorPicker.canvas, x - , ch, )
end

--------------Scaling Function--------------

settings.colorPicker.resize = function(scale)
	jLib.map()
	settings.colorPicker.canvas = love.graphics.newCanvas(scale, scale)
end