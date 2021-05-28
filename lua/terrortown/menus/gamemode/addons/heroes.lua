CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"

CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = "submenu_addons_heroes_title"

function CLGAMEMODESUBMENU:Populate(parent)
	local form = vgui.CreateTTT2Form(parent, "header_addons_heroes")

	form:MakeCheckBox({
		label = "label_heroes_auto_place_enable",
		convar = "ttt_crystal_auto"
	})
end

function CLGAMEMODESUBMENU:ShouldShow()
	return GetGlobalBool("ttt2_classes") and GetGlobalBool("ttt2_heroes")
end
