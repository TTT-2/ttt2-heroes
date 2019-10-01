local GetTranslation

CreateConVar("ttt_crystal_auto", "1", {FCVAR_ARCHIVE}, "Should the crystal be autoplaced?")

net.Receive("TTT2ClientInitCrystal", function()
	include("crystal/client/cl_menu.lua")
end)

-- autoplace crystal on round begin
hook.Add("TTTBeginRound", "TTT2CrystalAutomaticPlacementRoundBegin", function()
	AutoPlaceCrystal()
end)

-- autoplace crystal on class select
hook.Add("TTTCUpdateClass", "TTT2CrystalAutomaticPlacementClassSelect", function()
	AutoPlaceCrystal()
end)

function AutoPlaceCrystal()
	if not GetGlobalBool("ttt2_classes") or not GetGlobalBool("ttt2_heroes") then return end
	if not GetConVar("ttt_crystal_auto"):GetBool() then return end

	local client = LocalPlayer()

	if not IsValid(client) then return end

	LookUpCrystal(true)
end

function LookUpCrystal(autoplace)
	if not GetGlobalBool("ttt2_classes") or not GetGlobalBool("ttt2_heroes") then return end

	if GetRoundState() ~= ROUND_WAIT and LocalPlayer():IsTerror() then
		net.Start("TTT2CrystalPlaceCrystal")
		net.WriteBool(autoplace or false)
		net.SendToServer()
	end
end
concommand.Add("placecrystal", LookUpCrystal, nil, "Places a Crystal", {FCVAR_DONTRECORD})

net.Receive("TTT2Crystal", function()
	local state = net.ReadInt(8)
	local text

	GetTranslation = GetTranslation or LANG.GetTranslation

	if state == 0 then
		text = GetTranslation("ttt2_heroes_crystal_auto_placed")
	elseif state == 1 then
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
	local heroesActivated = net.ReadBool()

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