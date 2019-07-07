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
	if #controls.isMouse > 1 then
		for i = 1, #controls.isMouse, 1 do
			if controls[controls.isMouse[i]].key == "lclick" then
			end
		end
	end
	if game.state == "START_MENU" then
	elseif game.state == "SETTINGS" then
		if jLib.isColliding(jLib.mouse, settings.colorPicker.ring, "circle")  and not (jLib.isColliding(jLib.mouse, settings.colorPicker.innerCircle, "circle")) then
			settings.colorPicker.ring.isClicked = true
		elseif jLib.isInside(settings.colorPicker.triangle.vert, jLib.mouse.x, jLib.mouse.y) then
			settings.colorPicker.triangle.isClicked = true
		end
	end
end
	
----------Call on Mouse Click Up----------

function love.mousereleased(x, y, button)
	if game.state == "START_MENU" then
		if     jLib.isColliding(jLib.mouse, game.startButton.regular)    then game.state = "INGAME"
		elseif jLib.isColliding(jLib.mouse, game.friendsButton.regular)  then game.state = "FRIENDS_MENU" 
		elseif jLib.isColliding(jLib.mouse, game.settingsButton.regular) then game.state = "SETTINGS"
			settings.colorPicker.color = game.player.color
		end
		game.resize.update()
	elseif game.state == "INGAME" then
		if game.modal == "ESC_MENU" then
			if     jLib.isColliding(jLib.mouse, game.escapeModal.resumeButton.regular)   then game.modal = "NONE"
			elseif jLib.isColliding(jLib.mouse, game.escapeModal.settingsButton.regular) then game.modal = "SETTINGS"
			elseif jLib.isColliding(jLib.mouse, game.escapeModal.friendsButton.regular)  then game.modal = "FRIENDS_MENU"
			elseif jLib.isColliding(jLib.mouse, game.escapeModal.escapeButton.regular)   then
				game.state = "START_MENU"
				game.modal = "NONE"
			end
			game.resize.update()
		elseif game.modal == "SETTINGS" then
			settings.colorPicker.ring.isClicked = false
			settings.colorPicker.triangle.isClicked = false
			settings.colorPicker.color = game.player.color
		end
	elseif game.state == "SETTINGS" then
		settings.colorPicker.ring.isClicked = false
		settings.colorPicker.triangle.isClicked = false
	end
end

----------Call on Any Keyboard Press----------

function love.keypressed(key)
	if     key == controls.forward.key   then controls.forward.isPressed   = true
	elseif key == controls.backwards.key then controls.backwards.isPressed = true
	elseif key == controls.left.key      then controls.left.isPressed      = true
	elseif key == controls.right.key     then controls.right.isPressed     = true
	elseif key == controls.escape.key    then controls.escape.isPressed    = true
	elseif key == controls.action.key    then controls.action.isPressed    = true
	elseif key == controls.context.key   then controls.context.isPressed   = true
	end
end

----------Call on Any Keyboard Release----------
function love.keyreleased(key)
	if     key == controls.forward.key   then controls.forward.isPressed   = false
	elseif key == controls.backwards.key then controls.backwards.isPressed = false
	elseif key == controls.left.key      then controls.left.isPressed      = false
	elseif key == controls.right.key     then controls.right.isPressed     = false
	elseif key == controls.escape.key    then controls.escape.isPressed    = false
	elseif key == controls.action.key    then controls.action.isPressed    = false
	elseif key == controls.context.key   then controls.context.isPressed   = false
	end
	
	if     key == controls.forward.key   then controls.forward.isReleased   = true
	elseif key == controls.backwards.key then controls.backwards.isReleased = true
	elseif key == controls.left.key      then controls.left.isReleased      = true
	elseif key == controls.right.key     then controls.right.isReleased     = true
	elseif key == controls.escape.key    then controls.escape.isReleased    = true
	elseif key == controls.action.key    then controls.action.isReleased    = true
	elseif key == controls.context.key   then controls.context.isReleased   = true
	end
end