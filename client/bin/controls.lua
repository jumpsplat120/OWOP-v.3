controls = {
	forward   = {},
	backwards = {},
	left      = {},
	right     = {},
	escape    = {},
	action    = {},
	context   = {}
}

for k, v in pairs(controls) do
	controls[k] = {
		key = nil,
		isPressed = false,
		isReleased = false
	}
end

function setDefaultControls()
	print("Loading default control scheme...")
	controls.forward.key   = "w"
	controls.backwards.key = "s"
	controls.left.key      = "a"
	controls.right.key     = "d"
	controls.escape.key    = "escape"
	controls.action.key    = "lclick"
	controls.context.key   = "rclick"
end

function setDefaultControlState()
	for k, v in pairs(controls) do
		controls[k].isReleased = false
	end
end