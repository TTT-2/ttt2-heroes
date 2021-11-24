local L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[SUPERVILLAIN.name] = "Supervillain"
L["info_popup_" .. SUPERVILLAIN.name] = [[You are a Supervillain! Try to destroy some Crystals with your knife to earn yourself some credits!
Removing Crystals also removes the hero ability of the owner.]]
L["body_found_" .. SUPERVILLAIN.abbr] = "They were a Supervillain!"
L["search_role_" .. SUPERVILLAIN.abbr] = "This person was a Supervillain!"
L["target_" .. SUPERVILLAIN.name] = "Supervillain"
L["ttt2_desc_" .. SUPERVILLAIN.name] = [[The Supervillain is a Traitor (who works together with the other traitors)! The goal is to kill all other roles except the other traitor roles. The Supervillain is able to destroy the crystals of his enemies to get credits and remove their hero abilities.]]

-- OTHER LANGUAGE STRINGS
L["credit_h_all"] = "You have been awarded {num} equipment credit(s) by destroying a crystal."

L["ttt2_heroes_hero_sb"] = "Hero"

L["ttt2_heroes_crystal_already_placed"] = "You have already placed a crystal!"
L["ttt2_heroes_not_on_ground"] = "You have to stand on solid ground to place your crystal!"
L["ttt2_heroes_crystal_placed"] = "Your crystal has been successfully placed!"
L["ttt2_heroes_crystal_picked_up"] = "You've successfully picked up your crystal!"
L["ttt2_heroes_crystal_destoyed"] = "Your crystal has been destroyed!"
L["ttt2_heroes_ability_disabled"] = "You can't use your ability since you haven't placed your crystal!"
L["ttt2_heroes_crystal_already_picked_up"] = "You can pickup your crystal only {num} time(s)!"
L["ttt2_heroes_crystal_already_no_pickup"] = "You can't pickup your crystal!"
L["ttt2_heroes_all_crystals_destroyed"] = "All crystals have been destroyed!"
L["ttt2_heroes_crystal_ability_pickup_disabled"] = "You can't pickup your crystal since you have no ability!"
L["ttt2_heroes_crystal_auto_placed"] = "Attempting to auto place your crystal. You can disable this feature in the local heroes settings."

L["ttt2_heroes_bind_place"] = "Place Crystal"
L["ttt2_heroes_settings_crystal"] = "Crystal"
L["ttt2_heroes_entity_crystal"] = "Heroes Crystal"
L["ttt2_heroes_entity_crystal_owner_self"] = "You are the owner of this crystal!"
L["ttt2_heroes_entity_crystal_owner_unknown"] = "The owner of this crystal is unknown"
L["ttt2_heroes_entity_crystal_owner"] = "Crystal owner: "
L["ttt2_heroes_entity_crystal_knife"] = "Use your crystal knife to gain equipment credits"
L["ttt2_heroes_entity_crystal_cant_interact"] = "You can't interact with this crystal"
L["ttt2_heroes_entity_crystal_destroy"] = "DESTROY"

L["submenu_addons_heroes_title"] = "TTT2 Heroes"
L["header_addons_heroes"] = "General Heroes Settings"
L["label_heroes_auto_place_enable"] = "Should the system try to place the Crystal automatically after hero selection?"

L["header_bindings_heroes"] = "TTT2 Heroes"

L["submenu_server_addons_heroes_title"] = "TTT2 Heroes"
L["header_server_addons_heroes"] = "General Heroes Settings"

L["label_heroes_enable"] = "Enable TTT2 Heroes"
L["label_heroes_max_crystal_pickups"] = "Upper crytal pickup limit"

L["help_heroes_enable"] = "Disabling Heroes only disables the hero functionality, not the classes itself. You have to disable TTT2 Classes to play without classes alltogether."
L["help_heroes_max_crystal_pickups"] = "Set upper limit for crystal pickups, set to '-1' to allow for infinite pickups."
