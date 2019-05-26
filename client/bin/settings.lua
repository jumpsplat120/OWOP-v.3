settings = {}

--------------Define the Color Picker--------------

settings.colorPicker = {}
settings.colorPicker.triangle = {}
settings.colorPicker.circle = {}

local cw, ch = jLib.window.width / 2, jLib.window.height / 2

settings.colorPicker.circle = CircleButton(cw, ch, 100, "fill", "", jLib.color.red)