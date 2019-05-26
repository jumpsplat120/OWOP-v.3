game = {}

--Wrapper function for network.sendtoall()--
function game.broadcast(data)
	local data = "Broadcast:" .. data
	network.sendtoall(data)
end