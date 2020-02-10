if SERVER then
	AddCSLuaFile()

	resource.AddFile("models/props/w_crystal_green/w_crystal_green.mdl")
	resource.AddFile("materials/models/props/w_crystal_green/w_crystal_mat.vmt")
	resource.AddFile("materials/models/props/w_crystal_green/w_crystal_blue.vmt")
	resource.AddFile("materials/models/props/w_crystal_green/w_crystal_red.vmt")
	resource.AddFile("materials/models/props/w_crystal_green/w_crystal_white.vmt")
	resource.AddFile("materials/models/props/w_crystal_green/w_ground_blue.vmt")
	resource.AddFile("materials/models/props/w_crystal_green/w_Ground_mat.vmt")
	resource.AddFile("materials/models/props/w_crystal_green/w_ground_red.vmt")
	resource.AddFile("materials/sprites/crystal_sparkle.vmt")

	resource.AddSingleFile("materials/models/props/w_crystal_green/w_crystal_normal.vtf")
	resource.AddSingleFile("materials/models/props/w_crystal_green/w_Ground_normal.vtf")
end

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = Model("models/props/w_crystal_green/w_crystal_green.mdl")
ENT.CanUseKey = true
ENT.CanPickup = true

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetSkin(3)

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
	end

	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

	if SERVER then
		self:SetMaxHealth(100)
		self:SetHealth(100)
		self:SetUseType(SIMPLE_USE)
	end

	self:SetModelScale(0.75)
	self:PhysWake()
end

function ENT:UseOverride(activator)
	local owner = self:GetOwner()

	local max_pickups = GetConVar("ttt2_heroes_max_crystal_pickups"):GetInt()

	if IsValid(activator) and activator:IsTerror() and owner == activator and activator:HasClass()
		and (activator.numCrystalPickups < max_pickups or max_pickups == -1)
	then
		activator:SetNWBool("CanSpawnCrystal", true)
		activator:SetNWEntity("Crystal", NULL)

		if not activator.numCrystalPickups then
			activator.numCrystalPickups = 0
		end

		activator.numCrystalPickups = activator.numCrystalPickups + 1

		LANG.Msg(activator, "ttt2_heroes_crystal_picked_up", nil, MSG_MSTACK_PLAIN)

		activator:SetNWEntity("Crystal", NULL)

		self:Remove()

		if SERVER then
			timer.Simple(0.01, function()
				CrystalUpdate()
			end)
		end
	elseif IsValid(activator) and activator:IsTerror() and owner == activator then
		if max_pickups == 0 then
			LANG.Msg(activator, "ttt2_heroes_crystal_already_no_pickup", nil, MSG_MSTACK_WARN)
		elseif activator.numCrystalPickups >= max_pickups then
			LANG.Msg(activator, "ttt2_heroes_crystal_already_picked_up", {num = max_pickups}, MSG_MSTACK_WARN)
		elseif not activator:HasClass() then
			LANG.Msg(activator, "ttt2_heroes_crystal_ability_pickup_disabled", nil, MSG_MSTACK_WARN)
		end
	end
end

local zapsound = Sound("npc/assassin/ball_zap1.wav")

function ENT:OnTakeDamage(dmginfo)
	if GetRoundState() ~= ROUND_ACTIVE then return end

	local owner, att, infl = self:GetOwner(), dmginfo:GetAttacker(), dmginfo:GetInflictor()

	if not IsValid(owner) or infl == owner or att == owner or (IsValid(att) and att:IsPlayer() and att:IsInTeam(owner) and not att:GetSubRoleData().unknownTeam) or not infl.GetSubRole and (not att or not att.GetSubRole) then return end

	if infl:GetClass() == "weapon_ttt_crystalknife" then
		if SERVER and IsValid(att) and att:IsPlayer() then
			LANG.Msg(owner, ttt2_heroes_crystal_destoyed, nil, MSG_MSTACK_WARN)
		end

		GiveCrystalCredits(att, self)

		if IsValid(att) and att:GetSubRole() == ROLE_SIDEKICK and owner:HasTeam(TEAM_INNOCENT) then
			local text = att:Nick() .. " ist ein SIDEKICK!"

			for _, v in ipairs(player.GetAll()) do
				v:ChatPrint(text)
			end

			att:StripWeapon("weapon_ttt_crystalknife")
		end

		local effect = EffectData()
		effect:SetOrigin(self:GetPos())

		util.Effect("cball_explode", effect)

		sound.Play(zapsound, self:GetPos())

		owner:SetNWEntity("Crystal", NULL)

		self:Remove()

		owner.oldClass = owner:GetCustomClass()

		if SERVER then
			owner:UpdateClass(nil)

			timer.Simple(0.01, function()
				CrystalUpdate()
			end)
		end
	end
end

function ENT:FakeDestroy()
	local effect = EffectData()
	effect:SetOrigin(self:GetPos())

	util.Effect("cball_explode", effect)

	sound.Play(zapsound, self:GetPos())

	local owner = self:GetOwner()

	if IsValid(owner) then
		owner:SetNWEntity("Crystal", NULL)

		hook.Run("TTTHFakeDestroy", owner)
	end

	self:Remove()

	if IsValid(owner) then
		owner.oldClass = owner:GetCustomClass()

		if SERVER then
			owner:UpdateClass(nil)
		end
	end

	if SERVER then
		timer.Simple(0.01, function()
			CrystalUpdate()
		end)
	end
end

function ENT:Draw()
	local owner = self:GetOwner()

	if IsValid(owner) then
		self:SetColor(owner:GetRoleColor())
		self:DrawModel()
	end
end

function ENT:OnRemove()
	local owner = self:GetOwner() or self.Owner

	if IsValid(owner) then
		hook.Run("TTTHRemoveCrystal", owner)
	end
end

hook.Add("PlayerDisconnected", "TTT2CrystalDestroy", function(ply)
	if ply:HasCrystal() then
		ply:GetCrystal():FakeDestroy()
	end
end)

if CLIENT then
	local TryT, ParT
	local crystalMaterial = Material("vgui/ttt/icon_diamond")

	-- target ID
	hook.Add("TTTRenderEntityInfo", "DrawCrystalTargetID", function(tData)
		local client = LocalPlayer()
		local ent = tData:GetEntity()

		-- has to be a valid crystal
		if not IsValid(ent) or not ent:GetOwner() or ent:GetClass() ~= "ttt_crystal" then return end
		if tData:GetEntityDistance() > 100 then return end

		local owner = ent:GetOwner()

		TryT = TryT or LANG.TryTranslation
		ParT = ParT or LANG.GetParamTranslation

		-- enable targetID rendering
		tData:EnableText()
		tData:EnableOutline()
		tData:SetOutlineColor(client:GetRoleColor())

		tData:SetTitle(TryT("ttt2_heroes_entity_crystal"))

		if owner == client then
			tData:SetKeyBinding("+use")
			tData:SetSubtitle(ParT("target_pickup", {usekey = Key("+use", "USE")}))
			tData:AddDescriptionLine(TryT("ttt2_heroes_entity_crystal_owner_self"))
		elseif client:GetSubRole() == ROLE_SUPERVILLAIN or client:GetSubRole() == ROLE_SIDEKICK then
			tData:SetIcon(crystalMaterial)
			tData:SetSubtitle(TryT("ttt2_heroes_entity_crystal_knife"))
			tData:AddDescriptionLine(TryT("ttt2_heroes_entity_crystal_owner") .. owner:Nick())
		else
			tData:SetIcon(crystalMaterial)
			tData:SetSubtitle(TryT("ttt2_heroes_entity_crystal_cant_interact"))
			tData:AddDescriptionLine(TryT("ttt2_heroes_entity_crystal_owner_unknown"))
		end

		if owner:GetTeam() ~= client:GetTeam() and IsValid(client:GetActiveWeapon()) and client:GetActiveWeapon():GetClass() == "weapon_ttt_crystalknife" then
			tData:AddDescriptionLine(
				TryT("ttt2_heroes_entity_crystal_destroy"),
				SUPERVILLAIN.color
			)
		end
	end)
end
