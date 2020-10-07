local function PopulateHeroesPanel(parent)
	local form = CreateTTT2Form(parent, "header_addons_heroes")

	form:MakeCheckBox({
		label = "label_heroes_auto_place_enable",
		convar = "ttt_crystal_auto"
	})
end

hook.Add("TTT2ModifyHelpSubMenu", "ttt2_populate_heroes_settings", function(helpData, menuId)
	if not GetGlobalBool("ttt2_classes") or not GetGlobalBool("ttt2_heroes") or menuId ~= "ttt2_addons" then return end

	local heroesSettings = helpData:PopulateSubMenu(menuId .. "_heroes")

	heroesSettings:SetTitle("submenu_addons_heroes_title")
	heroesSettings:PopulatePanel(PopulateHeroesPanel)
end)
