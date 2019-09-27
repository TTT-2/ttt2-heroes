if SERVER then
	AddCSLuaFile()
	AddCSLuaFile("heroes/shared/sh_defines.lua")
	AddCSLuaFile("heroes/shared/sh_hooks.lua")

	resource.AddFile("materials/vgui/ttt/score_logo_heroes.vmt")
end

include("heroes/shared/sh_defines.lua")
include("heroes/shared/sh_hooks.lua")

if CLIENT then
	hook.Add("InitPostEntity", "ModifyTTTScoreboardLogo", function()
		if TTTScoreboard and GetGlobalBool("ttt2_heroes") then
			TTTScoreboard.Logo = surface.GetTextureID("vgui/ttt/score_logo_heroes")
		end
	end)

	hook.Add("Initialize", "TTT2HeroesKeyBinds", function()
		-- Register binding functions
		bind.Register("placecrystal", function()
			LookUpCrystal()
		end, nil, "TTT2 Heroes", "Place Crystal: ", KEY_T)
	end)
end

