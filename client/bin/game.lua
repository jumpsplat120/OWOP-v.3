game = {
	state = "LOAD_SCREEN", --Possible states are START_MENU, SETTINGS, LOAD_SCREEN, FRIENDS_MENU, INGAME
	modal = "NONE",        --Possible states are NONE, ESC_MENU, FRIENDS_MENU, SETTINGS, BROADCAST
	save = {}, menu = {}, broadcast = {}, escapeModal = {}, settingsModal = {}, startMenu = {}, ui = {}, resize = {},
	player, isConnected, timer, hoverTimer,
	bgModal = function() love.graphics.rectangle("fill", 0, 0, jLib.window.width, jLib.window.height) end,
	scale = ((math.min(jLib.window.width, jLib.window.height) - 600) / 600) + 1,
	font = love.graphics.newFont("assets/04b_30.ttf", 144),
	broadcastModal = love.graphics.newImage("assets/modal.png")
}

local other_players = {}

function game.load()
	math.randomseed(os.time())
	love.graphics.setBackgroundColor(jLib.color.white)
	
	--------------Load From File--------------
	
	local contents, size_or_err = love.filesystem.read("player")
	if not contents then
		game.player = Character(jLib.color.red)
		game.updateSave()
		contents, size_or_err = love.filesystem.read("player")
	end
	local data = jLib.destringify(contents)
	
	--------------Load Controls--------------
	
	if data.controls then controls.updateSave(data.controls) else controls.setDefault() end
	
	--------------Create Player From Save--------------
	
	game.player     = Character(data.color, data.name, data.scale, 0, 0)
	game.loadPlayer = Character(data.color, "load", 1, jLib.window.width / 2, jLib.window.height / 2)
	
	--------------Start Menu Buttons--------------
	
	start_menu.load()
	
	--------------In Game Escape Menu--------------
	
	escape_modal.load()
	
	--------------Final Init--------------
	
	game.hoverTimer = 4.5
	game.state = "START_MENU"
	game.resize.update()
end

function game.ui.draw()
	if not (game.modal == "NONE") and not (game.modal == "BROADCAST") then 
		love.graphics.setColor(0,0,0,.33)
		game.bgModal()
	end
	
	if game.modal == "ESC_MENU" then
		if jLib.isColliding(jLib.mouse, game.escapeModal.resumeButton.regular) then
			if love.mouse.isDown(1) then game.escapeModal.resumeButton.click:draw() else game.escapeModal.resumeButton.hover:draw() end
			game.escapeModal.settingsButton.regular:draw()
			game.escapeModal.friendsButton.regular:draw()
			game.escapeModal.escapeButton.regular:draw()
		elseif jLib.isColliding(jLib.mouse, game.escapeModal.settingsButton.regular) then
			if love.mouse.isDown(1) then game.escapeModal.settingsButton.click:draw() else game.escapeModal.settingsButton.hover:draw() end
			game.escapeModal.resumeButton.regular:draw()
			game.escapeModal.friendsButton.regular:draw()
			game.escapeModal.escapeButton.regular:draw()
		elseif jLib.isColliding(jLib.mouse, game.escapeModal.friendsButton.regular) then
			if love.mouse.isDown(1) then game.escapeModal.friendsButton.click:draw() else game.escapeModal.friendsButton.hover:draw() end
			game.escapeModal.resumeButton.regular:draw()
			game.escapeModal.settingsButton.regular:draw()
			game.escapeModal.escapeButton.regular:draw()
		elseif jLib.isColliding(jLib.mouse, game.escapeModal.escapeButton.regular) then
			if love.mouse.isDown(1) then game.escapeModal.escapeButton.click:draw() else game.escapeModal.escapeButton.hover:draw() end
			game.escapeModal.resumeButton.regular:draw()
			game.escapeModal.settingsButton.regular:draw()
			game.escapeModal.friendsButton.regular:draw()
		else
			game.escapeModal.resumeButton.regular:draw()
			game.escapeModal.settingsButton.regular:draw()
			game.escapeModal.friendsButton.regular:draw()
			game.escapeModal.escapeButton.regular:draw()
		end
	elseif game.modal == "SETTINGS" then
	elseif game.modal == "FRIENDS_MENU" then
	end
end

function game.draw()
	--------------Draw the Dev Broadcast Modal--------------
	
	if game.modal == "BROADCAST" then
		local dt = love.timer.getTime()
		local time = dt - game.broadcast.timer
		local w, h, y = 400, 200, nil
		local speed = time / 3
		
		if time < 17 then 
			y = math.sin(speed) * 5
		else
			y = nil
			game.modal = "NONE"
			return
		end
		
		love.graphics.setColor(jLib.color.white)
		love.graphics.draw(game.broadcastModal, jLib.window.width - w - 15, (y * 40) - h)
		love.graphics.setColor(jLib.color.black)
		love.graphics.printf(game.broadcast.message, game.font, jLib.window.width - w, (y * 40) - (h - 5), w * 5, "left", 0, .2)
	end
	
	--------------Draw Game State--------------
	
	if game.state == "START_MENU" then
		if jLib.isColliding(jLib.mouse, game.startButton.regular) then
			if love.mouse.isDown(1) then game.startButton.click:draw() else game.startButton.hover:draw() end
			game.settingsButton.regular:draw()
			game.friendsButton.regular:draw()
		elseif jLib.isColliding(jLib.mouse, game.settingsButton.regular) then
			if love.mouse.isDown(1) then game.settingsButton.click:draw() else game.settingsButton.hover:draw() end
			game.startButton.regular:draw()
			game.friendsButton.regular:draw()
		elseif jLib.isColliding(jLib.mouse, game.friendsButton.regular) then
			if love.mouse.isDown(1) then game.friendsButton.click:draw() else game.friendsButton.hover:draw() end
			game.startButton.regular:draw()
			game.settingsButton.regular:draw()
		else
			game.startButton.regular:draw()
			game.settingsButton.regular:draw()
			game.friendsButton.regular:draw()
		end
	elseif game.state == "SETTINGS" then
		settings.colorPicker.draw()
		love.graphics.setColor(game.player.color)
		love.graphics.rectangle("fill", 50, 50, 50, 50)
		love.graphics.setColor(jLib.color.white)
	elseif game.state == "LOAD_SCREEN" then
		local size = .2 * game.scale
		love.graphics.setColor(game.player.color)
		love.graphics.printf("Loading...", game.font, (jLib.window.width / 2) - ((game.font:getWidth("Loading...") * size) / 2), 5, jLib.window.width / size, "left", 0, size)
		game.loadPlayer:draw()
	elseif game.state == "INGAME" then
		--camera:set()
			game.player:draw()
			--camera:setPosition(game.player.x - (jLib.window.width / 2), game.player.y - (jLib.window.height / 2))
		--camera:unset()
	elseif game.state == "FRIENDS_MENU" then
		love.graphics.setColor(jLib.color.black)
		love.graphics.print("friends menu")
	end
end

function game.update(dt)
	--------------Update Controls--------------
	
	if controls.escape.isReleased then
		if game.state == "INGAME" then
			if game.modal == "ESC_MENU" then 
				game.modal = "NONE"
			else 
				game.modal = "ESC_MENU"
			end
		elseif (game.state == "SETTINGS") or (game.state == "FRIENDS_MENU")  then
			game.state = "START_MENU"
		end
	end
	
	controls.reset()
	
	--------------Update Timer for Broadcast Modal--------------
	
	if game.modal == "BROADCAST" then
		local time = love.timer.getTime()
		if time + 15 < game.broadcast.timer then game.broadcast.message = nil end
	end
	
	--------------Update Game State--------------
	
	if game.state == "START_MENU" then
		if     jLib.isColliding(jLib.mouse, game.startButton.regular)    then game.hover(dt, "startButton")
		elseif jLib.isColliding(jLib.mouse, game.settingsButton.regular) then game.hover(dt, "settingsButton")
		elseif jLib.isColliding(jLib.mouse, game.friendsButton.regular)  then game.hover(dt, "friendsButton")
		else
			game.hover(dt, "startButton", nil, true)
			game.hover(dt, "friendsButton", nil, true)
			game.hover(dt, "settingsButton", nil, true)
			game.hoverTimer = 4.5
		end
	elseif game.state == "SETTINGS" then
		settings.colorPicker.triangle:update(dt)
		
		local color = {}
		color[1], color[2], color[3] = settings.colorPicker.guts()
		
		--SET THE GAME.PLAYER.COLOR BASED ON THE RGB AFTER SAT AND VAL HAVE BEEN DETERMINED, OR DON'T CHANGE IF VALUES ARE BLANK
		game.player.color[1] = color[1] or game.player.color[1]
		game.player.color[2] = color[2] or game.player.color[2]
		game.player.color[3] = color[3] or game.player.color[3]
		
	elseif game.state == "LOAD_SCREEN" then
		game.loadPlayer.rot = game.loadPlayer.rot + dt
		game.loadPlayer.scale = jLib.map(-1,1,.75,1.5,math.sin(game.loadPlayer.rot)) * game.scale
		game.loadPlayer.x, game.loadPlayer.y = jLib.window.width / 2, jLib.window.height / 2
		game.loadPlayer.canvas = love.graphics.newCanvas((game.loadPlayer.size * 2) * game.loadPlayer.scale + 5,(game.loadPlayer.size * 2) * game.loadPlayer.scale + 5)
	elseif game.state == "INGAME" then
		game.player:update(dt)
		if game.modal == "ESC_MENU" then
			if     jLib.isColliding(jLib.mouse, game.escapeModal.resumeButton.regular)   then game.hover(dt, "resumeButton", "escapeModal")
			elseif jLib.isColliding(jLib.mouse, game.escapeModal.settingsButton.regular) then game.hover(dt, "settingsButton", "escapeModal")
			elseif jLib.isColliding(jLib.mouse, game.escapeModal.friendsButton.regular)  then game.hover(dt, "friendsButton", "escapeModal")
			elseif jLib.isColliding(jLib.mouse, game.escapeModal.escapeButton.regular)   then game.hover(dt, "escapeButton", "escapeModal")
			else
				game.hover(dt, "resumeButton", "escapeModal", true)
				game.hover(dt, "settingsButton", "escapeModal", true)
				game.hover(dt, "friendsButton", "escapeModal", true)
				game.hover(dt, "escapeButton", "escapeModal", true)
				game.hoverTimer = 4.5
			end
		end
	elseif game.state == "FRIENDS_MENU" then
	end
	
	--------------Connect To Server (Runs once, runs in update so loading screen can display)--------------
	
	game.connect()
end

function game.hover(dt, button, modal, reset)
	local bounce = jLib.map(-1,1,1,1.5,math.sin(game.hoverTimer))
	game.hoverTimer = game.hoverTimer + dt
	
	if reset then
		if modal then
			game[modal][button].hover.w = game[modal][button].regular.w * bounce
			game[modal][button].hover.h = game[modal][button].regular.h * bounce
		else
			game[button].hover.w = game[button].regular.w * bounce
			game[button].hover.h = game[button].regular.h * bounce
		end
	else
		if modal then
			game[modal][button].hover.w = game[modal][button].regular.w * bounce
			game[modal][button].hover.h = game[modal][button].regular.h * bounce
		else
			game[button].hover.w = game[button].regular.w * bounce
			game[button].hover.h = game[button].regular.h * bounce
		end
	end
end

function game.resize.update()
	local cw, ch = jLib.window.width / 2, jLib.window.height / 2
	
	if game.state == "START_MENU" then
		local start    = game.startButton
		local settings = game.settingsButton
		local friends  = game.friendsButton
		
		local w = start.regular.w * game.scale
		local h = start.regular.h * game.scale
		
		start.regular.x = cw
		start.hover.x   = cw
		start.click.x   = cw
				
		settings.regular.x = cw
		settings.hover.x   = cw
		settings.click.x   = cw
		
		friends.regular.x = cw
		friends.hover.x   = cw
		friends.click.x   = cw
		
		local startCalc = ch - h - (h / 2)
		start.regular.y = startCalc
		start.hover.y   = startCalc
		start.click.y   = startCalc
		
		settings.regular.y = ch
		settings.hover.y   = ch
		settings.click.y   = ch
		
		local friendsCalc = ch + h + (h / 2)
		friends.regular.y = friendsCalc
		friends.hover.y   = friendsCalc
		friends.click.y   = friendsCalc
		
	elseif game.state == "INGAME" then
		if game.modal == "ESC_MENU" then
			local modal    = game.escapeModal
			
			local resume   = modal.resumeButton
			local settings = modal.settingsButton
			local friends  = modal.friendsButton
			local escape   = modal.escapeButton
			
			local w = resume.regular.w * game.scale
			local h = resume.regular.h * game.scale
			
			local margin = 20 * game.scale
			
			resume.regular.x = cw
			resume.hover.x   = cw
			resume.click.x   = cw
			
			settings.regular.x = cw
			settings.hover.x   = cw
			settings.click.x   = cw
			
			friends.regular.x = cw
			friends.hover.x   = cw
			friends.click.x   = cw
			
			escape.regular.x = cw
			escape.hover.x   = cw
			escape.click.x   = cw
			
			local resumeCalc = ch - (h * 1.5) - (margin * 1.5)
			resume.regular.y = resumeCalc
			resume.hover.y   = resumeCalc
			resume.click.y   = resumeCalc
			
			local settingsCalc = ch - (h * .5) - (margin * .5)
			settings.regular.y = settingsCalc
			settings.hover.y   = settingsCalc
			settings.click.y   = settingsCalc
			
			local friendsCalc = ch + (h * .5) + (margin * .5)
			friends.regular.y = friendsCalc
			friends.hover.y   = friendsCalc
			friends.click.y   = friendsCalc
			
			local escapeCalc = ch + (h * 1.5) + (margin * 1.5)
			escape.regular.y = escapeCalc
			escape.hover.y   = escapeCalc
			escape.click.y   = escapeCalc
		end
	elseif game.state == "SETTINGS" then
		settings.colorPicker.update(game.scale)
	end
	
end

function game.connect()
	if not game.isConnected then
		local waitTime = 10
		local timer = love.timer.getTime()		
		if timer > game.timer + waitTime then 
			jLib.error("We were unable to connect you to the game servers! You might be having trouble with your internet, or we might be having difficulty on our side. Please try again in a few minutes. If you're still getting this error, please send this error code to the developer: LOADTIMEOUT") 
			return
		end
		game.state = "LOAD_SCREEN"
		local data = network.get()
		if data then 
			game.isConnected, game.state = true, "START_MENU"
		end
	end
end

function game.updateSave()	
	game.save = {
		color = game.player.color,
		name = game.player.name,
		scale = game.player.scale,
		x, y, rot = 0, 0, 0,
		current_text = "",
		controls = { forward   = { key = controls.forward.key,   isPressed = false },
					 backwards = { key = controls.backwards.key, isPressed = false },
					 left      = { key = controls.left.key,      isPressed = false },
					 right     = { key = controls.right.key,     isPressed = false },
					 escape    = { key = controls.escape.key,    isPressed = false },
					 action    = { key = controls.action.key,    isPressed = false },
		 			 context   = { key = controls.context.key,   isPressed = false }}
	}
	
	local save = jLib.stringify(game.save)
	success, err = love.filesystem.write("player", save)
end

function game.broadcast.func(data)
	local data = data:gsub("Broadcast:", "")
	game.modal = "BROADCAST"
	game.broadcast.message = data
	game.broadcast.timer = love.timer.getTime()
end