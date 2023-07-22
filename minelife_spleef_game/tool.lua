minetest.register_tool(":minelife_spleef_game:spleef_create", {
	description = "Add Blocks to the area",
	inventory_image = "spleef_team_tool.png",
	stack_max = 1,

    on_use = function(itemstack, placer, pointed_thing)
       
       local player_name = placer:get_player_name() 
       local meta = minetest.get_player_by_name(player_name):get_meta()
       local last_pos_id = meta:get_int("spleef_area_pos_id")
       local area_name = meta:get_string("spleef_area_name")

        if minelife_spleef_game.check_priv(player_name) == true then

            if area_name == nil or area_name == "" then
                minetest.chat_send_player(player_name, colorize("#0 You need to use following command first: /spleef create <area_name>."))
                return
            else
                if pointed_thing.type == "node" then
                    local pos = pointed_thing.under
                    local readpos = minetest.pos_to_string(pos)
                    local currentArea = {}
                    local node = minetest.get_node(pos)
                    local node_name = ""
                    node_name = node.name

                    if node.name == "default:snowblock" then
                        minetest.chat_send_player(player_name, colorize("#0 Block is already a Spleef block"))
                        return
                    end

                    if meta:get_string("currentArea") ~= nil and meta:get_string("currentArea") ~= "" then
                        currentArea = minetest.deserialize(meta:get_string("currentArea"))
                    end

                    local new_pos_id = last_pos_id + 1
                    meta:set_int("spleef_area_pos_id", new_pos_id)

                    currentArea[new_pos_id] = {
                        pos = pos,
                        node_name = node_name,
                    }

                    meta:set_string("currentArea", minetest.serialize(currentArea))
                    minetest.remove_node(pos)
                    minetest.set_node(pos, {name="default:snowblock"})

                    --minetest.chat_send_player(player_name, colorize("#3Add node to area: "..area_name))

                end    
            end
        else
            minetest.chat_send_player(player_name, colorize("#0You can't use this tool. Need priv: minelife_spleef_team"))
        end
    end
})

minetest.register_tool(":minelife_spleef_game:spleef_pick", {
    description = "The game pick to remove spleef glass blocks",
    inventory_image = "player_tool.png",
    stack_max = 1,

    on_use = function (itemstack, placer, pointed_thing)
        local pos = pointed_thing.under

        if pointed_thing.type == "node" then
           
            local node_meta = minetest.get_meta(pos)
            if node_meta:get_int("spleef") == 1 then
                minetest.remove_node(pos)
            end

        end
        
    end
})

minetest.register_chatcommand("spleef", {
    description = "create, remove or restore a area.",
    params = "create/save/remove/restore <area_name>",
    privs = {minelife_spleef_team = true},
    
    func = function(name, param)

        local whatdo, area_name = string.match(param, "(%S+) (%S+)") --spalte param in einzelne Strings auf
        local meta = minetest.get_player_by_name(name):get_meta()

        if whatdo == "save" then --fürs dauerhafte speichern

            if meta:get_string("currentArea") == nil or meta:get_string("currentArea") == "" then
                minetest.chat_send_player(name, colorize("#0 You need to create first a spleefarea"))
                return   
            end

            local current_table = meta:get_string("currentArea")

            if minelife_spleef_game.save_area(area_name, current_table) == true then
                meta:set_string("spleef_area_name", "")
                meta:set_int("spleef_area_pos_id", 0)
                minetest.chat_send_player(name, colorize("#3 Area saved"))
                
                return true

            else
                minetest.chat_send_player(name, colorize("#0 Error by save area"))
                
                return
            end

        elseif whatdo == "create" then -- um zu definieren, welche area nun erstellt werden soll
               
            if not minelife_spleef_game.check_if_exists(area_name) == true then
                meta:set_string("currentArea", "")
                meta:set_string("spleef_area_name", area_name)
                meta:set_int("spleef_area_pos_id", 0)
                minetest.chat_send_player(name, colorize("#3 You can now use the Tool spleef_create to add nodes"))
                
                return true
            else
                minetest.chat_send_player(name, colorize("#0 Area exists already"))
            end

        elseif whatdo == "restore" then
            if minelife_spleef_game.restore_game_area(area_name) == true then
                minetest.chat_send_player(name, colorize("#3 Area "..area_name.." is restored"))
            else
                minetest.chat_send_player(name, colorize("#0 Area "..area_name.." not found"))  
                
            end

        elseif whatdo == "remove" then
      
            if minelife_spleef_game.remove_game_area(area_name) == true then
                minetest.chat_send_player(name, colorize("#3 Area "..area_name.." removed"))
            else
                minetest.chat_send_player(name, colorize("#0 Area "..area_name.." can't remove"))         
            end

        elseif whatdo == "canc" then
         
            if meta:get_string("currentArea") == nil or meta:get_string("currentArea") == "" then
                minetest.chat_send_player(name, colorize("#0 You need to create first a spleefarea"))
                return   
            end

            local current_table = minetest.deserialize(meta:get_string("currentArea"))
	

            for variable, pos_id in pairs (current_table) do
                minetest.set_node(pos_id.pos, {name=pos_id.node_name})
				local node_meta = minetest.get_meta(pos_id.pos)
                node_meta:set_int("spleef", 1)
            end

            local meta = minetest.get_player_by_name(name):get_meta()
            meta:set_string("currentArea", "")
            meta:set_int("spleef_area_pos_id", 0)    
            meta:set_string("spleef_area_name", "")
            minetest.chat_send_player(name, colorize("#3 Create canceled"))
            
        else -- springt ein, wenn kein area_name angegeben wurde
            minetest.chat_send_player(name, colorize("#0 You did not use the command correctly. See /help for how to use it."))   
            
        end
    end  
  
})

minetest.register_chatcommand("spleef_restore", {
    description = "create, remove or restore a area.",
    params = "<area_name>",
    privs = {},
    
    func = function(name, area_name)
        if minelife_spleef_game.restore_game_area(area_name) == true then
            return true
        else
            return
        end
    end
})

--- Command to clear the own spleef metadata 
minetest.register_chatcommand("spleef_clear", {
    description = "Clear the spleef_create",
    params = "",
    privs = {minelife_spleef_team = true},

    func = function(name)

        local meta = minetest.get_player_by_name(name):get_meta()
        meta:set_string("currentArea", "")
        meta:set_int("spleef_area_pos_id", 0)    
        meta:set_string("spleef_area_name", "")

        minetest.chat_send_player(name, colorize("#3 Spleef Meta cleared"))  
        minetest.log("info", "[minelife_spleef_game]: spleef meta cleared for: "..name)

    end

})