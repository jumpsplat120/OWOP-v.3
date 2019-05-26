------------------Rectangle Button------------------

RectButton = Object:extend()

function RectButton:new(x, y, w, h, design, text, color, textColor)
	self.x, self.y = x or 0, y or 0
	self.w, self.h = w or 100, h or 100
	self.design = design or "fill" --fill/line
	self.text = text or "button"
	self.color = color or jLib.color.red
	self.textColor = textColor or jLib.color.white
end

function RectButton:draw()
	local scale = (.2 * game.scale) * (self.w / game.font:getHeight()) * (4.5 / self.text:len()) --That awkward moment when you did math a long time ago and now you don't know how something works xD
	
	love.graphics.setColor(self.color)
	love.graphics.rectangle(self.design, self.x - (self.w * game.scale / 2), self.y - (self.h * game.scale / 2), self.w * game.scale, self.h * game.scale)
	if self.design == "fill" then 
		love.graphics.setColor(self.textColor) 
	else
		love.graphics.setColor(self.color) 
	end
	love.graphics.printf(self.text, game.font, self.x, self.y, jLib.printf.nowrap, "left", 0, scale, scale, game.font:getWidth(self.text) / 2, game.font:getHeight() / 2)
end

function RectButton:update(dt)
end

------------------Circle Button------------------

CircleButton = Object:extend()

function CircleButton:new(x, y, r, design, text, color, textColor)
	self.x, self.y = x or 0, y or 0
	self.r = r or 25
	self.design = design or "fill" -- fill/line
	self.text = text or ""
	self.color = color or jLib.color.red
	self.textColor = textColor or jLib.color.white	
end

function CircleButton:draw()
	local scale = (.2 * game.scale) * ((self.r * 2) / game.font:getHeight()) * (4.5 / self.text:len())
	
	love.graphics.setColor(self.color)
	love.graphics.circle(self.design, self.x, self.y, self.r)
	if self.design == "fill" then 
		love.graphics.setColor(self.textColor) 
	else
		love.graphics.setColor(self.color) 
	end
	love.graphics.printf(self.text, game.font, self.x, self.y, jLib.printf.nowrap, "left", 0, scale, scale, game.font:getWidth(self.text) / 2, game.font:getHeight() / 2)
end

function CircleButton:update(dt)
end

------------------Triangle Button------------------