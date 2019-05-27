local socket = require "socket"

-- server for internal use
local server = {
	timeout = 0,
	address = {ip = "108.230.159.104", port = 1051},	-- Public IP, port
	time = love.timer.getTime(),
	pong = love.timer.getTime()
}

--network for external use
network = {}

server.udp = socket.udp()
server.udp:settimeout(server.timeout)
server.udp:setpeername(server.address.ip, server.address.port)
server.peer_ip, server.peer_port = server.udp:getpeername()

function server.ping()
	local currTime = love.timer.getTime()
	if server.time + 1 < currTime then
		local success, err = server.udp:send("Ping!")
		if err then error(err) end
		server.time = love.timer.getTime()
	end
end

function network.load()
	local success_or_nil, err = server.udp:send("Requesting connection...")
	if err then error(err) end
	local data = server.udp:receive()
	game.timer = love.timer.getTime()
	if not data then 
		game.isConnected = false
		return
	end
	game.isConnected = true
	print("Connected to ", server.peer_ip, server.peer_port)
end

function network.update(dt)
	server.ping()
	local data = server.udp:receive()
	if data then return network.response(data) end
	local currTime = love.timer.getTime()
	if server.pong + 3 < currTime then jLib.error("Seems we've lost connection to the server! Either there are problems on our end, or you just lost internet connection. We suggest trying again in a few minutes. Error code: NOPONG") end
	return false
end

function network.send(data)
	assert(type(data) == "string", "network.send() 'data' argument was not a string.")
	local success, err = server.udp:send(data)
	if err then error(err) end
	return "Data Sent... " .. data
end

function network.get()
	return server.udp:receive()
end

function network.response(data)
	if data == "Pong!" then
		server.pong = love.timer.getTime()
	elseif data == "SPAM_TEST" then
		network.spamTest(50)
	elseif string.find(data, "Broadcast:") then
		game.broadcast.func(data)
	end
	return data
end

function network.spamTest(amt)
	local index = 0
	while index < amt do
		network.send("Spam... " .. tostring(index))
		index = index + 1
	end
end