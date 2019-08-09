CreateConVar("ttt_crystal_auto", "1", {FCVAR_ARCHIVE}, "Soll das Crystal automatisch plaziert werden?")

net.Receive("TTT2ClientInitCrystal", function()
	include("crystal/client/cl_menu.lua")
end)

hook.Add("TTTBeginRound", "TTT2CrystalAutomaticPlacement", function()
	if not GetGlobalBool("ttt2_classes") or not GetGlobalBool("ttt2_heroes") or not GetConVar("ttt_crystal_auto"):GetBool() then return end

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

	if state == 1 then
		text = "Du hast schon einen Kristall platziert!"
	elseif state == 2 then
		text = "Du musst beim Platzieren deines Kristalls auf dem Boden stehen!"
	elseif state == 3 then
		text = "Dein Kristall wurde erfolgreich platziert!"
	elseif state == 4 then
		text = "Du hast deinen Kristall erfolgreich aufgehoben!"
	elseif state == 5 then
		text = "Dein Kristall wurde zerstört!"
	elseif state == 6 then
		text = "Du kannst deine Fähigkeit nicht nutzen, weil du keinen Kristall platziert hast!"
	elseif state == 7 then
		text = "Du hast deinen Kristall schon einmal aufgehoben!"
	elseif state == 8 then
		text = "Alle Kristalle wurden zerstört!"
	elseif state == 9 then
		text = "Du kannst deinen Kristall nicht aufheben, da du keine Fähigkeit mehr hast!"
	end

	if text then
		chat.AddText("[TTT2] Heroes: ", COLOR_WHITE, text)
	end

	chat.PlaySound()
end)
