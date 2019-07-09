controls = {
	forward   = {},
	backwards = {},
	left      = {},
	right     = {},
	escape    = {},
	action    = {},
	context   = {},
	isMouse   = {}
}

for k, v in pairs(controls) do
	controls[k] = {
		key = nil,
		isPressed = false,
		isReleased = false
	}
end

function controls.setDefault()
	print("Loading default control scheme...")
	controls.forward.key   = "w"
	controls.backwards.key = "s"
	controls.left.key      = "a"
	controls.right.key     = "d"
	controls.escape.key    = "escape"
	controls.action.key    = "lclick"
	controls.context.key   = "rclick"
	
	controls.isMouse[1]    = "action"
	controls.isMouse[2]    = "context"
end

function controls.loadSave(save)
	print("Loading saved controls...")
	
	controls.forward.key   = save.forward.key
	controls.backwards.key = save.backwards.key
	controls.left.key      = save.left.key
	controls.right.key     = save.right.key
	controls.escape.key    = save.escape.key
	controls.action.key    = save.action.key
	controls.context.key   = save.context.key
	
	for k, v in pairs(controls) do
		if not (type(controls[k]) == "function") then
			local key = controls[k].key
		
			if (key == "lclick") or (key == "rclick") or (key == "mclick") then controls.isMouse[#controls.isMouse + 1] = tostring(k) end
		end
	end
end

function controls.reset()
	for k, v in pairs(controls) do
		if not (type(controls[k]) == "function") then controls[k].isReleased = false end
	end
end