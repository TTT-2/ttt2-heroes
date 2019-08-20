HERO_BITS = 10

COLOR_HERO = Color(255, 155, 0, 255)
HERO_TIME = 60
HERO_COOLDOWN = 60

if SERVER then
	util.AddNetworkString("TTTHSendHero")
	util.AddNetworkString("TTTHSendHeroOptions")
	util.AddNetworkString("TTTHChooseHeroOption")
	util.AddNetworkString("TTTHClientSendHeroes")
	util.AddNetworkString("TTTHSyncHeroes")
	util.AddNetworkString("TTTHSyncHero")
	util.AddNetworkString("TTTHHeroesSynced")
	util.AddNetworkString("TTTHSyncHeroWeapon")
	util.AddNetworkString("TTTHSyncHeroItem")
	util.AddNetworkString("TTTHActivateHero")
	util.AddNetworkString("TTTHDeactivateHero")
	util.AddNetworkString("TTTHAbortHero")
	util.AddNetworkString("TTTHChangeCharge")
	util.AddNetworkString("TTTHResetChargingWaiting")

	local ttt2_heroes = CreateConVar("ttt2_heroes", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	local ttt_heroes_limited = CreateConVar("ttt_heroes_limited", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})
	local ttt_heroes_option = CreateConVar("ttt_heroes_option", "1", {FCVAR_NOTIFY, FCVAR_ARCHIVE})

	-- ConVar syncing
	hook.Add("TTT2SyncGlobals", "AddHeroesGlobals", function()
		SetGlobalBool(ttt2_heroes:GetName(), ttt2_heroes:GetBool())
		SetGlobalBool(ttt_heroes_limited:GetName(), ttt_heroes_limited:GetBool())
		SetGlobalBool(ttt_heroes_option:GetName(), ttt_heroes_option:GetBool())
	end)

	cvars.AddChangeCallback(ttt2_heroes:GetName(), function(name, old, new)
		SetGlobalBool(name, tobool(new))
	end, "TTT2HeroesCVSyncingToggled")

	cvars.AddChangeCallback(ttt_heroes_limited:GetName(), function(name, old, new)
		SetGlobalBool(name, tobool(new))
	end, "TTT2HeroesCVSyncingLimited")

	cvars.AddChangeCallback(ttt_heroes_option:GetName(), function(name, old, new)
		SetGlobalBool(name, tobool(new))
	end, "TTT2HeroesCVSyncingOptions")
end
