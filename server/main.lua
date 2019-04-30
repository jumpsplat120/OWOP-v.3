require "bin/window"
require "bin/console"
require "bin/read"
require "bin/network"
require "bin/game"

function love.load()
end

function love.draw()
	con.draw()
end

function love.update(dt)
	local ip, port, data = network.update(dt)
	if data then
		con.print(data, ip, port)
		local response = network.response(data, ip, port)
		con.print("Responded with '" .. tostring(response) .. "'")
	end
	con.update(dt)
end