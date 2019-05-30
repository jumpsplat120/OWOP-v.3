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
	
	--------------Connect To Server--------------
	
	local contents_or_nil, size_or_err = love.filesystem.read("player")
	if not contents_or_nil then
		game.player = Character(jLib.color.red)
		game.updateSave()
		contents_or_nil, size_or_err = love.filesystem.read("player")
	end
	local data = jLib.destringify(contents_or_nil)
	
	--------------Create Player From Save--------------
	
	game.player = Character(data.color, data.name, data.scale, 0, 0)
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
	elseif game.state == "LOAD_SCREEN" then
		local size = .2 * game.scale
		love.graphics.setColor(game.player.color)
		love.graphics.printf("Loading...", game.font, (jLib.window.width / 2) - ((game.font:getWidth("Loading...") * size) / 2), 5, jLib.window.width / size, "left", 0, size)
		game.loadPlayer:draw()
	elseif game.state == "INGAME" then
		game.player:draw()
	elseif game.state == "FRIENDS_MENU" then
		love.graphics.setColor(jLib.color.black)
		love.graphics.print("friends menu")
	end
end

function game.update(dt)

	--------------Update Timer for Broadcast Modal--------------
	
	if game.modal == "BROADCAST" then
		local time = love.timer.getTime()
		if time + 15 < game.broadcast.timer then game.broadcast.message = nil end
	end
	
	--------------Update Game State--------------
	
	if game.state == "START_MENU" then
		game.hoverTimer = game.hoverTimer + dt
		local bounce = jLib.map(-1,1,1,1.5,math.sin(game.hoverTimer))
		if jLib.isColliding(jLib.mouse, game.startButton.regular) then
			game.startButton.hover.w, game.startButton.hover.h = game.startButton.regular.w * bounce, game.startButton.regular.h * bounce
		elseif jLib.isColliding(jLib.mouse, game.settingsButton.regular) then
			game.settingsButton.hover.w, game.settingsButton.hover.h = game.settingsButton.regular.w * bounce, game.settingsButton.regular.h * bounce
		elseif jLib.isColliding(jLib.mouse, game.friendsButton.regular) then
			game.friendsButton.hover.w, game.friendsButton.hover.h = game.settingsButton.regular.w * bounce, game.settingsButton.regular.h * bounce
		else
			game.startButton.hover.w, game.startButton.hover.h = game.startButton.regular.w, game.startButton.regular.h
			game.settingsButton.hover.w, game.settingsButton.hover.h = game.settingsButton.regular.w, game.settingsButton.regular.h
			game.friendsButton.hover.w, game.friendsButton.hover.h = game.friendsButton.regular.w, game.friendsButton.regular.h
			game.hoverTimer = 4.5
		end
	elseif game.state == "SETTINGS" then
		settings.colorPicker.triangle:update(dt)	
		if jLib.isColliding(jLib.mouse, settings.colorPicker.ring, "circle")  and not (jLib.isColliding(jLib.mouse, settings.colorPicker.innerCircle, "circle")) and love.mouse.isDown(1) then
			settings.colorPicker.triangle.rot = jLib.getDir(settings.colorPicker.triangle.x, settings.colorPicker.triangle.y, jLib.mouse.x, jLib.mouse.y)
			
			--Goes from neg half pi to pi + halfpi
			local min, max = -(math.pi * .5), math.pi + (math.pi * .5)
			local rgb = jLib.map(1, 3, 1, 10, 2)
			print(settings.colorPicker.triangle.rot, rgb)
		end
		if jLib.isInside(settings.colorPicker.triangle.vert, jLib.mouse.x, jLib.mouse.y) and love.mouse.isDown(1) then
			local x, y
			
			love.graphics.push()
				--APPLY ROTATION TOO COORDS
				love.graphics.translate(settings.colorPicker.triangle.x, settings.colorPicker.triangle.y)
				love.graphics.rotate(settings.colorPicker.triangle.rot + math.pi) --Why do I have to add pi??
				love.graphics.translate(-settings.colorPicker.triangle.x, -settings.colorPicker.triangle.y)
				
				--APPLY TRANSFORMATION TO MOUSE COORDS
				x, y = love.graphics.transformPoint(jLib.mouse.x, jLib.mouse.y)
				
				--MODIFY TINY CIRCLE X/Y BASED ON TRANSFORMED POINTS
				settings.colorPicker.tinyCircle.x, settings.colorPicker.tinyCircle.y = x, y

			love.graphics.pop()
		end
	elseif game.state == "LOAD_SCREEN" then
		game.loadPlayer.rot = game.loadPlayer.rot + dt
		game.loadPlayer.scale = jLib.map(-1,1,.75,1.5,math.sin(game.loadPlayer.rot)) * game.scale
		game.loadPlayer.x, game.loadPlayer.y = jLib.window.width / 2, jLib.window.height / 2
		game.loadPlayer.canvas = love.graphics.newCanvas((game.loadPlayer.size * 2) * game.loadPlayer.scale + 5,(game.loadPlayer.size * 2) * game.loadPlayer.scale + 5)
	elseif game.state == "INGAME" then
		if game.modal == "ESC_MENU" then
			game.hoverTimer = game.hoverTimer + dt
			local bounce = jLib.map(-1,1,1,1.5,math.sin(game.hoverTimer))
			if jLib.isColliding(jLib.mouse, game.escapeModal.resumeButton.regular) then
				game.escapeModal.resumeButton.hover.w,  game.escapeModal.resumeButton.hover.h =  game.escapeModal.resumeButton.regular.w * bounce,  game.escapeModal.resumeButton.regular.h * bounce
			elseif jLib.isColliding(jLib.mouse, game.escapeModal.settingsButton.regular) then
				game.escapeModal.settingsButton.hover.w,  game.escapeModal.settingsButton.hover.h =  game.escapeModal.settingsButton.regular.w * bounce,  game.escapeModal.settingsButton.regular.h * bounce
			elseif jLib.isColliding(jLib.mouse, game.escapeModal.friendsButton.regular) then
				game.escapeModal.friendsButton.hover.w,  game.escapeModal.friendsButton.hover.h =  game.escapeModal.friendsButton.regular.w * bounce,  game.escapeModal.friendsButton.regular.h * bounce
			elseif jLib.isColliding(jLib.mouse, game.escapeModal.escapeButton.regular) then
				game.escapeModal.escapeButton.hover.w,  game.escapeModal.escapeButton.hover.h =  game.escapeModal.escapeButton.regular.w * bounce,  game.escapeModal.escapeButton.regular.h * bounce
			else
				game.escapeModal.resumeButton.hover.w, game.escapeModal.resumeButton.hover.h = game.escapeModal.resumeButton.regular.w, game.escapeModal.resumeButton.regular.h
				game.escapeModal.settingsButton.hover.w, game.escapeModal.settingsButton.hover.h = game.escapeModal.settingsButton.regular.w, game.escapeModal.settingsButton.regular.h
				game.escapeModal.friendsButton.hover.w, game.escapeModal.friendsButton.hover.h = game.escapeModal.friendsButton.regular.w, game.escapeModal.friendsButton.regular.h
				game.escapeModal.escapeButton.hover.w, game.escapeModal.escapeButton.hover.h = game.escapeModal.escapeButton.regular.w, game.escapeModal.escapeButton.regular.h
				game.hoverTimer = 4.5
			end
		end
	elseif game.state == "FRIENDS_MENU" then
	end
	
	--------------Connect To Server (Runs once, runs in update so loading screen can display)--------------
	
	game.connect()
end

function game.resize.update()
	local cw, ch = jLib.window.width / 2, jLib.window.height / 2
	
	if game.state == "START_MENU" then
		local w, h = game.startButton.regular.w * game.scale, game.startButton.regular.h * game.scale
		
		game.startButton.regular.x, game.startButton.regular.y = cw, ch - h - (h / 2)
		game.settingsButton.regular.x, game.settingsButton.regular.y = cw, ch
		game.friendsButton.regular.x, game.friendsButton.regular.y = cw, ch	+ h + (h / 2)
		
		game.startButton.hover.x, game.startButton.hover.y = cw, ch - h - (h / 2)
		game.settingsButton.hover.x, game.settingsButton.hover.y = cw, ch
		game.friendsButton.hover.x, game.friendsButton.hover.y = cw, ch	+ h + (h / 2)
		
		game.startButton.click.x, game.startButton.click.y = cw, ch - h - (h / 2)
		game.settingsButton.click.x, game.settingsButton.click.y = cw, ch
		game.friendsButton.click.x, game.friendsButton.click.y = cw, ch	+ h + (h / 2)
	elseif game.state == "INGAME" then
		if game.modal == "ESC_MENU" then
			local w, h = game.escapeModal.resumeButton.regular.w * game.scale, game.escapeModal.resumeButton.regular.h * game.scale
			local margin = 20 * game.scale
			
			game.escapeModal.resumeButton.regular.x, game.escapeModal.resumeButton.regular.y = cw, ch - (h * 1.5) - (margin * 1.5)
			game.escapeModal.settingsButton.regular.x, game.escapeModal.settingsButton.regular.y = cw, ch - (h * .5) - (margin * .5)
			game.escapeModal.friendsButton.regular.x, game.escapeModal.friendsButton.regular.y = cw, ch + (h * .5) + (margin * .5)
			game.escapeModal.escapeButton.regular.x, game.escapeModal.escapeButton.regular.y = cw, ch + (h * 1.5) + (margin * 1.5)
			
			game.escapeModal.resumeButton.hover.x, game.escapeModal.resumeButton.hover.y = cw, ch - (h * 1.5) - (margin * 1.5)
			game.escapeModal.settingsButton.hover.x, game.escapeModal.settingsButton.hover.y = cw, ch - (h * .5) - (margin * .5)
			game.escapeModal.friendsButton.hover.x, game.escapeModal.friendsButton.hover.y = cw, ch + (h * .5) + (margin * .5)
			game.escapeModal.escapeButton.hover.x, game.escapeModal.escapeButton.hover.y = cw, ch + (h * 1.5) + (margin * 1.5)
			
			game.escapeModal.resumeButton.click.x, game.escapeModal.resumeButton.click.y = cw, ch - (h * 1.5) - (margin * 1.5)
			game.escapeModal.settingsButton.click.x, game.escapeModal.settingsButton.click.y = cw, ch - (h * .5) - (margin * .5)
			game.escapeModal.friendsButton.click.x, game.escapeModal.friendsButton.click.y = cw, ch + (h * .5) + (margin * .5)
			game.escapeModal.escapeButton.click.x, game.escapeModal.escapeButton.click.y = cw, ch + (h * 1.5) + (margin * 1.5)
		end
	elseif game.state == "SETTINGS" then
		settings.colorPicker.update(nil,nil,1 * game.scale)
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
		current_text = ""	
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