CreateConVar("ttt_crystal_auto", "1", {FCVAR_ARCHIVE}, "Soll das Crystal automatisch plaziert werden?")

net.Receive("TTT2ClientInitCrystal", function()
	include("crystal/client/cl_menu.lua")
end)

hook.Add("TTTBeginRound", "TTT2CrystalAutomaticPlacement", function()
	if not GetGlobalBool("ttt2_classes") or not GetGlobalBool("ttt2_heroes") or not GetConVar("ttt_crystal_auto"):GetBool() then return end

	if not IsValid(LocalPlayer()) then return end

	LocalPlayer():ConCommand("placecrystal")
end)

function LookUpCrystal()
	if not GetGlobalBool("ttt2_classes") or not GetGlobalBool("ttt2_heroes") then return end

	if GetRoundState() ~= ROUND_WAIT and LocalPlayer():IsTerror() then
		net.Start("TTT2CrystalPlaceCrystal")
		net.SendToServer()
	end
end
concommand.Add("placecrystal", LookUpCrystal, nil, "Places a Crystal", {FCVAR_DONTRECORD})

net.Receive("TTT2Crystal", function()
	local state = net.ReadInt(8)
	local text

	local GetTranslation = LANG.GetTranslation

	if state == 1 then
		text = GetTranslation("ttt2_heroes_crystal_already_placed")
	elseif state == 2 then
		text = GetTranslation("ttt2_heroes_not_on_ground")
	elseif state == 3 then
		text = GetTranslation("ttt2_heroes_crystal_placed")
	elseif state == 4 then
		text = GetTranslation("ttt2_heroes_crystal_picked_up")
	elseif state == 5 then
		text = GetTranslation("ttt2_heroes_crystal_destoyed")
	elseif state == 6 then
		text = GetTranslation("ttt2_heroes_ability_disabled")
	elseif state == 7 then
		text = GetTranslation("ttt2_heroes_crystal_already_picked_up")
	elseif state == 8 then
		text = GetTranslation("ttt2_heroes_all_crystals_destroyed")
	elseif state == 9 then
		text = GetTranslation("ttt2_heroes_crystal_ability_pickup_disabled")
	end

	if text then
		chat.AddText("[TTT2] Heroes: ", COLOR_WHITE, text)
	end

	chat.PlaySound()
end)

net.Receive("TTT2ClientCVarChanged", function()
	local heroesActivated = not net.ReadBool()

	if CLIENT then
		GAMEMODE:ScoreboardCreate()
		GAMEMODE:ScoreboardHide()
	end

	if heroesActivated then
		if TTTScoreboard then
			TTTScoreboard.Logo = surface.GetTextureID("vgui/ttt/score_logo_heroes")
		end
	else
		if TTTScoreboard then
			TTTScoreboard.Logo = surface.GetTextureID("vgui/ttt/score_logo_2")
		end
	end
end)