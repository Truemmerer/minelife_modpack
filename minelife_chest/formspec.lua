minelife_chest.minelife_chests_spec = function (player)

    local player_name = player:get_player_name()
    
    local pos = minelife_chest.minelife_chests_current_position[player:get_player_name()]

    local meta = minetest.get_meta(pos)
    local owner = meta:get_string("chest:owner")
    local listname = "nodemeta:"..pos.x..','..pos.y..','..pos.z

    local area_button_text = ""
    local area_label_text = ""

    local inv = meta:get_inventory()
    --local inventory_size_high = meta:get_int("chest:upgrade_inv") + minelife_chest.default_chest_high



    if minelife_chest.areas_activated == true then
        if meta:get_string("chest:access_switch") == "false" or meta:get_string("chest:access_switch") == nil then
            area_button_text = "Allow area users"
            area_label_text = ""
        elseif meta:get_string("chest:access_switch") == "true" then
            area_button_text = "Disallow area users"
            area_label_text = "Access is allowed for area users"
        end
    else
        area_button_text = ""
        area_label_text = ""
    end

    local players_string = ""
    local chest_player_table = minetest.deserialize(meta:get_string("chest:players"))
    if chest_player_table ~= nil then
        for k, v in pairs(chest_player_table) do
            players_string = players_string .. v .. ", "
        end
    end

    -- Pipeworks check if allow splitting incoming stacks from tubes
    local minelife_chest_pipeworks_imagebutton = "pipeworks_button_off.png"

    if meta:get_int("chest:pipeworks_splitt") == 1 then
        minelife_chest_pipeworks_imagebutton = "pipeworks_button_on.png"
    end

    -- minetest.chat_send_all("Players_String:"..players_string)

    if player_name == owner or minetest.check_player_privs(player_name, "minelife_chest_admin") then

        
            minetest.show_formspec(player_name, "minelife_chests:chest", "size[11,12.5]" ..
            
                "formspec_version[4]"..
                "background[0,0;0.5,0.5;minelife_chest_background.png;true]"..

                "label[0,0;Chest Owner: "..owner.."]"..
                "button[8,12.25;3,0.5;button_change_owner;Change Owner]"..

                
                -- Player List with Access
                "label[8,1;The following players have access:]"..
                "textlist[8,1.5;2.8,8;player_list;"..players_string.."]" ..
                "field[8.3,10;3,1;player_text;;]" ..
                "button[8,10.5;1.5,1;add_player;Add]" ..
                "button[9.5,10.5;1.5,1;remove_player;Remove]" ..

                "button[8,11.5;3,0.5;switch_members;"..area_button_text.."]" ..

                "button_exit[10.5,0;0.5,1;button_exit;X]"..
                "image_button[8,0.15;2.25,0.75;upgrade.png;chest_upgrade;]"..
                
                -- Chest Storage
                "container[0,0.5]"..
                "label[0,0.5;Chest Storage:]" ..
                "list["..listname..";main;0,1;"..minelife_chest.default_chest_bright..","..minelife_chest.default_chest_high + meta:get_int("chest:upgrade_inv")..";]" ..
                "container_end[]"..

                -- Player Inventar
                "label[0,7.5;Your inventory:]" ..
                "list[current_player;main;0,8;8,4;]"..

                -- Enable Shift Move Item
                "listring["..listname..";main]" ..
	        	"listring[current_player;main]"
            )

    else

        minetest.show_formspec(player_name, "minelife_chests:chest", "size[11,12.5]" ..
            
        "formspec_version[4]"..
        "background[0,0;0.5,0.5;minelife_chest_background.png;true]"..

        "label[0,0;Chest Owner: "..owner.."]"..
       
        -- Player List with Access
        "label[8,1;The following players have access:]"..
        "textlist[8,1.5;2.8,8;player_list;"..players_string.."]" ..
        "label[8.3,10;"..area_label_text.."]" ..

        "button_exit[10.5,0;0.5,1;button_exit;X]"..
       
        -- Chest Storage
        "container[0,0.5]"..
        "label[0,0.5;Chest Storage:]" ..
        "list["..listname..";main;0,1;"..minelife_chest.default_chest_bright..","..minelife_chest.default_chest_high + meta:get_int("chest:upgrade_inv")..";]" ..
        "container_end[]"..

        -- Player Inventar
        "label[0,7.5;Your inventory:]" ..
        "list[current_player;main;0,8;8,4;]"..

        -- Enable Shift Move Item
        "listring["..listname..";main]" ..
        "listring[current_player;main]"
    )
    end
end

