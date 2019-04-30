con = {}

con.font = love.graphics.newFont("assets/terminal.ttf")
con.fontHeight = con.font:getHeight()
con.fontWidth = con.font:getWidth("a") -- Get the width of a single character
con.text = ""
con.inputText = ""
con.index = 0
con.lineAmount = 0
con.inputLineAmount = math.floor((con.text:len() + 1) * con.fontWidth / win.width) -- Also calculated in love.textinput callback
con.maxVisibleLines = win.height / con.fontHeight
con.maxLines = 500 --Any line after this amount will be deleted.
con.x, con.y, con.yNudge = 0, 3948, 0
con.history, con.historyIndex = {}, 1
con.scrollIndex = math.floor(math.min(math.max(win.height, 2 + ((win.height / 30) / 2)), win.height - ((win.height / 30) / 2) - 2))
con.isHighlighted = false
con.isCool = true

con.log = function()
	love.graphics.setColor(1,1,1,1)
	love.graphics.printf(con.text, con.font, con.x, con.y +	con.yNudge, win.width - 15)
end

con.input = function()
	love.graphics.setColor(1,1,1,1)
	if con.isHighlighted then 
		love.graphics.setColor(0,0,0,1)
	end
	love.graphics.printf(con.inputText, con.font, con.x, con.y + con.yNudge + (con.lineAmount * con.fontHeight), win.width - 15)
end

con.print = function(...)
	if not con.isCool then return end
	local text = ""
	local args = {...}
	for i = 1, #args, 1 do
		if i == 1 then
			text = tostring(args[1]) --First argument
		else
			text = text .. ", " .. tostring(args[i]) --The rest of the args
		end
	end
	if con.text ~= "" then con.text = con.text .. "\n" .. text else con.text = text end --Don't add a new line if it's the first line
	con.lineAmount = con.lineAmount + math.ceil((text:len() + 1) * con.fontWidth / win.width)
	--con.isCool = false
end

con.cooldown = function()
	if con.isCool then return end
	local timer = love.timer.getTime()
	local amt = .1  --Cooldown length
	if timer - amt > win.time then
		con.isCool = true
		win.time = love.timer.getTime()
	end
end

con.cursor = function()
	local x = con.x - (con.inputLineAmount * (win.width - 15)) + (con.inputLineAmount * 2) + (con.index * con.fontWidth)
	local y = (con.y + con.fontHeight - 4) + con.yNudge + (con.lineAmount * con.fontHeight) + (con.inputLineAmount * con.fontHeight)
	
	love.graphics.setColor(1,1,1,1)
	love.graphics.rectangle("fill", x, y, 8, 3)
end

con.highlight = function()
	if con.isHighlighted then
		local width = math.min(con.inputText:len() * con.fontWidth, win.width - 15)
		local height = math.max(con.inputLineAmount, 1) * con.fontHeight
		
		love.graphics.setColor(1,1,1,1)
		love.graphics.rectangle("fill", con.x, con.y + con.yNudge + (con.lineAmount * con.fontHeight), width, height)
	end
end

con.blink = function()
	local newTime = love.timer.getTime()
	if newTime - win.time > 0 and newTime - win.time < .5 then
		return true
	elseif newTime - win.time > .5 and newTime - win.time < 1 then
		return false
	elseif newTime - win.time > 1 then
		win.time = love.timer.getTime()
		return true
	end
end

con.scroll = function()
	local mode = "fill"
	local barW, barH = 15, win.height
	local barX, barY = win.width - barW, 0
	
	local scrollW, scrollH = barW - 4, barH / 30
	local scrollX, scrollY = barX + 2, 0 - scrollH
	
	love.graphics.setColor(1,1,1,1)
	love.graphics.rectangle(mode, barX, barY, barW, barH)
	love.graphics.setColor(0,0,0,1)
	love.graphics.rectangle(mode, scrollX, scrollY + con.scrollIndex + (scrollH / 2), scrollW, scrollH)
end

con.draw = function()
	con.log()
	con.highlight()
	con.input()
	con.scroll()
	if con.blink() then
		con.cursor()
	end
end

con.update = function(dt)
	con.yNudge = -(con.scrollIndex * con.fontHeight) - (con.inputLineAmount * con.fontHeight) - (con.lineAmount * con.fontHeight)
	
	if love.mouse.isDown(1) then
		local mx, my = love.mouse.getPosition()
		if mx >= win.width - 15 then
			local border = 2
			local scrollbarHeight = ((win.height / 30) / 2)
			con.scrollIndex = math.floor(math.min(math.max(my, border + scrollbarHeight), win.height - scrollbarHeight - border))
		end
	end
	
	if love.keyboard.isDown("lctrl") and love.keyboard.isDown("a") then
		con.isHighlighted = true
	elseif love.keyboard.isDown("lctrl") and love.keyboard.isDown("c") then
		love.system.setClipboardText(con.inputText)
		con.isHighlight = false
	elseif love.keyboard.isDown("lctrl") and love.keyboard.isDown("v") then
		con.inputText = love.system.getClipboardText()
		con.index = con.inputText:len()
	end
	
	con.cooldown()
end

function love.mousepressed(x, y, button)
	con.isHighlighted = false
end

function love.wheelmoved(x, y)
	if con.scrollIndex >= 304 and y < 0 then return
	elseif con.scrollIndex <= 7 and y > 0 then return
	end
	
	local border = 2
	local scrollbarHeight = ((win.height / 30) / 2)
	
	con.scrollIndex = math.floor(math.min(math.max(con.scrollIndex, border + scrollbarHeight), win.height - scrollbarHeight - border)) - y
end