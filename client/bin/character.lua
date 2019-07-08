Character = Object:extend()

function Character:new(color, name, scale, x, y, rot, chat)
	self.x, self.y = x or 0, y or 0
	self.rot = rot or 0
	self.color = color or jLib.color.white
	self.name = name or "Player" .. tostring(math.random(0,1000))
	self.scale = scale or 1
	self.size = 50
	self.canvas = love.graphics.newCanvas(self.size * self.scale * 2, self.size * self.scale * 2)
end

function Character:draw()
	local size = self.size * self.scale

	love.graphics.setCanvas(self.canvas)
		love.graphics.setColor(self.color)
		love.graphics.circle("fill", size, size, size)
		love.graphics.setScissor(0, 0, size, size)
		love.graphics.rectangle("fill", 0, 0, size * 2, size * 2, size / (3 + (1/3)), size / (3 + (1/3)), size / 2)
		love.graphics.setScissor()
	love.graphics.setCanvas()
	
	print("Drawing character canvas at x: " .. self.x .. " and y: " .. self.y .. " with a rotation of " .. self.rot .. " and size of " .. size)
	love.graphics.draw(self.canvas, self.x, self.y, self.rot, 1, 1, size, size)
end

function Character:update(dt)
	if     controls.forward.isPressed   then 
	elseif controls.backwards.isPressed then
	end
	
	if     controls.left.isPressed  then self.rot = (self.rot - .1) * dt
	elseif controls.right.isPressed then self.rot = (self.rot + .1) * dt
	end
end