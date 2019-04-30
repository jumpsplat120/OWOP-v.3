love.keyboard.setKeyRepeat(true) -- Have to set key repeat to true to backspace multiple characters while holding the button down.

function processInput(text)
	local func, err = loadstring(text)
	if err then
		con.print(err)
	else
		func()
	end
end

function love.textinput(text)
	if con.index == con.inputText:len() then
		con.inputText = con.inputText .. text
	else
		local h1 = string.sub(con.inputText, 1, con.index)
		local h2 = string.sub(con.inputText, con.index + 1, con.inputText:len())
		con.inputText = h1 .. text .. h2
	end
	con.index = con.index + 1
	con.inputLineAmount = math.floor((con.inputText:len() + 1) * con.fontWidth / (win.width - 15))
end

function love.keypressed(key, scancode, isRepeat)
	if key == "return" then
		if con.text ~= "" then con.text = con.text .. "\n> " .. con.inputText else con.text = "> " .. con.inputText end --The very first line should not have a newline attached to it
		con.lineAmount = con.lineAmount + math.ceil((con.inputText:len() + 1) * con.fontWidth / (win.width - 15))
		processInput(con.inputText)
		table.insert(con.history, 1, con.inputText)
		if con.historyIndex > 50 then table.remove(con.history, 50) end
		con.historyIndex, con.index, con.inputLineAmount, con.inputText = 1, 0, 0, ""
	elseif key == "backspace" then
		if con.isHighlighted then 
			con.inputText = ""
			con.index = 0
			return
		end
		local h1 = string.sub(con.inputText, 1, con.index)
		local h2 = string.sub(con.inputText, con.index + 1, con.inputText:len())
		h1 = backspace(h1)
		con.inputText = h1 .. h2
		if con.index > 1 then con.index = con.index - 1 else con.index = 0 end
	elseif key == "left" then
		if con.index >= 1 then con.index = con.index - 1 else con.index = 0 end
	elseif key == "right" then
		if con.index < con.inputText:len() then con.index = con.index + 1 else con.index = con.inputText:len() end
	elseif key == "up" then
		con.inputText = con.history[con.historyIndex] or con.history[#con.history]
		con.index = con.inputText:len()
		con.historyIndex = con.historyIndex + 1	
	end
	con.isHighlighted = false
end

-- removes the last letter of a string, and returns the new string
function backspace(str)
	if str:len() <= 1 then return "" end
	local ans = ""
	local i = 0
	local length = string.len(str)
	repeat
		i = i + 1
		ans = ans .. string.char(string.byte(str, i))
	until string.len(ans) == length - 1
	return ans
end