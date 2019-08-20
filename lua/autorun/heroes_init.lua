if SERVER then
	AddCSLuaFile()

	-- shared files
	AddCSLuaFile("heroes/shared/sh_tables.lua")
	AddCSLuaFile("heroes/shared/sh_defines.lua")
	AddCSLuaFile("heroes/shared/sh_functions.lua")
	AddCSLuaFile("heroes/shared/sh_player.lua")
	AddCSLuaFile("heroes/shared/sh_hooks.lua")

	-- client files
	AddCSLuaFile("heroes/client/cl_commands.lua")
	AddCSLuaFile("heroes/client/cl_hud.lua")

	resource.AddFile("materials/vgui/ttt/score_logo_heroes.vmt")
end

local heroPre = "heroes/heroes/"
local heroFiles = file.Find(heroPre .. "hero_*.lua", "LUA")

for _, fl in ipairs(heroFiles) do
	AddCSLuaFile(heroPre .. fl)
end

include("heroes/shared/sh_tables.lua")
include("heroes/shared/sh_defines.lua")
include("heroes/shared/sh_functions.lua")
include("heroes/shared/sh_player.lua")
include("heroes/shared/sh_hooks.lua")

if CLIENT then
	include("heroes/client/cl_commands.lua")
	include("heroes/client/cl_hud.lua")

	hook.Add("TTT2Initialize", "ModifyTTTScoreboardLogo", function()
		if TTTScoreboard then
			TTTScoreboard.Logo = surface.GetTextureID("vgui/ttt/score_logo_heroes")
		end

		if hudelements then
			local hudInfoElements = hudelements.GetAllTypeElements("tttinfopanel")
			for _, v in ipairs(hudInfoElements) do
				if v.SetSecondaryRoleInfoFunction then
					v:SetSecondaryRoleInfoFunction(function()
						local hd = LocalPlayer():GetHeroData()

						if not hd then return end

						return {
							color = hd.color or COLOR_HERO,
							text = HEROES.GetHeroTranslation(hd)
						}
					end)
				end
			end
		else
			Msg("Warning: New HUD module does not seem to be loaded in TTT2Initialize, so we cannot register to custom huds.\n")
		end
	end)
end

for _, fl in ipairs(heroFiles) do
	include(heroPre .. fl)
end
