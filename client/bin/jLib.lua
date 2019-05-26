local path = ...
local folder = string.match(path, ".*/")
local bitser = require (folder .. "bitser")
test = {}
--[[
		___  ___       ___  ________     
	   |\  \|\  \     |\  \|\   __  \    
	   \ \  \ \  \    \ \  \ \  \|\ /_   
	 __ \ \  \ \  \    \ \  \ \   __  \  
	|\  \\_\  \ \  \____\ \  \ \  \|\  \ 
	\ \________\ \_______\ \__\ \_______\
	 \|________|\|_______|\|__|\|_______|

	Made by Antimony Apodaca - v0.1
Unlicense License - http://unlicense.org/

I'm bad at versioning well, but the most updated
version will always be on Github. If you got this
from anywhere else it may not be the most updated
version.

Requires in same folder as jLib... bitser.lua

--]]

jLib = {
	isError = false,
	errorMessage = "",
	window = {},
	color = {},
	printf = {} ,
	mouse = {}
}

jLib.window.width, jLib.window.height, jLib.window.flags = love.window.getMode()

jLib.color.clear      = {0,0,0,0}    --NO COLOR
jLib.color.white      = {1,1,1,1}    --#FFFFFF
jLib.color.grey       = {.5,.5,.5,1} --#7F7F7F
jLib.color.gray       = {.5,.5,.5,1} --#7F7F7F
jLib.color.black      = {0,0,0,1}    --#000000
jLib.color.red        = {1,0,0,1}    --#FF0000
jLib.color.green      = {0,1,0,1}    --#00FF00
jLib.color.blue       = {0,0,1,1}    --#0000FF
jLib.color.yellow     = {1,1,0,1}    --#FFFF00
jLib.color.magenta    = {1,0,1,1}    --#FF00FF
jLib.color.light_blue = {0,1,1,1}    --#00FFFF

jLib.printf.nowrap    = math.huge    --inf

jLib.mouse.x          = love.mouse.getX()
jLib.mouse.y          = love.mouse.getY()
jLib.mouse.w          = 1
jLib.mouse.h          = 1
jLib.mouse.r          = 1

-----------------------------FUNCTIONS-----------------------------

--For use in LOVE; place in love.update()
function jLib.update(dt)
	jLib.mouse.x, jLib.mouse.y = love.mouse.getPosition()
end

--For use in LOVE; place in love.draw()
function jLib.draw()
	if jLib.isError then 
		love.graphics.clear()
		love.graphics.setBackgroundColor(jLib.color.light_blue)
		love.graphics.setColor(jLib.color.white)
		love.graphics.printf(jLib.errorMessage, jLib.window.width / 4, jLib.window.height / 2, jLib.window.width - (jLib.window.width / 2), "center")
	end
end

--Call jLib.error(any_string) to cause a custom error screen that isn't actually an error. Set isError to false to exit the error screen.
function jLib.error(err)
	assert(type(err) == "string", "This is ironic. jLib.error has thrown an error; the argument passed was not a string.")
	jLib.errorMessage = err
	jLib.isError = true
end

--Wrapper function for bitser serialization
function jLib.stringify(t)
	return bitser.dumps(t)
end

--Wrapper function for bister deserialization
function jLib.destringify(str)
	return bitser.loads(str)
end

--Map one range to another
function jLib.map(from1, from2, to1, to2, input)
	return to2 + (input-from1)*(to2-to1)/(from2-from1)
end

function jLib.isEven(num)
	return num % 2 == 0
end

--Determine if two objects are colliding with each other. Pass two tables with center x, y arguments. Also pass tables with width/height if rectangle, or radius if circle.
function jLib.isColliding(obj1, obj2, form)
	form = form or "rectangle" --rectangle/circle
	assert(obj1, "jLib.isColliding() has thrown an error; missing obj1 parameter.")
	assert(obj2, "jLib.isColliding() has thrown an error; missing obj2 parameter.")
	local x1, y1 = obj1.x, obj1.y
	local x2, y2 = obj2.x, obj2.y
	
	if form == "rectangle" then
		local w1 = obj1.w * game.scale or obj1.width * game.scale
		local h1 = obj1.h * game.scale or obj1.height * game.scale
		local w2 = obj2.w * game.scale or obj2.width * game.scale
		local h2 = obj2.h * game.scale or obj2.height * game.scale
		assert(w1 and h1 and w2 and h2, "jLib.isColliding() has thrown an error; tables passed were missing width/height parameters. Must be in 'table.w/table.h' or 'table.width/table.height' format.")
		
		local a1, b1, c1, d1 = x1 - (w1 / 2), y1 - (h1 / 2), x1 + (w1 / 2), y1 + (h1 / 2)
		local a2, b2, c2, d2 = x2 - (w2 / 2), y2 - (h2 / 2), x2 + (w2 / 2), y2 + (h2 / 2)
		return not (c1 <= a2 or d1 <= b2 or a1 >= c2 or b1 >= d2)
	elseif form == "circle" then
		local r1 = obj1.r or obj1.radius
		local r2 = obj2.r or obj2.radius
		assert(r1 and r2, "jLib.isColliding() has thrown an error; tables passed were missing radius parameters. Must be in 'table.r' or 'table.radius' format.")
		local dist = math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))
		return dist < r1 + r2
	else
		error("jLib.isColliding() has thrown an error; did not define form parameter.")
	end
end

--Determine if a point is within a polygon. Polygon must be table with an even number of values to represent x/y pairs
function jLib.isInside(obj, x, y)
	local i, yflag0, yflag1, inside_flag, vtx0, vtx1
	local pgon = {}
	local it = 1
	
	assert(#obj / 2 == 0, "jLib.isInside() has thrown an error; obj parameter does not have an even number of items in table.")
	for i = 1, #obj, 2 do
		pgon[it] = {}
		pgon[it].x, pgon[it].y = obj[i], obj[i + 1]
		it = it + 1
	end
		
	local numverts = #pgon
	
	vtx0 = pgon[numverts]
	vtx1 = pgon[1]
 
	yflag0 = ( vtx0.y >= y )
	inside_flag = false
 
	for i = 2, numverts + 1 do
		yflag1 = ( vtx1.y >= y )
		if ( yflag0 ~= yflag1 ) then
			if ( ((vtx1.y - y) * (vtx0.x - vtx1.x) >= (vtx1.x - x) * (vtx0.y - vtx1.y)) == yflag1 ) then
				inside_flag =  not inside_flag
			end
		end
 
		-- Move to the next pair of vertices, retaining info as possible.
		yflag0  = yflag1
		vtx0    = vtx1
		vtx1    = pgon[i]
	end
 
	return  inside_flag
end