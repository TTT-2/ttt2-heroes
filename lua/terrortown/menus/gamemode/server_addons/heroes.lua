CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = "submenu_server_addons_heroes_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_server_addons_heroes")

	form:MakeHelp({
		label = "help_heroes_enable"
	})

	form:MakeCheckBox({
		serverConvar = "ttt2_heroes",
		label = "label_heroes_enable"
	})

	form:MakeHelp({
		label = "help_heroes_max_crystal_pickups"
	})

	form:MakeSlider({
		serverConvar = "ttt2_heroes_max_crystal_pickups",
		label = "label_heroes_max_crystal_pickups",
		min = -1,
		max = 32,
		decimal = 0
	})
end
