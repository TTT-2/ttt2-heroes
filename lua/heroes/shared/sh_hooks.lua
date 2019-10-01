local function PreventWhenExecutedWithoutCrystal(ply)
	if GetGlobalBool("ttt2_heroes") and not ply:HasCrystal() then
		return true
	end

	return false
end


hook.Add("TTTCPreventClassActivation", "TTTHActivationOnlyWithCrystal", function(ply)
	return PreventWhenExecutedWithoutCrystal(ply)
end)

if SERVER then        
	-- called on death / disconnect / destroy / ...
	hook.Add("TTTHRemoveCrystal", "TTTHDisableAbility", function(ply) -- TODO doublicated since the new UpdateRole handling?
		if ply:HasClass() then
			if ply:HasClassActive() then
				ply:ClassDeactivate()

				net.Start("TTTCDeactivateClass")
				net.Send(ply)
			end

			ply:RemovePassiveClassEquipment()
		end
	end)

	hook.Add("TTTHPlaceCrystal", "TTTHPlaceCrystal", function(ply)
		if ply:HasClass() then
			ply:GivePassiveClassEquipment()
		end
	end)
	
	hook.Add("TTTCPreventClassEquipment", "TTTHEquipmentOnlyWithCrystal", function(ply)
			return PreventWhenExecutedWithoutCrystal(ply)
	end)

else

	hook.Add("TTTCPreventClassAbortion", "TTTHAbortionOnlyWithCrystal", function(ply)
			return PreventWhenExecutedWithoutCrystal(ply)
	end)

	hook.Add("TTTCPreventCharging", "TTTHCharingOnlyWithCrystal", function(ply)
			return PreventWhenExecutedWithoutCrystal(ply)
	end)

	hook.Add("TTTScoreboardColumns", "TTTHScoreboardClass", function(pnl)
		--little timer to let the global bools update
		timer.Simple(0.1, function() 
			if GetGlobalBool("ttt2_classes") and GetGlobalBool("ttt2_heroes") then
				if isfunction(pnl.GetColumns) then
					for _, label in ipairs(pnl:GetColumns()) do
						if label:GetText() == "Class" then
							label:SetText("Hero")
						end
					end
				end

			end
		end)
	end)

	hook.Add("TTT2AddChange", "TTTHeroesChanges", function()
		AddChange("TTT2 Heroes - v0.4", [[
			<ul>
				<li>Hunter jumps in line of sight! (aim higher to jump further)</li>
				<li>One can chose between two heroes.</li>
				<li>The swift can grip himselt at the wall with the use of his ability. He rolls off automatically and can use his weapon while doing so.</li>
				<li>The meditate will be rendered semi transparent while using his ability.</li>
				<li>The dazzle will only dazzle players that are looking in his direction.</li>
				<li>A player will autoselect his weapon after using his ability.</li>
				<li>The frost got improved and is no longer iinfluenced by the sphere.</li>
				<li>The chaos now interchanges [W] and [S] too.</li>
				<li>Ac-/detivating the ability of the resistant now plays a sound.</li>
				<li>The breach recieves the bulldozer but can use this ability only once.</li>
				<li>The conceil now receives a T-Suitcase when removing non zombie/innocent corpses.</li>
				<li>Fixed problems with the predator</li>
				<li>The crystal will be colored in the player role color, but only when the role is synced.</li>
				<li>Rewrite of the equipment system</li>
			</ul>
		]], os.time({year = 2019, month = 03, day = 02}))

		AddChange("TTT2 Heroes - v0.5", [[
			<ul>
				<li>Using the HUD system of the newest TTT2 version</li>
				<li>The conceal got edited:
					<ul>
						<li>Evil roles get for removing innocent bodies +10HP and +10MaxHP</li>
						<li>Innocent roles receive a T-Suitcase for removing evil bodies</li>
					</ul>
				</li>
				<li>Removed predator charging.</li>
				<li>Fixing the breach.</li>
				<li>the float ability is now a passive ability.</li>
				<li>Removed falldamage of blink and hunter.</li>
				<li>Increases walkspeed of nebula about 50% in his own smoke.</li>
				<li>Added a de-/activation sound to the mirror.</li>
				<li>The dazzle gets a 2s speedboost after activating his ability.</li>
				<li>Increased the swift sprint speed about 25%.</li>
				<li>Fixed vendetta.</li>
				<li>Removed the soun dof the necrodefi.</li>
				<li>Changed the necromancer roleicon.</li>
				<li>Added random timed zombie sounds to the zombies.</li>
			</ul>
		]], os.time({year = 2019, month = 03, day = 18}))

		AddChange("TTT2 Heroes - v1.0", [[
			<ul>
				<li>Refactored TTTH to work on top of a newly patched TTTC.</li>
				<li>Added status icons to some abilities.</li>
				<li>Switched from jester to jackal to avoid confusion with the classic jester role.</li>
				<li>Removed ulib dependency.</li>
				<li>Hides now the heroes logo, when the heroes gamemode is disabled via convar.</li>
			</ul>
		]], os.time({year = 2019, month = 09, day = 05}))
	end)
end