local socket = require "socket"

-- server for internal use
local server = {
	timeout = 3,
	address = {ip = "108.230.159.104", port = 1051},	-- Public IP, port
	time = love.timer.getTime(),
	pong = love.timer.getTime()
}

--network for external use
network = {}

server.udp = socket.udp()
server.udp:settimeout(0)
server.udp:setpeername(server.address.ip, server.address.port)
network.ip, network.port = server.udp:getpeername()

function network.ping()
	local currTime = love.timer.getTime()
	if server.time + 1 < currTime then
		local success, err = server.udp:send(jLib.stringify({id = "PING", data = "Ping!"}))
		if err then error(err) end
		server.time = love.timer.getTime()
	end
end

function network.load()
	print("Connecting to " .. server.address.ip .. ":" .. server.address.port)
	local _, err = server.udp:send(jLib.stringify({id = "REQ_CONNECT", data = "Requesting connection..."}))
	if err then error(err) end
	local data = server.udp:receive()
	game.timer = love.timer.getTime()
	if data then print("Connected!") else print("Server wasn't found on first ping, will try again...") end
end

function network.update(dt)
	--Recieve data
	local data = server.udp:receive()
	
	--If data is recieved, respond
	if data then return network.response(data) end
	
	--If network is down (over 'server.timeout' seconds have passed since last pong), error out.
	if network.isDown() then jLib.error("Seems we've lost connection to the server! Either there are problems on our end, or you just lost internet connection. We suggest trying again in a few minutes. Error code: NOPONG") end
	
	--Return false for print function in main
	return false
end

function network.isDown()
	local time = love.timer.getTime() + server.timeout
	local pong = server.pong
	
	if pong > time then return true else return false end
end

function network.send(data)
	if not data then return end
	assert(type(data) == "string", "network.send() 'data' argument was not a string.")
	local success, err = server.udp:send(data)
	if err then error(err) end
	return "Data sent!"
end

function network.get()
	return server.udp:receive()
end

function network.response(data)
	local response
	
	data = jLib.destringify(data)
	
	--Responses
	if     data.id == "PONG"      then server.pong = love.timer.getTime()
	elseif data.id == "BROADCAST" then game.broadcast.func(data.message)
	elseif data.id == "PLAYERS"   then game.updatePlayers(data.clients)
	else   print("No response for " .. data.id)
	end
	
	--Console logs (All of this can be commented out with no impact)
	if data.id == "PONG" then print("Pong!")
	end
	
	return response
end