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
	print("Connecting...")
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
	-- Check if server is up
	server.ping()
	
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
	return "Data Sent... " .. data
end

function network.get()
	return server.udp:receive()
end

function network.response(data)
	if     data == "Pong!" then server.pong = love.timer.getTime()
	elseif data == "SPAM_TEST" then network.spamTest(50)
	elseif string.find(data, "Broadcast:") then game.broadcast.func(data)
	elseif string.find(data, "Players:") then print("Drawing other players...")
	end
	return data
end

function network.spamTest(amt)
	local index = 0
	while index < amt do
		network.send(jLib.stringify({id = "SPAM", data = tostring(index)}))
		index = index + 1
	end
end