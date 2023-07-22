minelife_chest.minelife_chests_change_owner_spec = function (player, meta)


    local player_name = player:get_player_name()
    minetest.show_formspec(player_name, "minelife_chests:owner_change", "size[7,7]" ..
        "formspec_version[4]"..
        "background[0,0;0.5,0.5;minelife_chest_background.png;true]"..
        
        "label[0,0; Change Owner of a MineLife Chest]"..
        "button_exit[6.5,0;0.5,1;button_back;X]"..

        "label[0,1;Current owner: "..meta:get_string("chest:owner").."]"..
         
        "label[0,1.5;Enter a new owner:]"..
        "field[0.3,2.5;5,1;field_new_owner;;]"..
        "button[0,3;2.5,1;button_owner_save;Save]"..
        
        "label[0,5;Please note that you will no longer have access to the Chest after the change,\n unless you have previously signed up as an additional player!]"
        

    )

end