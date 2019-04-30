--------------INIT--------------

         require "bin/jLib"
Object = require "bin/classic"
         require "bin/character"
         require "bin/network"
         require "bin/game"

--------------MAIN--------------
		 
function love.load()
	game.load()
	network.load()
end

function love.draw()
	game.draw()
	jLib.draw()
end

function love.update(dt)
	local data = network.update(dt)
	game.update(dt)
	jLib.update(dt)
end

------------CALLBACKS------------

function love.resize(width, height)
	jLib.window.width, jLib.window.height = width, height
	game.scale = ((math.min(jLib.window.width, jLib.window.height) - 600) / 600) + 1
end

function love.quit()
	game.updateSave()
end

function love.wheelmoved(x,y)
	if y < 0 and game.player.scale > .6 then
		game.player.scale = game.player.scale - .1
	elseif y > 0 and game.player.scale < 5 then
		game.player.scale = game.player.scale + .1
	end
	game.player.canvas = love.graphics.newCanvas((game.player.size * 2) * game.player.scale + 5,(game.player.size * 2) * game.player.scale + 5)
end

function love.keypressed(key)
	if key == "`" then
		if game.state == "START_MENU" then
			game.state = "SETTINGS"
		elseif game.state == "SETTINGS" then
			game.state = "LOAD_SCREEN"
		elseif game.state == "LOAD_SCREEN" then
			game.state = "INGAME"
		elseif game.state == "INGAME" then
			game.state = "START_MENU"
		end
	end
	if key == "f" then
		game.player.color = jLib.color.red
	end
end