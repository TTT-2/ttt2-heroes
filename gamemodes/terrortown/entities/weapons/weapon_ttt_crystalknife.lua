AddCSLuaFile()

SWEP.HoldType = "knife"

if CLIENT then
	SWEP.PrintName = "Crystal Knife"
	SWEP.Slot = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 54
	SWEP.DrawCrosshair = false
end

SWEP.Base = "weapon_tttbase"

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

SWEP.Primary.Damage = 100
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 0.7
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 1.4

SWEP.Kind = WEAPON_ROLE
SWEP.InLoadoutFor = {ROLE_SUPERVILLAIN}
SWEP.IsSilent = true
SWEP.AllowDrop = false
SWEP.NoSights = true

-- Pull out faster than standard guns
SWEP.DeploySpeed = 2

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

	local owner = self:GetOwner()

	if not IsValid(owner) then return end

	owner:LagCompensation(true)

	local shootPos = owner:GetShootPos()

	local tr = util.TraceLine({
		start = shootPos,
		endpos = shootPos + owner:GetAimVector() * 100,
		mask = MASK_SOLID,
		filter = {self, owner}
	})

	local hitEnt = tr.Entity

	if not IsValid(hitEnt) or hitEnt:GetClass() ~= "ttt_crystal" then return end

	self:SendWeaponAnim(ACT_VM_MISSCENTER)

	if SERVER then
		local dmg = DamageInfo()
		dmg:SetDamage(self.Primary.Damage)
		dmg:SetAttacker(owner)
		dmg:SetInflictor(self or self)
		dmg:SetDamageForce(owner:GetAimVector() * 5)
		dmg:SetDamagePosition(owner:GetPos())
		dmg:SetDamageType(DMG_SLASH)

		hitEnt:DispatchTraceAttack(dmg, tr)
	end

	owner:LagCompensation(false)
end

function SWEP:OnDrop()
	self:Remove()
end

function SWEP:Equip()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
end

function SWEP:OnRemove()
	local owner = self:GetOwner()

	if CLIENT and IsValid(owner) and owner == LocalPlayer() and owner:Alive() then
		RunConsoleCommand("lastinv")
	end
end