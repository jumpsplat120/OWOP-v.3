local path = ...
local folder = string.match(path, ".*/")
local bitser = require (folder .. "bitser")

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
	color = {}
}

jLib.window.width, jLib.window.height, jLib.window.flags = love.window.getMode()

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

-----------------------------FUNCTIONS-----------------------------

--For use in LOVE; place in love.update()
function jLib.update(dt)
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

function jLib.map(from1, from2, to1, to2, input)
	return to2 + (input-from1)*(to2-to1)/(from2-from1)
end