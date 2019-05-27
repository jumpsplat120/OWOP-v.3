settings = {}

--------------Define the Color Picker--------------

settings.colorPicker = {}
settings.colorPicker.triangle = {}
settings.colorPicker.ring = {}
settings.colorPicker.innerCircle = {}
settings.colorPicker.tinyCircle = {}

local cw, ch = jLib.window.width / 2, jLib.window.height / 2

settings.colorPicker.ring = CircleButton(cw, ch, 100, "fill", "", jLib.color.red)
settings.colorPicker.innerCircle = CircleButton(cw, ch, 80, "fill", "", jLib.color.white) --Whatever the color of the background is
settings.colorPicker.triangle = TriangleButton(cw, ch, 140)
settings.colorPicker.tinyCircle = RingButton(cw, ch, 5, "fill", "", jLib.color.grey)