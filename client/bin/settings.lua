settings = {}

--------------Define the Color Picker Array--------------

settings.colorPicker = {}
settings.colorPicker.triangle = {}
settings.colorPicker.ring = {}
settings.colorPicker.innerCircle = {}
settings.colorPicker.tinyCircle = {}

--------------Define Shapes through Constructor Classes (gui.lua)--------------

settings.colorPicker.ring = CircleButton(0, 0, 100, "fill", "", jLib.color.red)
settings.colorPicker.innerCircle = CircleButton(0, 0, 80, "fill", "", jLib.color.white) --Whatever the color of the background is
settings.colorPicker.triangle = TriangleButton(0, 0, 140)
settings.colorPicker.tinyCircle = RingButton(0, 0, 5, "fill", "", jLib.color.grey)

--------------Draw Function--------------

settings.colorPicker.draw = function()
	settings.colorPicker.ring:draw()
	settings.colorPicker.innerCircle:draw()
	settings.colorPicker.triangle:draw()
	settings.colorPicker.tinyCircle:draw() --ROTATION CODE FOR THE CIRCLE
end

--------------Scaling/Position Function--------------

settings.colorPicker.update = function(x, y, scale) --Multiplier; scale of 1 is regular size, scale of 2x is twice as big, and so on
	x = x or jLib.window.width / 2
	y = y or jLib.window.height / 2
	
	local size = scale * 200
	
	settings.colorPicker.ring, settings.colorPicker.innerCircle, settings.colorPicker.triangle, settings.colorPicker.tinyCircle = nil, nil, nil, nil --NEW SOLUJTION THAT ISN'T THIS; Object resets on resizing screen
	
	settings.colorPicker.ring = CircleButton(x, y, size * .5, "fill", "", jLib.color.red)
	settings.colorPicker.innerCircle = CircleButton(x, y, size * .4, "fill", "", jLib.color.white)
	settings.colorPicker.triangle = TriangleButton(x, y, size * .7)
	settings.colorPicker.tinyCircle = RingButton(x, y, size * 0.025, "fill", "", jLib.color.grey)
	
end