require "bin/window"
require "bin/console"
require "bin/read"
require "bin/network"
require "bin/game"
require "bin/jLib"

function love.load()
end

function love.draw()
	con.draw()
end

function love.update(dt)
	local ip, port, data = network.update(dt)
	if data then network.response(data, ip, port) end
	con.update(dt)
end