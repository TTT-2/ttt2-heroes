if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_svil.vmt")
end

ROLE.Base = "ttt_role_base"

function ROLE:PreInitialize()
	self.color = Color(222, 68, 0, 255)

	self.abbr = "svil"

	self.score.surviveBonusMultiplier = 0.5
	self.score.timelimitMultiplier = -0.5
	self.score.killsMultiplier = 2
	self.score.teamKillsMultiplier = -16
	self.score.bodyFoundMuliplier = 0

	self.defaultTeam = TEAM_TRAITOR
	self.defaultEquipment = SPECIAL_EQUIPMENT

	self.isOmniscientRole = true

	self.conVarData = {
		pct = 0.15,
		maximum = 1,
		minPlayers = 6,

		credits = 0,
		creditsAwardDeadEnable = 0,
		creditsAwardKillEnable = 0,

		random = 50,
		traitorButton = 1,

		togglable = true,
		shopFallback = SHOP_FALLBACK_TRAITOR
	}
end

function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_TRAITOR)
end

if SERVER then
	-- Give Loadout on respawn and rolechange	
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		ply:GiveEquipmentWeapon("weapon_ttt_crystalknife")
	end

	-- Remove Loadout on death and rolechange
	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		ply:StripWeapon("weapon_ttt_crystalknife")
	end

	-- disable this role if this mod is deactivated
	hook.Add("TTT2RoleNotSelectable", "TTT2CrystalDisableSupervillain", function(roleData)
		if roleData == SUPERVILLAIN and (not GetGlobalBool("ttt2_classes") or not GetGlobalBool("ttt2_heroes")) then
			return true
		end
	end)
end
