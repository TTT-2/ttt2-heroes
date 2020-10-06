local con_crystal_auto = CreateConVar("ttt_crystal_auto", "1", {FCVAR_ARCHIVE}, "Should the crystal be autoplaced?")

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
	if not GetGlobalBool("ttt2_classes") or not GetGlobalBool("ttt2_heroes") or not con_crystal_auto:GetBool() then return end

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

bind.Register("placecrystal", function()
	LookUpCrystal()
end, nil, "header_bindings_heroes", "ttt2_heroes_bind_place", KEY_T)
