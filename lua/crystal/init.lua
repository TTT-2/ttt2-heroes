TTT2Crystal.AnyCrystals = TTT2Crystal.AnyCrystals or true

util.AddNetworkString("TTT2Crystal")
util.AddNetworkString("TTT2CrystalPlaceCrystal")
util.AddNetworkString("TTT2ClientInitCrystal")
util.AddNetworkString("TTT2ClientCVarChanged")

local cvnm = "ttt2_classes"
local cvnmh = "ttt2_heroes"

function PlaceCrystal(len, sender)
	local isAutoplace = net.ReadBool()

	if not GetConVar(cvnm):GetBool() or not GetConVar(cvnmh):GetBool() then return end

	local ply = sender

	if not IsValid(ply) or not ply:IsTerror() or not ply:HasClass() then return end

	if isAutoplace then
		net.Start("TTT2Crystal")
		net.WriteInt(0, 8)
		net.Send(ply)
	end

	if not ply:GetNWBool("CanSpawnCrystal") or IsValid(ply:GetNWEntity("Crystal", NULL)) or ply.PlaceCrystal then
		net.Start("TTT2Crystal")
		net.WriteInt(1, 8)
		net.Send(ply)

		return
	end

	if not ply:OnGround() then
		net.Start("TTT2Crystal")
		net.WriteInt(2, 8)
		net.Send(ply)

		return
	end

	if ply:IsInWorld() then
		local crystal = ents.Create("ttt_crystal")

		if IsValid(crystal) then
			crystal:SetAngles(ply:GetAngles())
			crystal:SetPos(ply:GetPos())
			crystal:SetOwner(ply)
			crystal:Spawn()

			ply:SetNWBool("CanSpawnCrystal", false)
			ply:SetNWEntity("Crystal", crystal)

			net.Start("TTT2Crystal")
			net.WriteInt(3, 8)
			net.Send(ply)

			hook.Run("TTTHPlaceCrystal", ply)

			CrystalUpdate()
		end
	end
end
net.Receive("TTT2CrystalPlaceCrystal", PlaceCrystal)

local function DestroyAllCrystals()
	for _, v in ipairs(ents.FindByClass("ttt_crystal")) do
		v:FakeDestroy()
	end

	for _, v in ipairs(player.GetAll()) do
		v:SetNWBool("CanSpawnCrystal", false)
	end

	TTT2Crystal.AnyCrystals = false

	CrystalUpdate()
end

function CrystalUpdate()
	if not TTT2Crystal.AnyCrystals or not GetConVar(cvnm):GetBool() or not GetConVar(cvnmh):GetBool() then return end

	local rs = GetRoundState()

	if rs == ROUND_ACTIVE or rs == ROUND_POST then
		local crystals = {}

		for _, v in ipairs(player.GetAll()) do
			if (v:IsTerror() or not v:Alive()) and (v:HasCrystal() or v:GetNWBool("CanSpawnCrystal")) then
				table.insert(crystals, v)
			end
		end

		if #crystals > 0 then
			TTT2Crystal.AnyCrystals = true
		else
			TTT2Crystal.AnyCrystals = false

			if rs == ROUND_ACTIVE then
				net.Start("TTT2Crystal")
				net.WriteInt(8, 8)
				net.Broadcast()
			end

			return
		end
	end
end
hook.Add("TTTBeginRound", "TTT2CrystalSync", CrystalUpdate)
hook.Add("PlayerDisconnected", "TTT2CrystalSync", CrystalUpdate)

function GiveCrystalCredits(ply, crystal)
	LANG.Msg(ply, "credit_h_all", {num = 1})

	ply:AddCredits(1)
end

local function ResetCrystals()
	for _, v in ipairs(player.GetAll()) do
		v:SetNWBool("CanSpawnCrystal", true)
		v:SetNWEntity("Crystal", NULL)

		v.crystaluses = 0
	end

	TTT2Crystal.AnyCrystals = true
end
hook.Add("TTTPrepareRound", "TTT2ResetCrystalValues", ResetCrystals)

local function CrystalInit(ply)
	net.Start("TTT2ClientInitCrystal")
	net.Send(ply)

	ply:SetNWBool("CanSpawnCrystal", true)
	ply:SetNWEntity("Crystal", NULL)

	ply.crystaluses = 0
end
hook.Add("PlayerInitialSpawn", "TTT2CrystalInit", CrystalInit)

cvars.AddChangeCallback("ttt2_heroes", function(cvar, old, new)
	if old ~= new then
		if new == "0" then
			DestroyAllCrystals()
			ResetCrystals()
		end

		net.Start("TTT2ClientCVarChanged")
		net.WriteBool(new == "1" and GetGlobalBool("ttt2_classes"))
		net.Broadcast()
	end
end)

cvars.AddChangeCallback("ttt2_classes", function(cvar, old, new)
	if old ~= new then
		if new == "0" then
			DestroyAllCrystals()
			ResetCrystals()
		end

		net.Start("TTT2ClientCVarChanged")
		net.WriteBool(GetGlobalBool("ttt2_heroes") and new == "1")
		net.Broadcast()
	end
end)
