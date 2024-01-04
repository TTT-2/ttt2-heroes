TTT2Crystal.AnyCrystals = TTT2Crystal.AnyCrystals or true

util.AddNetworkString("TTT2CrystalPlaceCrystal")
util.AddNetworkString("TTT2ClientCVarChanged")

net.Receive("TTT2CrystalPlaceCrystal", function(_, ply)
	local isAutoplace = net.ReadBool()

	if not GetGlobalBool("ttt2_classes") or not GetGlobalBool("ttt2_heroes") then return end

	if not IsValid(ply) or not ply:IsTerror() or not ply:HasClass() then return end

	if not ply:GetNWBool("CanSpawnCrystal") or IsValid(ply:GetNWEntity("Crystal", nil)) then
		if not isAutoplace then
			LANG.Msg(ply, "ttt2_heroes_crystal_already_placed", nil, MSG_MSTACK_WARN)
		end

		return
	end

	if not ply:OnGround() then
		LANG.Msg(ply, "ttt2_heroes_not_on_ground", nil, MSG_MSTACK_WARN)

		return
	end

	if isAutoplace then
		LANG.Msg(ply, "ttt2_heroes_crystal_auto_placed", nil, MSG_MSTACK_PLAIN)
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

			LANG.Msg(ply, "ttt2_heroes_crystal_placed", nil, MSG_MSTACK_ROLE)

			hook.Run("TTTHPlaceCrystal", ply)

			CrystalUpdate()
		end
	end
end)

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
	if not TTT2Crystal.AnyCrystals or not GetGlobalBool("ttt2_classes") or not GetGlobalBool("ttt2_heroes") then return end

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
				LANG.MsgAll("ttt2_heroes_all_crystals_destroyed", nil, MSG_MSTACK_WARN)
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

		v.numCrystalPickups = 0
	end

	TTT2Crystal.AnyCrystals = true
end
hook.Add("TTTPrepareRound", "TTT2ResetCrystalValues", ResetCrystals)

local function CrystalInit(ply)
	ply:SetNWBool("CanSpawnCrystal", true)
	ply:SetNWEntity("Crystal", NULL)

	ply.numCrystalPickups = 0
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
