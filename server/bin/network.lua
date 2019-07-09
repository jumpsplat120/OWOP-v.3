local socket = require "socket"

-- 'server' for internal use
local server = {
	timeout = 0,
	address = {ip = "192.168.1.65", port = 1051},	-- Local IP, forwarded port
	clients = {}
}

-- 'network' for external use
network = {}

server.udp = socket.udp()
server.udp:settimeout(server.timeout)
server.udp:setsockname(server.address.ip, server.address.port)
server.ip, server.port = server.udp:getsockname()
con.print("Server started...", server.ip, server.port)

function server.checkConnectedClients()
	for k, v in pairs(server.clients) do
		local currTime = love.timer.getTime()
		if server.clients[k].timer + 2 < currTime then table.remove(server.clients, k) end
	end
end

function network.update(dt)
	server.checkConnectedClients()
	local data, ip, port = server.udp:receivefrom()
	if data then return ip, port, data else return false end
end

function network.response(data, address, port)
	local response
	
	data = jLib.destringify(data) or {id = false}
	
	if     data.id == "PING"        then response = network.pong(address, port)
	elseif data.id == "REQ_CONNECT" then response = network.newClient(address, port, data.data)
	elseif data.id == "PLAYER_INFO" then response = network.updateClient(address, port, data.data)
	elseif data.id then con.print("[ERROR] Missing response for ID: " .. data.id)
	end
	
	if response then network.sendto(response, address, port) end
		
	return response
end

function server.pongTimer(address, port)
	for k, v in pairs(server.clients) do
		if server.clients[k].ip == address then server.clients[k].timer = love.timer.getTime() end
	end
end

function network.pong(address, port)
	con.print("Ping recieved from", address, port)
	
	server.pongTimer(address, port)
	
	con.print("Pong sent back!")
	
	return jLib.stringify({id = "PONG", message = "Pong!"})
end

function network.newClient(address, port, data)
	con.print("Connection request recieved from", address, port)
	
	server.clients[#server.clients + 1] = { ip    = address,
											port  = port,
											timer = love.timer.getTime(),
											info  = {   name  = data.name,
														x     = 0,
														y     = 0,
														rot   = data.rot,
														color = data.color,
														chat  = "",
														uuid  = data.uuid,
														state = data.state}}
	
	con.print("Client connected!")
														
	return jLib.stringify({id = "CONNECT_STATUS", status = "Connected!"})
end

function network.updateClient(address, port, data)
	server.pongTimer(address, port)
	
	for i = 1, #server.clients, 1 do
		if (server.clients[i].ip == address) and (server.clients[i].port == port) then
			server.clients[i].info.name  = data.name
			server.clients[i].info.x     = data.x
			server.clients[i].info.y     = data.y
			server.clients[i].info.rot   = data.rot
			server.clients[i].info.color = data.color
			server.clients[i].info.chat  = data.chat
			server.clients[i].info.uuid  = data.uuid
			server.clients[i].info.state = data.state
			
			local clients = {}
			for i = 1, #server.clients, 1 do clients[i] = server.clients[i].info end
			return jLib.stringify({id = "PLAYERS", clients = clients})
		end
	end
end

function network.sendto(data, address, port)
	assert(type(data) == "string", "network.sendto() 'data' argument was not a string.")
	local success, err = server.udp:sendto(data, address, port)
	if err then error(err) end
	return "sent " .. data
end

function network.sendtoall(data)
	if #server.clients == 0 then 
		con.print("No one connected to send this to :(")
		return
	end
	assert(type(data) == "string", "network.send() 'data' argument was not a string.")
	for k, v in pairs(server.clients) do
		con.print("Sending to...", server.clients[k].ip, server.clients[k].port)
		local success, err = server.udp:sendto(data, server.clients[k].ip, server.clients[k].port)
		if err then error(err) end
	end
end