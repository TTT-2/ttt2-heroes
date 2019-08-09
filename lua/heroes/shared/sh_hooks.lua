if SERVER then        
        -- called on death / disconnect / distroy / ...
	hook.Add("TTTHRemoveCrystal", "TTTHDisableAbility", function(ply) -- TODO doublicated since the new UpdateRole handling?
		if ply:IsHero() then
			if ply:IsHeroActive() then
				ply:HeroDeactivate()

				net.Start("TTTHDeactivateHero")
				net.Send(ply)
			end

			ply:RemovePassiveHeroEquipment()
		end
	end)

	hook.Add("TTTHPlaceCrystal", "TTTHPlaceCrystal", function(ply)
		if ply:IsHero() then
			ply:GivePassiveHeroEquipment()
		end
        end)
        
        hook.Add("TTTHEquipmentOnlyWithCrystal", "TTTCPreventClassEquipment", function(ply)
                if not ply:HasCrystal() then
                        return true
                end
        end)
end