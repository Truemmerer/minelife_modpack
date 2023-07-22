---------------
-- Clearchest
-- Tool to clear chests and remove them.


minetest.register_tool(":minelife_chest:clearchest", {
	description = "Remove all Items in a chest. For Server Team Members",
	inventory_image = "clearchest.png",
	stack_max = 1,

    -- clear the chest
    on_use = function(itemstack, placer, pointed_thing)

        local player_name = placer:get_player_name()

        -- check if the player have the minelife_chest_admin priv.
        if minetest.check_player_privs(player_name, "minelife_chest_admin") then

            if pointed_thing.type == "node" then
                local chest_pos = pointed_thing.under
                local meta = minetest.get_meta(chest_pos)
                local inv = meta:get_inventory()

                if meta:get_string("infotext") == "MineLife Chest" then

                    if inv:is_empty("main") then
                        minetest.chat_send_player(player_name, colorize("#3Chest is already empty."))
                    else
                        inv:set_list("main", {})
                    end
                    return itemstack
                else
                    minetest.chat_send_player(player_name, colorize("#0Node is not a Minelife Chest!"))
                    return itemstack
                end

            end
        
        -- if the player have not the minelife_chest_admin priv
        else
            minetest.chat_send_player(player_name, colorize("#0You do not have the right to use this tool. Requires: minelife_chest_admin"))
            return itemstack
        end

    end, -- on_use END

    -- remove the chest
    on_place = function(itemstack, placer, pointed_thing)

        local player_name = placer:get_player_name()

        -- check if the player have the minelife_chest_admin priv.
        if minetest.check_player_privs(player_name, "minelife_chest_admin") then

            if pointed_thing.type == "node" then
                local chest_pos = pointed_thing.under
                local meta = minetest.get_meta(chest_pos)
                local inv = meta:get_inventory()

                if inv:is_empty("main") then
                    
                    if meta:get_string("infotext") == "MineLife Chest" then
                        minetest.remove_node(chest_pos)
                        return itemstack
                    else
                        minetest.chat_send_player(player_name, colorize("#0Node is not a Minelife Chest!"))
                    end
                else
                    minetest.chat_send_player(player_name, colorize("#0Chest is not empty. To clear the chest, use leftclick"))
                    return itemstack
                end

            end

        
        -- if the player have not the minelife_chest_admin priv
        else
            minetest.chat_send_player(player_name, colorize("#0You do not have the right to use this tool. Requires: minelife_chest_admin"))
        end


	end, -- on_secondary_use END

}) -- minetest.register_tool END

