settings = {}

--------------Define the Color Picker Array--------------

settings.colorPicker             = {}
settings.colorPicker.triangle    = {}
settings.colorPicker.ring        = {}
settings.colorPicker.innerCircle = {}
settings.colorPicker.tinyCircle  = {}

--------------Assigning Misc. Values--------------

settings.colorPicker.ring.isClicked     = false
settings.colorPicker.triangle.isClicked = false

settings.colorPicker.triangleTex  = love.graphics.newImage("assets/triangle_gradient.png")
settings.colorPicker.triangleTint = love.graphics.newImage("assets/triangle_tint.png")
settings.colorPicker.ringTex      = love.graphics.newImage("assets/rainbow_gradient.png")
settings.colorPicker.line         = love.graphics.newImage("assets/line.png")

settings.colorPicker.x, settings.colorPicker.y = 0, 0

settings.colorPicker.tint = jLib.color.red

--------------Define Shapes through Constructor Classes (gui.lua)--------------

settings.colorPicker.ring        = CircleButton(settings.colorPicker.x, settings.colorPicker.y, 100, "fill", "", jLib.color.clear)
settings.colorPicker.innerCircle = CircleButton(settings.colorPicker.x, settings.colorPicker.y, 80, "fill", "", jLib.color.clear)
settings.colorPicker.triangle    = TriangleButton(settings.colorPicker.x, settings.colorPicker.y, 140, 0, "fill", "", jLib.color.clear)
settings.colorPicker.tinyCircle  = RingButton(settings.colorPicker.x, settings.colorPicker.y, 5, "fill", "", jLib.color.grey)

--------------Draw Function--------------

settings.colorPicker.draw = function()
	--HITBOXES
	settings.colorPicker.ring:draw()
	settings.colorPicker.innerCircle:draw()
	settings.colorPicker.triangle:draw()
	--DRAW TEXTURES
	love.graphics.draw(settings.colorPicker.ringTex, settings.colorPicker.x, settings.colorPicker.y, 0, .5 * game.scale, .5 * game.scale, 200, 200)
	love.graphics.draw(settings.colorPicker.triangleTex, settings.colorPicker.x, settings.colorPicker.y, settings.colorPicker.triangle.rot, .5 * game.scale, .5 * game.scale, 160, 160)
	love.graphics.setColor(settings.colorPicker.tint)
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
	settings.colorPicker.ring        = CircleButton(settings.colorPicker.x, settings.colorPicker.y, size * .5, "fill", "", jLib.color.clear)
	settings.colorPicker.innerCircle = CircleButton(settings.colorPicker.x, settings.colorPicker.y, size * .4, "fill", "", jLib.color.clear)
	settings.colorPicker.triangle    = TriangleButton(settings.colorPicker.x, settings.colorPicker.y, size * .7, rot, "fill", "", jLib.color.clear)
	settings.colorPicker.tinyCircle  = RingButton(settings.colorPicker.x, settings.colorPicker.y, size * 0.025, "fill", "", jLib.color.grey)
end

--------------Color Determination Function--------------

settings.colorPicker.guts = function()
	local degree, r, g, b, hue, sat, val
	local color = {}
	
	--ONLY GET THE ROTATION WHEN THE RING IS CLICKED
	if settings.colorPicker.ring.isClicked then
		settings.colorPicker.triangle.rot = jLib.getDir(settings.colorPicker.triangle.x, settings.colorPicker.triangle.y, jLib.mouse.x, jLib.mouse.y)	
	end
	
	--ALWAYS GET THE HUE FIRST BASED ON THE ROTATION, REGARDLESS ON WHAT'S ACTUALLY BEING CLICKED
	if settings.colorPicker.ring.isClicked or settings.colorPicker.triangle.isClicked then
		
		--CONVERT FROM RADIANS TO DEGREES
		degree = jLib.map(-math.pi * .5, math.pi * 1.5, 0, 360, settings.colorPicker.triangle.rot)
		
		--CALCULATE RED BASED ON ROTATION
		if degree >= 15 and degree <= 150 then
			r = 255
		elseif degree > 150 and degree < 210 then
			r = math.floor(jLib.map(150, 210, 255, 0, degree))
		elseif degree < 15 then
			r = math.floor(jLib.map(15, 0, 255, 196, degree))
		elseif degree > 310 then
			r = math.floor(jLib.map(360, 310, 195, 0, degree))
		else
			r = 0
		end
		
		--CALCULATE GREEN BASED ON ROTATION
		if degree <= 270 and degree >= 150 then
			g = 255
		elseif degree > 270 and degree < 310 then
			g = math.floor(jLib.map(270, 310, 255, 0, degree))
		elseif degree < 150 and degree > 90 then
			g = math.floor(jLib.map(150, 90, 255, 0, degree))
		else
			g = 0
		end
		
		--CALCULATE BLUE BASED ON ROTATION
		if degree <= 15 or degree >= 270 then
			b = 255
		elseif degree > 15 and degree < 90 then
			b = math.floor(jLib.map(15, 90, 255, 0, degree))
		elseif degree > 210 and degree < 270 then
			b = math.floor(jLib.map(210, 270, 0, 255, degree))
		else
			b = 0
		end
		
		--CONVERT FROM 255/0 SCALE to 1/0 SCALE
		r = r / 255
		g = g / 255
		b = b / 255
		
		--SET THE TINT BASED OFF OF ONLY THE HUE
		settings.colorPicker.tint = {r, g, b}
	
		--SET RGB TO RGB OR CURRENT GAME.PLAYER.COLOR
		color[1] = r
		color[2] = g
		color[3] = b
		
		local x, y, ix, iy
		local triangle = settings.colorPicker.triangle
		--ONLY DO TRIANGLE CALCULATIONS IF TRIANGLE WAS CLICKED INITIALLY
		if settings.colorPicker.triangle.isClicked then
		
			--IF MOUSE IS NOT IN TRIANGLE
			if not jLib.isInside(triangle.vert, jLib.mouse.x, jLib.mouse.y) then
			
				local line2 = {jLib.mouse.x, jLib.mouse.y, triangle.x, triangle.y}
				
				--GET VALUES OF TRIANGLE TO FORM LINE
				for i = 1, #triangle.vert, 2 do
					local x1, y1 = triangle.vert[i], triangle.vert[i + 1]
					local x2, y2
					
					if i + 1 >= #triangle.vert then
						x2, y2 = triangle.vert[1], triangle.vert[2]
					else
						x2, y2 = triangle.vert[i + 2], triangle.vert[i + 3]
					end
					
					--GET INTERSECTION POINT OF TRIANGLE LINE AND MOUSE-TO-CENTER LINE
					ix, iy = jLib.intersectsAt({x1, y1, x2, y2}, line2)
					
					--IF INTERSECTION POINT EXISTS, BREAK FROM LOOP
					if ix and iy then break end
				end
			end
				
			--IF MOUSE IS INSIDE TRIANGLE, ASSIGN ix AND iy VALUES OF MOUSE x AND y
			if not ix and not iy then ix, iy = jLib.mouse.x, jLib.mouse.y end
			
			love.graphics.push()
				--APPLY ROTATION TOO COORDS
				love.graphics.translate(triangle.x, triangle.y)
				love.graphics.rotate(-triangle.rot)
				love.graphics.translate(-triangle.x, -triangle.y)
				
				--APPLY TRANSFORMATION TO INTERSECTION COORDS
				x, y = love.graphics.transformPoint(ix, iy)	
			love.graphics.pop()
			
			--MODIFY TINY CIRCLE X/Y BASED ON TRANSFORMED POINTS
			settings.colorPicker.tinyCircle.x, settings.colorPicker.tinyCircle.y = x, y
		end
		
		--IF THE ABOVE WASN'T CALCULATED, GET THE PREV VALUES OF THE X, Y POSITION AND USE THEM TO CALCULATE THE FOLLOWING
		x = x or settings.colorPicker.tinyCircle.x
		y = y or settings.colorPicker.tinyCircle.y
		
		--CONVERT HSV
		hue, sat, val = jLib.RGBtoHSV(color[1] * 255, color[2] * 255, color[3] * 255)
		
		--CALCULATE TOP, BOTTOM, LEFT AND RIGHT OF TRIANGLES BASED ON RELATIVE COORDS
		local top, btm = triangle.y - ((math.sqrt(3)/3) * triangle.size), triangle.y + ((math.sqrt(3)/6) * triangle.size)
		local right, left = triangle.x + (triangle.size / 2), triangle.x - (triangle.size / 2)
		
		--GET THE POSITION OF THE POINTER, AND COMPARE IT TO THE BOTTOM/TOP OF THE TRIANGLE, AND MAP THAT TO 0 - 1
		sat = jLib.map(btm, top, 0, 1, y)
		
		--DO THE SAME THING, BUT ADD IN THE SATURATION SO YOU DON'T LOSE THE HUE
		val = math.min(jLib.map(left, right, 0, .75, x) + sat, 1)
		
		return jLib.HSVtoRGB(hue, sat, val)
	end
end