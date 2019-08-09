local GetLang

hook.Add("TTT2ModifySettingsList", "TTT2CrystalBindings", function(tbl)
	if not GetGlobalBool("ttt2_heroes") then return end

	local heroesTbl = {}
	heroesTbl.id = "heroes"
	heroesTbl.getContent = function(slf, parent)
		local dgui = vgui.Create("DForm", parent)
		dgui:SetName("Bindings") -- TODO Add localization

		-- Crystal placement
		local dTPlabel = vgui.Create("DLabel")
		dTPlabel:SetText("Place Crystal:")
		dTPlabel:SetTextColor(COLOR_BLACK)

		local dTPBinder = vgui.Create("DBinder")
		dTPBinder:SetSize(170, 30)

		local curBindingT = bind.Find("placecrystal")
		dTPBinder:SetValue(curBindingT)

		function dTPBinder:OnChange(num)
			if num == 0 then
				bind.Remove(curBindingT, "placecrystal")
			else
				bind.Remove(curBindingT, "placecrystal")
				bind.Add(num, "placecrystal", true)

				LocalPlayer():ChatPrint("New bound key for placing a crystal: " .. input.GetKeyName(num))
			end

			curBindingT = num
		end

		dgui:AddItem(dTPlabel, dTPBinder)

		local dguiT = vgui.Create("DForm", parent)
		dguiT:SetName("Crystal")
		dguiT:CheckBox("Automatically try placing a Crystal", "ttt_crystal_auto")

		dguiT:Dock(TOP)

		-- hero
		GetLang = GetLang or LANG.GetRawTranslation

		-- hero ability
		local dHPlabel = vgui.Create("DLabel")
		dHPlabel:SetText("Hero ability:")
		dHPlabel:SetTextColor(COLOR_BLACK)

		local dHPBinder = vgui.Create("DBinder")
		dHPBinder:SetSize(170, 30)

		local curBindingH = bind.Find("togglehero")
		dHPBinder:SetValue(curBindingH)

		function dHPBinder:OnChange(num)
			if num == 0 then
				bind.Remove(curBindingH, "togglehero")
			else
				bind.Remove(curBindingH, "togglehero")
				bind.Add(num, "togglehero", true)

				LocalPlayer():ChatPrint("New bound key for activating your hero ability: " .. input.GetKeyName(num))
			end

			curBindingH = num
		end

		dgui:AddItem(dHPlabel, dHPBinder)

		-- abort preview ability
		local dAPPlabel = vgui.Create("DLabel")
		dAPPlabel:SetText("Abort ability preview:")
		dAPPlabel:SetTextColor(COLOR_BLACK)

		local dAPPBinder = vgui.Create("DBinder")
		dAPPBinder:SetSize(170, 30)

		local curBindingAP = bind.Find("aborthero")
		dAPPBinder:SetValue(curBindingAP)

		function dAPPBinder:OnChange(num)
			if num == 0 then
				bind.Remove(curBindingAP, "aborthero")
			else
				bind.Remove(curBindingAP, "aborthero")
				bind.Add(num, "aborthero", true)

				LocalPlayer():ChatPrint("New bound key for abort your ability preview: " .. input.GetKeyName(num))
			end

			curBindingAP = num
		end

		dgui:AddItem(dAPPlabel, dAPPBinder)

		dgui:Dock(TOP)
	end

	tbl[#tbl + 1] = heroesTbl
end)

bind.Register("placecrystal", function()
	LookUpCrystal()
end, nil, true)
