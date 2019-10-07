if SERVER then
	AddCSLuaFile()
end

ROLE.Base = "ttt_role_base"

ROLE.color = Color(222, 68, 0, 255) -- ...
ROLE.dkcolor = Color(138, 43, 0, 255) -- ...
ROLE.bgcolor = Color(0, 150, 93, 255) -- ...
ROLE.abbr = "svil" -- abbreviation
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

function ROLE:PreInitialize()
	self.defaultTeam = TEAM_TRAITOR
	self.defaultEquipment = SPECIAL_EQUIPMENT

	self.conVarData = {
		pct = 0.15, -- necessary: percentage of getting this role selected (per player)
		maximum = 1, -- maximum amount of roles in a round
		minPlayers = 6, -- minimum amount of players until this role is able to get selected
		credits = 0, -- the starting credits of a specific role
		togglable = true, -- option to toggle a role for a client if possible (F1 menu)
		random = 50,
		shopFallback = SHOP_FALLBACK_TRAITOR
	}
end

function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_TRAITOR)

	if CLIENT then
		-- Role specific language elements
		LANG.AddToLanguage("English", SUPERVILLAIN.name, "Supervillain")
		LANG.AddToLanguage("English", "info_popup_" .. SUPERVILLAIN.name, [[You are a Supervillain! Try to destroy some Crystals with your knife to earn yourself some credits! Removing Crystals also removes the hero ability of the owner.]])
		LANG.AddToLanguage("English", "body_found_" .. SUPERVILLAIN.abbr, "They were a Supervillain!")
		LANG.AddToLanguage("English", "search_role_" .. SUPERVILLAIN.abbr, "This person was a Supervillain!")
		LANG.AddToLanguage("English", "target_" .. SUPERVILLAIN.name, "Supervillain")
		LANG.AddToLanguage("English", "ttt2_desc_" .. SUPERVILLAIN.name, [[The Supervillain is a Traitor (who works together with the other traitors)! The goal is to kill all other roles except the other traitor roles. The Supervillain is able to destroy the crystals of his enemies to get credits and remove their hero abilities.]])

		LANG.AddToLanguage("Deutsch", SUPERVILLAIN.name, "Superschurke")
		LANG.AddToLanguage("Deutsch", "info_popup_" .. SUPERVILLAIN.name, [[Du bist ein Superschurke! Versuche ein paar Kristalle mit deinem Messter zu zerstören, um Credits zu verdienen! Das Entfernen der Kristalle entfernt auch die Heldenfähigkeit des Besitzers.]])
		LANG.AddToLanguage("Deutsch", "body_found_" .. SUPERVILLAIN.abbr, "Er war ein Superschurke.")
		LANG.AddToLanguage("Deutsch", "search_role_" .. SUPERVILLAIN.abbr, "Diese Person war ein Superschurke!")
		LANG.AddToLanguage("Deutsch", "target_" .. SUPERVILLAIN.name, "Superschurke")
		LANG.AddToLanguage("Deutsch", "ttt2_desc_" .. SUPERVILLAIN.name, [[Der Superschurke ist ein Verräter (der mit den anderen Verräter-Rollen zusammenarbeitet). Es ist sein Ziel alle anderen Rollen (außer Verräter-Rollen) zu töten. Er kann die Crystals seiner Feinde zerstören um Credits zu verdienen und ihnen die Heldenfähigkeiten zu nehmen.]])
	
		-- other role language elements
		LANG.AddToLanguage("English", "credit_h_all", "You have been awarded {num} equipment credit(s) by destroying a crystal.")
		LANG.AddToLanguage("Deutsch", "credit_h_all", "Dir wurde(n) {num} Ausrüstungs-Credit(s) für die Zerstörung eines Kristalles gegeben.")
	end
end

if SERVER then
	-- Give Loadout on respawn and rolechange	
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		ply:GiveEquipmentWeapon("weapon_ttt_crystalknife")
		ply:GiveEquipmentItem("item_ttt_radar")
	end

	-- Remove Loadout on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		ply:StripWeapon("weapon_ttt_crystalknife")
		ply:RemoveEquipmentItem("item_ttt_radar")
	end

	-- disable this role if this mod is deactivated
	hook.Add("TTT2RoleNotSelectable", "TTT2CrystalDisableSupervillain", function(roleData)
		if roleData == SUPERVILLAIN and (not GetGlobalBool("ttt2_classes") or not GetGlobalBool("ttt2_heroes")) then
			return true
		end
	end)

	local oldValue

	-- role vote support
	hook.Add("TTT2RoleVoteWinner", "TTT2HroleEnableCrystal", function(role)
		if role == ROLE_SUPERVILLAIN and not GetGlobalBool("ttt2_classes") and not GetGlobalBool("ttt2_heroes") then
			oldValue = "0"

			RunConsoleCommand("ttt2_classes", "1")
			RunConsoleCommand("ttt2_heroes", "1")
		else
			RunConsoleCommand("ttt2_classes", oldValue)
			RunConsoleCommand("ttt2_heroes", oldValue)
		end
	end)
end
