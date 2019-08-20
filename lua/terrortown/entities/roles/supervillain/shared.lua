if SERVER then
	AddCSLuaFile()
end

ROLE.Base = "ttt_role_base"

ROLE.color = Color(222, 68, 0, 255) -- ...
ROLE.dkcolor = Color(138, 43, 0, 255) -- ...
ROLE.bgcolor = Color(0, 150, 93, 255) -- ...
ROLE.abbr = "svil" -- abbreviation
ROLE.defaultTeam = TEAM_TRAITOR -- the team name: roles with same team name are working together
ROLE.defaultEquipment = SPECIAL_EQUIPMENT -- here you can set up your own default equipment
ROLE.surviveBonus = 0.5 -- bonus multiplier for every survive while another player was killed
ROLE.scoreKillsMultiplier = 5 -- multiplier for kill of player of another team
ROLE.scoreTeamKillsMultiplier = -16 -- multiplier for teamkill

if SERVER then
	ROLE.CustomRadar = function(ply) -- Hero Radar function
		if TTT2Crystal.AnyCrystals then
			local targets = {}
			local scan_ents = ents.FindByClass("ttt_crystal")

			for _, t in ipairs(scan_ents) do
				local pos = t:LocalToWorld(t:OBBCenter())

				pos.x = math.Round(pos.x)
				pos.y = math.Round(pos.y)
				pos.z = math.Round(pos.z)

				local owner = t:GetOwner() or t.Owner
				if owner ~= ply and not owner:HasTeam(TEAM_TRAITOR) then
					table.insert(targets, {subrole = -1, pos = pos})
				end
			end

			return targets
		else
			return false
		end
	end
end

-- important to add roles with this function,
-- because it does more than just access the array ! e.g. updating other arrays
ROLE.conVarData = {
	pct = 0.15, -- necessary: percentage of getting this role selected (per player)
	maximum = 1, -- maximum amount of roles in a round
	minPlayers = 6, -- minimum amount of players until this role is able to get selected
	credits = 0, -- the starting credits of a specific role
	togglable = true, -- option to toggle a role for a client if possible (F1 menu)
	random = 50,
	shopFallback = SHOP_FALLBACK_TRAITOR
}

-- now link this subrole with its baserole
hook.Add("TTT2BaseRoleInit", "TTT2ConBRTWithHrole", function()
	SUPERVILLAIN:SetBaseRole(ROLE_TRAITOR)
end)

hook.Add("TTT2RolesLoaded", "AddSupervillainTeam", function()
	SUPERVILLAIN.defaultTeam = TEAM_TRAITOR
end)

-- if sync of roles has finished
hook.Add("TTT2FinishedLoading", "SupervillainInitT", function()
	if CLIENT then
		-- setup here is not necessary but if you want to access the role data, you need to start here
		-- setup basic translation !
		LANG.AddToLanguage("English", SUPERVILLAIN.name, "Supervillain")
		LANG.AddToLanguage("English", "info_popup_" .. SUPERVILLAIN.name, [[You are a Supervillain! Try to destroy some Crystals!]])
		LANG.AddToLanguage("English", "body_found_" .. SUPERVILLAIN.abbr, "They were a Supervillain!")
		LANG.AddToLanguage("English", "search_role_" .. SUPERVILLAIN.abbr, "This person was a Supervillain!")
		LANG.AddToLanguage("English", "target_" .. SUPERVILLAIN.name, "Supervillain")
		LANG.AddToLanguage("English", "ttt2_desc_" .. SUPERVILLAIN.name, [[The Supervillain is a Traitor (who works together with the other traitors) and the goal is to kill all other roles except the other traitor roles ^^ The Supervillain is able to destroy the crystals of his enemies.]])

		---------------------------------

		-- maybe this language as well...
		LANG.AddToLanguage("Deutsch", SUPERVILLAIN.name, "Supervillain")
		LANG.AddToLanguage("Deutsch", "info_popup_" .. SUPERVILLAIN.name, [[Du bist ein Supervillain! Versuche ein paar Crystals zu zerstören!]])
		LANG.AddToLanguage("Deutsch", "body_found_" .. SUPERVILLAIN.abbr, "Er war ein Supervillain...")
		LANG.AddToLanguage("Deutsch", "search_role_" .. SUPERVILLAIN.abbr, "Diese Person war ein Supervillain!")
		LANG.AddToLanguage("Deutsch", "target_" .. SUPERVILLAIN.name, "Supervillain")
		LANG.AddToLanguage("Deutsch", "ttt2_desc_" .. SUPERVILLAIN.name, [[Der Supervillain ist ein Verräter (der mit den anderen Verräter-Rollen zusammenarbeitet) und dessen Ziel es ist, alle anderen Rollen (außer Verräter-Rollen) zu töten ^^ Er kann die Crystals seiner Feinde zerstören.]])
	end
end)

if SERVER then
	-- is called if the role has been selected in the normal way of team setup
	hook.Add("TTT2UpdateSubrole", "UpdateToSupervillainRole", function(ply, old, new)
		if new == ROLE_SUPERVILLAIN then
			ply:GiveItem("item_ttt_radar")
		end
	end)

	hook.Add("TTT2RolesLoaded", "AddCrystalKnifeToDefaultLoadout", function()
		local wep = weapons.GetStored("weapon_ttt_crystalknife")
		if wep then
			wep.InLoadoutFor = wep.InLoadoutFor or {}

			if not table.HasValue(wep.InLoadoutFor, ROLE_SUPERVILLAIN) then
				table.insert(wep.InLoadoutFor, ROLE_SUPERVILLAIN)
			end
		end
	end)

	-- disable this role if this mod is deactivated
	hook.Add("TTT2RoleNotSelectable", "TTT2CrystalDisableSupervillain", function(roleData)
		if roleData == SUPERVILLAIN and not GetGlobalBool("ttt2_heroes") then
			return true
		end
	end)

	local oldValue

	-- role vote support
	hook.Add("TTT2RoleVoteWinner", "TTT2HroleEnableCrystal", function(role)
		if role == ROLE_SUPERVILLAIN and not GetGlobalBool("ttt2_heroes") then
			oldValue = "0"

			RunConsoleCommand("ttt2_heroes", "1")
		else
			RunConsoleCommand("ttt2_heroes", oldValue)
		end
	end)
end
