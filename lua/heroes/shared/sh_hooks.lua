local function PreventWhenExecutedWithoutCrystal(ply)
        if not ply:HasCrystal() then
                return true
        end

        return false
end

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

        hook.Add("TTT2AddChange", "TTTHeroesChanges", function()
		AddChange("TTTH v0.4", [[<ul>
		<li>Hunter springt in Blickrichtung! (Ziele höher, um weiter zu springen)</li>
		<li>Man kann nun zwischen 2 Helden wählen</li>
		<li>Der Swift kann sich mit seiner Fähigkeit an einer Wand festhalten. Er rollt sich automatisch ab und man kann nun mit Waffen springen</li>
		<li>Der Meditate wird halb transparent, wenn er aktiv ist</li>
		<li>Der Dazzle sollte nun nur Spieler blenden, die ihn anschauen, wenn er die Fähigkeit nutzt</li>
		<li>Wenn man eine Ability nutzt, die die Waffen kurzzeitig deaktiviert, dann bekommt man die Waffe danach in die Hand, die man vor der Fähigkeit auch in der Hand hatte</li>
		<li>Der Frost wurde stiltechnisch verbessert und wird selbst nicht mehr geslowed</li>
		<li>Der Chaos vertauscht nun auch [W] und [S]</li>
		<li>Der Resistant macht einen Aktivierung<li>und Deaktivierungssound</li>
		<li>Der Breach bekommt nun den Bulldozer, kann diesen aber nur einmal aktivieren</li>
		<li>Der Conceal bekommt nun ein TSuitCase, wenn er Nicht-Zombie/-Inno Leichen removed</li>
		<li>Vendetta gibt nun den Grund für das Nicht-Respawnen aus</li>
		<li>Predator sollte gefixt sein</li>
		<li>Der Kristall wird nun in der Farbe gefärbt, in der man den Spieler auf dem Scoreboard hat</li>
		<li>Das Equipmentsystem wurde komplett neugeschrieben</li>
		</ul>]])

		AddChange("TTTH v0.5", [[<ul>
		<li>Das HUD wurde an die <b>neueste TTT2 Version</b> angepasst</li>
		<li>Der Conceal wurde angepasst:
			<ul>
				<li>Böse bekommen für Gute +10HP und +10MaxHP</li>
				<li>Gute bekommen für Böse ein T-Suit-Case (Random T-Item)</li>
			</ul>
		</li>
		<li>Der Predator muss nun nicht mehr chargen</li>
		<li>Breach (Bulldozer) wurde gefixt</li>
		<li>Float gleitet nun immer passiv</li>
		<li>Blink und Hunter bekommen keinen Fallschaden mehr</li>
		<li>Nebula ist nun in seiner Smoke 50% schneller</li>
		<li>Der Mirror spielt nun einen Aktivierungs- und Deaktivierungssound</li>
		<li>Dazzle bekommt nun bei der Aktivierung der Fähigkeit einen Speedboost für 2s</li>
		<li>Der Swift sprintet jetzt 25% schneller</li>
		<li>Vendetta gefixt</li>
		<li>Sounds beim Transformieren eines Spielers zum Zombie entfernt</li>
		<li>Necromancer hat nun ein neues Icon um ihm vom TTT2 Infected besser zu unterscheiden</li>
		<li>Der Zombie schreit jetzt zufällig zwischen 5 und 25 Sekunden. Der erste Schrei ist um 10 Sekunden verzögert</li>
		</ul>]])
	end)
end

hook.Add("TTTCPreventClassActivation", "TTTHActivationOnlyWithCrystal", function(ply)
        return PreventWhenExecutedWithoutCrystal(ply)
end)