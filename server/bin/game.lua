game = {}

--Wrapper function for network.sendtoall()--
function game.broadcast(message)
	network.sendtoall(jLib.stringify({id = "BROADCAST", data = message}))
end