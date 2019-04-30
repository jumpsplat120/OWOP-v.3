game = {
	state = "LOAD_SCREEN", --Possible states are START_MENU, SETTINGS, LOAD_SCREEN, INGAME
	save = {},
	player, isConnected, timer, isBroadcast, broadcastTimer,
	scale = ((math.min(jLib.window.width, jLib.window.height) - 600) / 600) + 1,
	font = love.graphics.newFont("assets/04b_30.ttf", 144),
	broadcastModal = love.graphics.newImage("assets/modal.jpg")
}

local other_players = {}

function game.load()
	math.randomseed(os.time())
	love.graphics.setBackgroundColor(jLib.color.white)
	local contents_or_nil, size_or_err = love.filesystem.read("player")
	if not contents_or_nil then
		game.player = Character(jLib.color.red)
		game.updateSave()
		contents_or_nil, size_or_err = love.filesystem.read("player")
	end
	local data = jLib.destringify(contents_or_nil)
	game.player = Character(data.color, data.name, data.scale, jLib.window.width / 2, jLib.window.height / 2)
	game.loadPlayer = Character(data.color, "load", 1, jLib.window.width / 2, jLib.window.height / 2)
	game.state = "START_MENU"
end

function game.draw()
	if game.isBroadcast then
		local time = love.timer.getTime()
		local w, h, y = 400, 200
		if time - game.broadcastTimer < 10 then 
			y = math.min(5,(time - game.broadcastTimer)) 
		else
			y = 0
		end
		love.graphics.setColor(jLib.color.white)
		love.graphics.draw(game.broadcastModal, jLib.window.width - w, (y * 40) - 200)
		love.graphics.setColor(jLib.color.black)
		love.graphics.printf(game.isBroadcast, game.font, jLib.window.width - w, (y * 40) - 200, w, "left", 0, .2 * (game.font:getWidth(game.isBroadcast) * (game.isBroadcast:len() / 5)))
	end
	if game.state == "START_MENU" then
		love.graphics.setColor(jLib.color.black)
		love.graphics.print("start menu")
	elseif game.state == "SETTINGS" then
		love.graphics.setColor(jLib.color.black)
		love.graphics.print("settings")
	elseif game.state == "LOAD_SCREEN" then
		local size = .2 * game.scale
		love.graphics.setColor(game.player.color)
		love.graphics.printf("Loading...", game.font, (jLib.window.width / 2) - ((game.font:getWidth("Loading...") * size) / 2), 5, jLib.window.width / size, "left", 0, size)
		game.loadPlayer:draw()
	elseif game.state == "INGAME" then
		game.player:draw()
	end
end

function game.update(dt)
	if game.isBroadcast then
		local time = love.timer.getTime()
		if time + 15 < game.broadcastTimer then game.isBroadcast = nil end
	end
	if game.state == "START_MENU" then

	elseif game.state == "SETTINGS" then

	elseif game.state == "LOAD_SCREEN" then
		game.loadPlayer.rot = game.loadPlayer.rot + dt
		game.loadPlayer.scale = jLib.map(0,2,.25,1,(math.sin(game.loadPlayer.rot) + 1)) * game.scale
		game.loadPlayer.x, game.loadPlayer.y = jLib.window.width / 2, jLib.window.height / 2
		game.loadPlayer.canvas = love.graphics.newCanvas((game.loadPlayer.size * 2) * game.loadPlayer.scale + 5,(game.loadPlayer.size * 2) * game.loadPlayer.scale + 5)
	elseif game.state == "INGAME" then

	end
	
	game.connect()
end

function game.connect()
	if not game.isConnected then
		local waitTime = 10
		local timer = love.timer.getTime()		
		if timer > game.timer + waitTime then 
			jLib.error("We were unable to connect you to the game servers! You might be having trouble with your internet, or we might be having difficulty on our side. Please try again in a few minutes. If you're still getting this error, please send this error code to the developer: ITDIDNTFUCKINWORK420") 
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

function game.broadcast(data)
	local data = data:gsub("Broadcast:", "")
	game.isBroadcast = data
	game.broadcastTimer = love.timer.getTime()
end