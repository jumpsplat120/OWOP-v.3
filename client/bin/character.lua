Character = Object:extend()

local function getUUID()
	local alphanumeric = jLib.getAlphaNumeric()
	local uuidTable = {}
	local uuid = ""
	
	--UUID TEMPLATE: xxxxxx-xxxx-xxxxxx
	for i = 1, 16, 1 do uuidTable[i] = alphanumeric[math.random(1, #alphanumeric)] end
	
	for i = 1, 6, 1 do uuid = uuid .. uuidTable[i] end
	
	uuid = uuid .. "-"
	
	for i = 6, 10, 1 do uuid = uuid .. uuidTable[i] end
	
	uuid = uuid .. "-"
	
	for i = 10, 16, 1 do uuid = uuid .. uuidTable[i] end

	return uuid
end

function Character:new(color, name, scale, x, y, rot, chat, uuid)
	self.x     = x     or 0
	self.y     = y     or 0
	self.rot   = rot   or 0
	self.color = color or jLib.color.white
	self.name  = name  or "Player" .. tostring(math.random(0,1000))
	self.scale = scale or 1
	self.chat  = chat  or ""
	self.uuid  = uuid or getUUID()
	
	self.size   = 50
	self.canvas = love.graphics.newCanvas(self.size * self.scale * 2, self.size * self.scale * 2)
	
	self.velocity = {}
	self.velocity.current = 0
	self.velocity.drag    = 3
	
	--Accessibly stored variables, might want to be changed on interaction with things
	self.speed = {}
	self.speed.rotation = 5
	self.speed.forward  = 10
	self.speed.max      = 25
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
	
	love.graphics.draw(self.canvas, self.x, self.y, self.rot, 1, 1, size, size)
end

function Character:update(dt)
	local sin, cos = math.sin(self.rot + (math.pi * -.75)), math.cos(self.rot + (math.pi * -.75))
	
	--Add forward/backwards velocity
	if     controls.forward.isPressed   then self.velocity.current = math.min(self.velocity.current + self.speed.forward * dt, self.speed.max)
	elseif controls.backwards.isPressed then self.velocity.current = math.max(self.velocity.current - self.speed.forward * dt, -self.speed.max)
	end
	
	--Move in that direction
	self.x = self.x + cos * self.velocity.current
	self.y = self.y + sin * self.velocity.current
	
	--Rotate
	if     controls.left.isPressed  then self.rot = self.rot + self.speed.rotation * dt
	elseif controls.right.isPressed then self.rot = self.rot - self.speed.rotation * dt
	end
	
	--Slow down velocity over time (trend towards zero)
	if     self.velocity.current > 0 then self.velocity.current = math.max(self.velocity.current - self.velocity.drag * dt, 0)
	elseif self.velocity.current < 0 then self.velocity.current = math.min(self.velocity.current + self.velocity.drag * dt, 0)
	end
end