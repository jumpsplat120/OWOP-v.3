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

TriangleButton = Object:extend()

function TriangleButton:new(x, y, size, rot, design, text, color, textColor)
	self.x, self.y = x or 0, y or 0
	self.rot = rot or 0
	self.size = size or 50
	self.design = design or "fill" --fill/line
	self.text = text or ""
	self.color = color or jLib.color.red
	self.textColor = textColor or jLib.color.white
	self.vert = {}
end

function TriangleButton:draw()
	local cc = self.size / 2
	local nudge = self.size / 10 --Triangle draws slightly higher than it should, because equilateral triangle
	local tx, ty = cc, cc - ((math.sqrt(3)/3) * self.size) + nudge
	local rx, ry = cc + (self.size / 2), cc + ((math.sqrt(3)/6) * self.size) + nudge
	local lx, ly = cc - (self.size / 2), cc + ((math.sqrt(3)/6) * self.size) + nudge
	
	love.graphics.push()
		love.graphics.setColor(self.color)
		
		--ROTATE AROUND CENTER
		love.graphics.translate(self.x, self.y)
		love.graphics.rotate(self.rot)
		love.graphics.translate(-self.x, -self.y)
		
		--TRANSLATE TO PASSED X, Y
		love.graphics.translate(self.x, self.y)
		
		--CENTER POLYGON
		love.graphics.translate(-cc, -cc)
		
		--NUDGE UP
		love.graphics.translate(0, -nudge)
		
		--DRAW TRIANGLE AND TEXT
		love.graphics.polygon(self.design, tx, ty, rx, ry, lx, ly)
		love.graphics.setColor(self.textColor)
		love.graphics.printf(self.text, game.font, self.size / 2, self.size / 2, jLib.printf.nowrap, "left", 0)
		
	love.graphics.pop()
end

function TriangleButton:update(dt)
	--[[*We use seperate versions of the same coord set
		*due to the version that we use for the poly code
		*are all set with a 0,0 origin. That's because we
		*are drawing the triangle into a canvas, to make
		*make rotating the triangle easier. But that means
		*that we have two sets of points. The points
		*that are accessible by self.vert are accurate, but
		*but are not the points actually being used to draw
		*the triangle. Modifying the vertex points will NOT
		*do anything to modify the shape.
	--]]
	local tx, ty = self.x, self.y - ((math.sqrt(3)/3) * self.size)
	local rx, ry = self.x + (self.size / 2), self.y + ((math.sqrt(3)/6) * self.size)
	local lx, ly = self.x - (self.size / 2), self.y + ((math.sqrt(3)/6) * self.size)
	
	self.vert = {tx, ty, rx, ry, lx, ly}
end

------------------Ring Button------------------

RingButton = CircleButton:extend()

function RingButton:new(x, y, r, design, text, color, textColor)
	RingButton.super.new(self, x, y, r, design, text, color, textColor)
end

function RingButton:draw()
	local scale = (.2 * game.scale) * ((self.r * 2) / game.font:getHeight()) * (4.5 / self.text:len())
	
	love.graphics.push()
		
		--ROTATE CIRCLE AROUND CENTER OF TRIANGLE
		love.graphics.translate(settings.colorPicker.triangle.x, settings.colorPicker.triangle.y)
		love.graphics.rotate(settings.colorPicker.triangle.rot)
		love.graphics.translate(-settings.colorPicker.triangle.x, -settings.colorPicker.triangle.y)
		
		--CREATE CIRCLE STENCIL
		love.graphics.stencil(function() love.graphics.circle(self.design, self.x, self.y, self.r - (self.r * .2)) end)
		love.graphics.setStencilTest("less", 1)
		
		--DRAW CIRCLE, WITH STENCIL PORTION CUT OUT
		love.graphics.setColor(self.color)
		love.graphics.circle(self.design, self.x, self.y, self.r)
		
		--DRAW TEXT
		if self.design == "fill" then love.graphics.setColor(self.textColor) else love.graphics.setColor(self.color) end
		love.graphics.printf(self.text, game.font, self.x, self.y, jLib.printf.nowrap, "left", 0, scale, scale, game.font:getWidth(self.text) / 2, game.font:getHeight() / 2)
		
		--UNDO STENCIL
		love.graphics.setStencilTest()
		
	love.graphics.pop()
end

function RingButton:update(dt)
end