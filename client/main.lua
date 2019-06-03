--------------INIT--------------
		 
		 require "bin/callbacks"
         require "bin/jLib"
Object = require "bin/classic"
         require "bin/character"
         require "bin/network"
         require "bin/game"
		 require "bin/gui"
		 require "bin/start_menu"
		 require "bin/escape_modal"
		 require "bin/settings"
		 require "bin/camera"

--------------MAIN--------------

function love.load()
	game.load()
	network.load()
end

function love.draw()
	camera:set()
		game.draw()
	camera:unset()
	game.ui.draw()
	jLib.draw()
end

function love.update(dt)
	local data = network.update(dt)
	if data then print(data) end
	game.update(dt)
	jLib.update(dt)
end
