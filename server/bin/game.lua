game = {}

function game.broadcast(message)
	assert(type(message) == "string", "game.broadcast() 'message' argument was not a string.")
	local data, err = network.send(message)
	if err then con.print(err) else con.print(data) end
end