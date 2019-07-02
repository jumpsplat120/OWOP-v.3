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
		key = "NULL",
		isPressed = false
	}
end

function setDefaultControls()
	controls.forward.key   = "w"
	controls.backwards.key = "s"
	controls.left.key      = "a"
	controls.right.key     = "d"
	controls.escape.key    = "esc"
	controls.action.key    = "lclick"
	controls.context.key   = "rclick"
end