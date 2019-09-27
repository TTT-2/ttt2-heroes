hook.Add("TTT2ModifySettingsList", "TTT2CrystalBindings", function(tbl)
	if not GetGlobalBool("ttt2_classes") or not GetGlobalBool("ttt2_heroes") then return end

	local heroesTbl = {}
	heroesTbl.id = "heroes"
	heroesTbl.getContent = function(slf, parent)
		local dguiT = vgui.Create("DForm", parent)
		dguiT:SetName("Crystal")
		dguiT:CheckBox("Automatically try placing a Crystal", "ttt_crystal_auto")

		dguiT:Dock(TOP)
	end

	tbl[#tbl + 1] = heroesTbl
end)

