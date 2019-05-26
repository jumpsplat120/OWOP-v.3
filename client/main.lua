--------------INIT--------------

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

------------CALLBACKS------------

function love.resize(width, height)
	jLib.window.width, jLib.window.height = width, height
	game.scale = ((math.min(jLib.window.width, jLib.window.height) - 600) / 600) + 1
	game.resize.update()
end

function love.quit()
	game.updateSave()
end

function love.wheelmoved(x, y)
	if y < 0 and game.player.scale > .6 then
		game.player.scale = game.player.scale - .1
	elseif y > 0 and game.player.scale < 5 then
		game.player.scale = game.player.scale + .1
	end
	game.player.canvas = love.graphics.newCanvas((game.player.size * 2) * game.player.scale + 5,(game.player.size * 2) * game.player.scale + 5)
end

function love.mousereleased(x, y, button)
	if game.state == "START_MENU" then
		if jLib.isColliding(jLib.mouse, game.startButton.regular) then
			game.state = "INGAME"
			game.startMenu.update()
		elseif jLib.isColliding(jLib.mouse, game.settingsButton.regular) then
			game.state = "SETTINGS"
			game.startMenu.update()
		elseif jLib.isColliding(jLib.mouse, game.friendsButton.regular) then
			game.state = "FRIENDS_MENU"
			game.startMenu.update()
		end
	elseif game.state == "INGAME" then
		--if game.modal == "ESC_MENU" then game.modal = "NONE" end
	end
end

function love.keypressed(key)
	if key == "escape" and game.state == "INGAME" then
		if game.modal == "ESC_MENU" then game.modal = "NONE" else game.modal = "ESC_MENU" end
	elseif key == "escape" and game.state == "SETTINGS" then
		game.state = "START_MENU"
	elseif key == "escape" and game.state == "FRIENDS_MENU" then
		game.state = "START_MENU"
	end
end