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
		 require "bin/controls"
reader = require "bin/inspect" --DEBUG TOOL

--------------MAIN--------------

function love.load()
	game.load()
	network.load()
end

function love.draw()
	game.draw()
	game.ui.draw()
	jLib.draw()
end

function love.update(dt)
	local response = network.update(dt)
	if response then print(response) end
	game.update(dt)
	jLib.update(dt)
end
