TTTH = true

if SERVER then
	local ttt2_heroes = CreateConVar("ttt2_heroes", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

	CreateConVar("ttt2_heroes_max_crystal_pickups", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

	-- ConVar syncing
	hook.Add("TTT2SyncGlobals", "AddHeroesGlobal", function()
		SetGlobalBool(ttt2_heroes:GetName(), ttt2_heroes:GetBool())
	end)

	cvars.AddChangeCallback(ttt2_heroes:GetName(), function(name, old, new)
		SetGlobalBool(name, tobool(new))
	end, "TTT2HeroesCVSyncingToggled")

	-- ConVar Replicating
	hook.Add("TTTUlxInitCustomCVar", "TTTHeroesInitRWCVar", function(name)
		ULib.replicatedWritableCvar("ttt2_heroes", "rep_ttt2_heroes", GetConVar("ttt2_heroes"):GetBool(), true, true, "xgui_gmsettings")
		ULib.replicatedWritableCvar("ttt2_heroes_max_crystal_pickups", "rep_ttt2_heroes_max_crystal_pickups", GetConVar("ttt2_heroes_max_crystal_pickups"):GetInt(), true, true, "xgui_gmsettings")
	end)
end

if CLIENT then
	hook.Add("TTTUlxModifyAddonSettings", "TTTHeroesModifySettings", function(name)
		local clspnl = xlib.makelistlayout{w = 415, h = 318, parent = xgui.null}

		local clsclp = vgui.Create("DCollapsibleCategory", clspnl)
		clsclp:SetSize(390, 110)
		clsclp:SetExpanded(1)
		clsclp:SetLabel("Basic Settings")

		local clslst = vgui.Create("DPanelList", clsclp)
		clslst:SetPos(5, 25)
		clslst:SetSize(390, 110)
		clslst:SetSpacing(5)

		clslst:AddItem(xlib.makelabel{
			x = 0,
			y = 0,
			w = 415,
			wordwrap = true,
			label = "Disabling Heroes only disables the hero functionality, not the classes itself. You have to disable TTT2 Classes to play without classes alltogether.",
			parent = clslst
		})

		clslst:AddItem(xlib.makecheckbox{
			label = "Enable Heroes? (ttt2_heroes) (Def. 1)",
			repconvar = "rep_ttt2_heroes",
			parent = clslst
		})

		clslst:AddItem(xlib.makelabel{ -- empty line
			x = 0,
			y = 0,
			w = 415,
			wordwrap = true,
			label = "",
			parent = clslst
		})

		clslst:AddItem(xlib.makelabel{
			x = 0,
			y = 0,
			w = 415,
			wordwrap = true,
			label = "Set to -1 to allow for infinite pickups:",
			parent = clslst
		})

		clslst:AddItem(xlib.makeslider{
			label = "ttt2_heroes_max_crystal_pickups (Def. 1)",
			repconvar = "rep_ttt2_heroes_max_crystal_pickups",
			min = -1,
			max = 25,
			decimal = 0,
			parent = clslst
		})

		xgui.hookEvent("onProcessModules", nil, clspnl.processModules)
		xgui.addSubModule("TTT2 Heroes", clspnl, nil, name)
	end)
end
