start_menu = {}

function start_menu.load()
	local cw, ch = jLib.window.width / 2, jLib.window.height / 2
	local w = 150
	local h = w / 3

	game.startButton = {}
	game.settingsButton = {}
	game.friendsButton = {}

	game.startButton.regular = RectButton(cw, ch + h, w, h, "fill", "PLAY", game.player.color)
	game.settingsButton.regular = RectButton(cw, ch, w, h, "line", "SETTINGS", game.player.color)
	game.friendsButton.regular = RectButton(cw, ch - h, w, h, "fill", "FRIENDS", game.player.color)

	game.startButton.hover = RectButton(cw, ch + h, w, h, "fill", "PLAY", game.player.color)
	game.settingsButton.hover = RectButton(cw, ch, w, h, "line", "SETTINGS", game.player.color)
	game.friendsButton.hover = RectButton(cw, ch - h, w, h, "fill", "FRIENDS", game.player.color)

	game.startButton.click = RectButton(cw, ch + h, w, h, "line", "PLAY", game.player.color)
	game.settingsButton.click = RectButton(cw, ch, w, h, "fill", "SETTINGS", game.player.color)
	game.friendsButton.click = RectButton(cw, ch - h, w, h, "line", "FRIENDS", game.player.color)
end

