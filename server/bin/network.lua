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

function server.updateConnected()
	for k, v in pairs(server.clients) do
		local currTime = love.timer.getTime()
		if server.clients[k].timer + 2 < currTime then table.remove(server.clients, k) end
	end
end

function network.update(dt)
	server.updateConnected()
	local data, err_or_ip, port_or_nil = server.udp:receivefrom()
	if data then return err_or_ip, port_or_nil, data end
	return false
end

function network.response(data, address, port)
	local response

	if data == "Ping!" then
		for k, v in pairs(server.clients) do
			if server.clients[k].ip == address then server.clients[k].timer = love.timer.getTime() end
			local msg, err = network.sendto("Pong!", address, port)
			response = "Pong!"
		end
	elseif data == "Requesting connection..." then
		local msg, err = network.sendto("Connected!", address, port)
		if err then error(err) end
		local newClient = {
			ip = address,
			port = port,
			timer = love.timer.getTime()
		}
		server.clients[#server.clients + 1] = newClient
		response = "Connected!"
	end
	
	return response
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