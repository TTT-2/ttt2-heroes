TTT2Crystal = TTT2Crystal or {}

local plymeta = FindMetaTable("Player")

function plymeta:GetCrystal()
	return self:GetNWEntity("Crystal", NULL)
end

function plymeta:HasCrystal()
	return IsValid(self:GetCrystal())
end