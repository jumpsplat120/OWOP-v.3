settings = {}

--------------Define the Color Picker Array--------------

settings.colorPicker = {}
settings.colorPicker.triangle = {}
settings.colorPicker.ring = {}
settings.colorPicker.innerCircle = {}
settings.colorPicker.tinyCircle = {}

--------------Assigning Misc. Values--------------

settings.colorPicker.ring.isClicked = false
settings.colorPicker.triangle.isClicked = false

settings.colorPicker.triangleTex = love.graphics.newImage("assets/triangle_gradient.png")
settings.colorPicker.triangleTint = love.graphics.newImage("assets/triangle_tint.png")
settings.colorPicker.ringTex = love.graphics.newImage("assets/rainbow_gradient.png")
settings.colorPicker.line = love.graphics.newImage("assets/line.png")

settings.colorPicker.x, settings.colorPicker.y = 0, 0

settings.colorPicker.color = jLib.color.red

--------------Define Shapes through Constructor Classes (gui.lua)--------------

settings.colorPicker.ring = CircleButton(settings.colorPicker.x, settings.colorPicker.y, 100, "fill", "", jLib.color.clear)
settings.colorPicker.innerCircle = CircleButton(settings.colorPicker.x, settings.colorPicker.y, 80, "fill", "", jLib.color.clear)
settings.colorPicker.triangle = TriangleButton(settings.colorPicker.x, settings.colorPicker.y, 140, 0, "fill", "", jLib.color.clear)
settings.colorPicker.tinyCircle = RingButton(settings.colorPicker.x, settings.colorPicker.y, 5, "fill", "", jLib.color.grey)

--------------Draw Function--------------

settings.colorPicker.draw = function()
	--HITBOXES
	settings.colorPicker.ring:draw()
	settings.colorPicker.innerCircle:draw()
	settings.colorPicker.triangle:draw()
	--DRAW TEXTURES
	love.graphics.draw(settings.colorPicker.ringTex, settings.colorPicker.x, settings.colorPicker.y, 0, .5 * game.scale, .5 * game.scale, 200, 200)
	love.graphics.draw(settings.colorPicker.triangleTex, settings.colorPicker.x, settings.colorPicker.y, settings.colorPicker.triangle.rot, .5 * game.scale, .5 * game.scale, 160, 160)
	love.graphics.setColor(game.player.color)
	love.graphics.draw(settings.colorPicker.triangleTint, settings.colorPicker.x, settings.colorPicker.y, settings.colorPicker.triangle.rot, .5 * game.scale, .5 * game.scale, 160, 160)
	love.graphics.setColor(jLib.color.white)
	love.graphics.draw(settings.colorPicker.line, settings.colorPicker.x, settings.colorPicker.y, settings.colorPicker.triangle.rot, .5 * game.scale, .5 * game.scale, 30, 200)
	settings.colorPicker.tinyCircle:draw()
end

--------------Scaling/Update Function--------------

settings.colorPicker.update = function(scale) --Multiplier; scale of 1 is regular size, scale of 2x is twice as big, and so on
	--RECALCULATE POSITION
	settings.colorPicker.x = jLib.window.width / 2 --RECALCULATE POS
	settings.colorPicker.y = jLib.window.height / 2 --RECALCULATE POS
	--RECALCULATE SIZE BASED OFF OF PASSED SCALE PARAMETER
	local size = scale * 200
	local rot = settings.colorPicker.triangle.rot
	--DESTROY REFERENCE OF HITBOXES
	settings.colorPicker.ring, settings.colorPicker.innerCircle, settings.colorPicker.triangle, settings.colorPicker.tinyCircle = nil, nil, nil, nil
	--CREATE NEW HITBOXES
	settings.colorPicker.ring = CircleButton(settings.colorPicker.x, settings.colorPicker.y, size * .5, "fill", "", jLib.color.clear)
	settings.colorPicker.innerCircle = CircleButton(settings.colorPicker.x, settings.colorPicker.y, size * .4, "fill", "", jLib.color.clear)
	settings.colorPicker.triangle = TriangleButton(settings.colorPicker.x, settings.colorPicker.y, size * .7, rot, "fill", "", jLib.color.clear)
	settings.colorPicker.tinyCircle = RingButton(settings.colorPicker.x, settings.colorPicker.y, size * 0.025, "fill", "", jLib.color.grey)
end