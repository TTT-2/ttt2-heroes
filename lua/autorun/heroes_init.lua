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

	hook.Add("Initialize", "TTT2HeroesLanguage", function()
		LANG.AddToLanguage("English", "ttt2_heroes_crystal_already_placed", "You have already placed a crystal!")
		LANG.AddToLanguage("English", "ttt2_heroes_not_on_ground", "You have to stand on solid ground to place your crystal!")
		LANG.AddToLanguage("English", "ttt2_heroes_crystal_placed", "Your crystal has been successfully placed!")
		LANG.AddToLanguage("English", "ttt2_heroes_crystal_picked_up", "You've successfully picked up your crystal!")
		LANG.AddToLanguage("English", "ttt2_heroes_crystal_destoyed", "Your crystal has been destroyed!")
		LANG.AddToLanguage("English", "ttt2_heroes_ability_disabled", "You can't use your ability since you haven't placed your crystal!")
		LANG.AddToLanguage("English", "ttt2_heroes_crystal_already_picked_up", "You can pickup your crystal only once!")
		LANG.AddToLanguage("English", "ttt2_heroes_all_crystals_destroyed", "All crystals have been destroyed!")
		LANG.AddToLanguage("English", "ttt2_heroes_crystal_ability_pickup_disabled", "You can't pickup your crystal since you have no ability!")
		LANG.AddToLanguage("English", "ttt2_heroes_crystal_auto_placed", "Attempting to auto place your crystal. You can disable this feature in the local heroes settings.")

		LANG.AddToLanguage("Deutsch", "ttt2_heroes_crystal_already_placed", "Du hast schon einen Kristall platziert!")
		LANG.AddToLanguage("Deutsch", "ttt2_heroes_not_on_ground", "Du musst beim Platzieren deines Kristalls auf dem Boden stehen!")
		LANG.AddToLanguage("Deutsch", "ttt2_heroes_crystal_placed", "Dein Kristall wurde erfolgreich platziert!")
		LANG.AddToLanguage("Deutsch", "ttt2_heroes_crystal_picked_up", "Du hast deinen Kristall erfolgreich aufgehoben!")
		LANG.AddToLanguage("Deutsch", "ttt2_heroes_crystal_destoyed", "Dein Kristall wurde zerstört!")
		LANG.AddToLanguage("Deutsch", "ttt2_heroes_ability_disabled", "Du kannst deine Fähigkeit nicht nutzen, weil du keinen Kristall platziert hast!")
		LANG.AddToLanguage("Deutsch", "ttt2_heroes_crystal_already_picked_up", "Du hast deinen Kristall schon einmal aufgehoben!")
		LANG.AddToLanguage("Deutsch", "ttt2_heroes_all_crystals_destroyed", "Alle Kristalle wurden zerstört!")
		LANG.AddToLanguage("Deutsch", "ttt2_heroes_crystal_ability_pickup_disabled", "Du kannst deinen Kristall nicht aufheben, da du keine Fähigkeit mehr hast!")
		LANG.AddToLanguage("Deutsch", "ttt2_heroes_crystal_auto_placed", "Versuche deinen Kristall automatisch zu platzieren. Du kannst dieses Feature in den lokalen Heroes Einstellung deaktivieren.")


		LANG.AddToLanguage("English", "ttt2_heroes_bind_place", "Place Crystal")
		LANG.AddToLanguage("Deutsch", "ttt2_heroes_bind_place", "Platziere Kristall")

		LANG.AddToLanguage("English", "ttt2_heroes_settings_crystal", "Crystal")
		LANG.AddToLanguage("Deutsch", "ttt2_heroes_settings_crystal", "Kristall")

		LANG.AddToLanguage("English", "ttt2_heroes_settings_autoplace", "Automatically try placing a Crystal.")
		LANG.AddToLanguage("Deutsch", "ttt2_heroes_settings_autoplace", "Versuche den Kristall automatisch zu platzieren.")
	end)
	
	hook.Add("Initialize", "TTT2HeroesKeyBinds", function()
		-- Register binding functions
		bind.Register("placecrystal", function()
			LookUpCrystal()
		end, nil, "TTT2 Heroes", "ttt2_heroes_bind_place", KEY_T)
	end)
end

