hook.Add("TTT2ModifySettingsList", "TTT2CrystalBindings", function(tbl)
	if not GetGlobalBool("ttt2_classes") or not GetGlobalBool("ttt2_heroes") then return end

	local heroesTbl = {}
	heroesTbl.id = "heroes"
	heroesTbl.getContent = function(slf, parent)
		local dguiT = vgui.Create("DForm", parent)
		dguiT:SetName(LANG.GetTranslation("ttt2_heroes_settings_crystal"))
		dguiT:CheckBox(LANG.GetTranslation("ttt2_heroes_settings_autoplace"), "ttt_crystal_auto")

		dguiT:Dock(TOP)
	end

	tbl[#tbl + 1] = heroesTbl
end)

