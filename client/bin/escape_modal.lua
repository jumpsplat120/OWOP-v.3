escape_modal = {}

function escape_modal.load()

	local cw, ch = jLib.window.width / 2, jLib.window.height / 2
	local w = 150
	local h = w / 3
	local margin = 25
		
	game.escapeModal.resumeButton = {}
	game.escapeModal.settingsButton = {}
	game.escapeModal.friendsButton = {}
	game.escapeModal.escapeButton = {}

	game.escapeModal.background = function() love.graphics.rectangle("fill", 0, 0, jLib.window.width, jLib.window.height) end

	game.escapeModal.resumeButton.regular = RectButton(cw, ch - (h * 1.5) - (margin * 1.5), w, h, "line", "RESUME", game.player.color)
	game.escapeModal.settingsButton.regular = RectButton(cw, ch - (h * .5) - (margin * .5), w, h, "fill", "SETTINGS", game.player.color)
	game.escapeModal.friendsButton.regular = RectButton(cw, ch + (h * .5) + (margin * .5), w, h, "fill", "FRIENDS", game.player.color)
	game.escapeModal.escapeButton.regular = RectButton(cw, ch + (h * 1.5) + (margin * 1.5), w, h, "fill", "MENU", game.player.color)

	game.escapeModal.resumeButton.hover = RectButton(cw, ch - (h * 1.5) - (margin * 1.5), w + (w/4), h + (h/4), "line", "RESUME", game.player.color)
	game.escapeModal.settingsButton.hover = RectButton(cw, ch - (h * .5) - (margin * .5), w + (w/4), h + (h/4), "fill", "SETTINGS", game.player.color)
	game.escapeModal.friendsButton.hover = RectButton(cw, ch + (h * .5) + (margin * .5), w + (w/4), h + (h/4), "fill", "FRIENDS", game.player.color)
	game.escapeModal.escapeButton.hover = RectButton(cw, ch + (h * 1.5) + (margin * 1.5), w + (w/4), h + (h/4), "fill", "MENU", game.player.color)

	game.escapeModal.resumeButton.click = RectButton(cw, ch - (h * 1.5) - (margin * 1.5), w - (w/4), h - (h/4), "line", "RESUME", game.player.color)
	game.escapeModal.settingsButton.click = RectButton(cw, ch - (h * .5) - (margin * .5), w - (w/4), h - (h/4), "fill", "SETTINGS", game.player.color)
	game.escapeModal.friendsButton.click = RectButton(cw, ch + (h * .5) + (margin * .5), w - (w/4), h - (h/4), "fill", "FRIENDS", game.player.color)
	game.escapeModal.escapeButton.click = RectButton(cw, ch + (h * 1.5) + (margin * 1.5), w - (w/4), h - (h/4), "fill", "MENU", game.player.color)
end