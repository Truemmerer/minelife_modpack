minelife_chest.minelife_chests_upgrade_spec = function (player, meta)


    local player_name = player:get_player_name()
    minetest.show_formspec(player_name, "minelife_chests:upgrade", "size[7,7]" ..
        "formspec_version[4]"..
        "background[0,0;0.5,0.5;minelife_chest_background.png;true]"..
        
        "label[0,0; Upgrade Chest]"..
        "button_exit[6.5,0;0.5,1;button_back;X]"..

    -- Upgrade Slots
        "label[0,1;Upgrade Chest Space (1x8)  | Coasts: "..minelife_chest.upgrate_space_coasts.."]"..
        "button[0,1.5;7,1;button_more_inventory; Upgrade Chest Space  |  "..meta:get_int("chest:upgrade_inv").." / "..minelife_chest.upgrate_expand.."]"..
        
    -- Add Pipeworks
        "label[0,2.5;Add PipeWorks  |  Coasts: "..minelife_chest.Pipeworks_costs.."]"..
        "button[0,3;7,1;button_add_pipeworks; PipeWorks  |  "..meta:get_string("chest:pipeworks").."]"..


    -- Enderchest    
        "label[0,4.5;Upgrade an Enderchest to share its inventory with other Enderchest | Coasts: "..minelife_chest.upgrate_enderchest_costs.. "]"..
        "button[0,5;7,1;button_upgrade_enderchest; Upgrade to Enderchest]"

    )

end