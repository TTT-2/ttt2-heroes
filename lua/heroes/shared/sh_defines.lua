TTTH = true

if SERVER then
	local ttt2_heroes = CreateConVar("ttt2_heroes", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	
	-- ConVar syncing
	hook.Add("TTT2SyncGlobals", "AddHeroesGlobal", function()
		SetGlobalBool(ttt2_heroes:GetName(), ttt2_heroes:GetBool())
	end)

	cvars.AddChangeCallback(ttt2_heroes:GetName(), function(name, old, new)
		SetGlobalBool(name, tobool(new))
	end, "TTT2HeroesCVSyncingToggled")

	-- ConVar Replicating
hook.Add('TTTUlxInitCustomCVar', 'TTTHeroesInitRWCVar', function(name)
	ULib.replicatedWritableCvar("ttt2_heroes", "rep_ttt2_heroes", GetConVar("ttt2_heroes"):GetBool(), true, true, "xgui_gmsettings")
end)
end

if CLIENT then
	hook.Add('TTTUlxModifyAddonSettings', 'TTTHeroesModifySettings', function(name)
		local clspnl = xlib.makelistlayout{w = 415, h = 318, parent = xgui.null}

		local clsclp = vgui.Create("DCollapsibleCategory", clspnl)
		clsclp:SetSize(390, 75)
		clsclp:SetExpanded(1)
		clsclp:SetLabel("Basic Settings")

		local clslst = vgui.Create("DPanelList", clsclp)
		clslst:SetPos(5, 25)
		clslst:SetSize(390, 75)
		clslst:SetSpacing(5)

		local clslim = xlib.makecheckbox{label = "Enable Heroes? (ttt2_heroes) (def. 1)", repconvar = "rep_ttt2_heroes", parent = clslst}
		clslst:AddItem(clslim)

		xgui.hookEvent('onProcessModules', nil, clspnl.processModules)
		xgui.addSubModule('TTT2 Heroes', clspnl, nil, name)
	end)
end