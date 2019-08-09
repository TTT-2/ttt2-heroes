
if SERVER then

	local ttt2_heroes = CreateConVar("ttt2_heroes", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

	-- ConVar syncing
	hook.Add("TTT2SyncGlobals", "AddHeroesGlobal", function()
		SetGlobalBool(ttt2_heroes:GetName(), ttt2_heroes:GetBool())
	end)

	cvars.AddChangeCallback(ttt2_heroes:GetName(), function(name, old, new)
		SetGlobalBool(name, tobool(new))
	end, "TTT2HeroesCVSyncingToggled")
end
