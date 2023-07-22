minelife_chest.minelife_enderchests_spec = function (player)

    local player_name = player:get_player_name()

    minetest.show_formspec(player_name, "minelife_chests:chest", "size[8,11]" ..
            
                "formspec_version[4]"..
                "background[0,0;0.5,0.5;minelife_chest_background.png;true]"..

                "label[0,0;This chest shares the inventory with other Enderchests]"..
                "button_exit[7.5,0;0.5,1;button_exit;X]"..
                "list[current_player;enderchest;0,1;8,4;]"..
                "list[current_player;main;0,6;8,4;]"..
                "listring[current_player;enderchest]"..
                "listring[current_player;main]"
    )
end