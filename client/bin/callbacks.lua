----------Called on Window Resizing----------

function love.resize(width, height)
	jLib.window.width, jLib.window.height = width, height
	game.scale = ((math.min(jLib.window.width, jLib.window.height) - 600) / 600) + 1
	game.resize.update()
end

----------Call on Quit----------

function love.quit()
	game.updateSave()
end

----------Call on Mousewheel Movement----------

function love.wheelmoved(x, y)
	if y < 0 and game.player.scale > .6 then
		game.player.scale = game.player.scale - .1
	elseif y > 0 and game.player.scale < 5 then
		game.player.scale = game.player.scale + .1
	end
	game.player.canvas = love.graphics.newCanvas((game.player.size * 2) * game.player.scale + 5,(game.player.size * 2) * game.player.scale + 5)
end

----------Call on Mouse Click Down----------

function love.mousepressed(x, y, button)
	if game.state == "START_MENU" then
	elseif game.state == "SETTINGS" then
		if jLib.isColliding(jLib.mouse, settings.colorPicker.ring, "circle")  and not (jLib.isColliding(jLib.mouse, settings.colorPicker.innerCircle, "circle")) then
			settings.colorPicker.ring.isClicked = true
		end
	end
end
	
----------Call on Mouse Click Up----------

function love.mousereleased(x, y, button)
	if game.state == "START_MENU" then
		if jLib.isColliding(jLib.mouse, game.startButton.regular) then 
			game.state = "INGAME"
		elseif jLib.isColliding(jLib.mouse, game.settingsButton.regular) then 
			game.state = "SETTINGS"
		elseif jLib.isColliding(jLib.mouse, game.friendsButton.regular) then 
			game.state = "FRIENDS_MENU" 
		end
		game.resize.update()
	elseif game.state == "INGAME" then
		if game.modal == "ESC_MENU" then
			if jLib.isColliding(jLib.mouse, game.escapeModal.resumeButton.regular) then
				game.modal = "NONE"
			elseif jLib.isColliding(jLib.mouse, game.escapeModal.settingsButton.regular) then
				game.modal = "SETTINGS"
			elseif jLib.isColliding(jLib.mouse, game.escapeModal.friendsButton.regular) then
				game.modal = "FRIENDS_MENU"
			elseif jLib.isColliding(jLib.mouse, game.escapeModal.escapeButton.regular) then
				game.state = "START_MENU"
				game.modal = "NONE"
			end
			game.resize.update()
		elseif game.modal == "SETTINGS" then
			settings.colorPicker.ring.isClicked = false
		end
	elseif game.state == "SETTINGS" then
		settings.colorPicker.ring.isClicked = false
	end
end

----------Call on Any Keyboard Press----------

function love.keypressed(key)
	if key == "escape" and game.state == "INGAME" then
		if game.modal == "ESC_MENU" then  game.modal = "NONE" else game.modal = "ESC_MENU"  end
		game.resize.update()
	elseif key == "escape" and game.state == "SETTINGS" then
		game.state = "START_MENU"
		game.resize.update()
	elseif key == "escape" and game.state == "FRIENDS_MENU" then
		game.state = "START_MENU"
		game.resize.update()
	end
end