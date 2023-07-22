minetest.register_tool(":minelife_jobsystem:add_node", {
	description = "Edit Blocks for jobs",
	inventory_image = "spleef_team_tool.png",
	stack_max = 1,

	on_use = function(itemstack, placer, pointed_thing)
		local player_name = placer:get_player_name() 


        if not minetest.check_player_privs(player_name, {jobadmin=true}) then
            
            minetest.chat_send_player(player_name, colorize("#0 You can't use this tool. Need priv: jobadmin"))
            return
        else
            local pos = pointed_thing.under
            if pointed_thing.type == "node" then
                local node = minetest.get_node(pos)
                local node_name = node.name
                local param2 = node.param2
                
                minelife_jobsystem.tool_gui(player_name, node_name, param2)
                

            elseif pointed_thing.type == "object" then
                local pointed_object = pointed_thing.ref
                local mob = pointed_object:get_luaentity()
                local mob_name = mob.name
                if mob_name == "" or mob_name == nil then
                    minetest.chat_send_player(player_name, colorize("#0mob_name nil or no name"))
                    return
                end
                minelife_jobsystem.tool_gui_object(player_name, mob_name)
                
            end
        end
	end,

	on_place = function(itemstack, placer, pointed_thing)
		local player_name = placer:get_player_name()

            if not minetest.check_player_privs(player_name, {jobadmin=true}) then
                
                minetest.chat_send_player(player_name, colorize("#0 You can't use this tool. Need priv: jobadmin"))
                return
            end

            local pos = pointed_thing.under
            if pointed_thing.type == "node" then
                local node = minetest.get_node(pos)
                local node_name = node.name
                
                local amount, param2, param2_need = minelife_jobsystem.check_amount("farmer", node_name)
                minetest.chat_send_player(player_name, colorize("#1 Farmer | Node Name: "..node_name.." | Param2: "..param2.." | Param2_need: "..param2_need.." | Amount: "..amount))

                amount, param2, param2_need = minelife_jobsystem.check_amount("miner", node_name)
                minetest.chat_send_player(player_name, colorize("#1 Miner | Node Name: "..node_name.." | Param2: "..param2.." | Param2_need: "..param2_need.." | Amount: "..amount))

                amount, param2, param2_need = minelife_jobsystem.check_amount("builder", node_name)
                minetest.chat_send_player(player_name, colorize("#1 Builder | Node Name: "..node_name.." | Param2: "..param2.." | Param2_need: "..param2_need.." | Amount: "..amount))

            end
	end,

})

function minelife_jobsystem.tool_gui(player_name, node_name, param2)

    local amount = 0
    
    minetest.show_formspec(player_name , "minelife_jobsystem:register_node", "size[8,8]"..
    "field[0.5,0.65;6,1;node_name_field;Node Name: ;"..node_name.."]"..
    "field[0.5,2;6,1;param2_field; Param2: ;"..param2.."]"..
    "field[0.5,3.35;6,1;amount_field; Amount: ;]"..
  --  "checkbox[0.5,4;param2_need;Param2 need? enter yes;false]"..

    "button[2.5,5.5;3,1;farmer_button;Farmer]"..
    "button[2.5,6.5;3,1;miner_button;Miner]"..
    "button[2.5,7.5;3,1;builder_button;Builder]"..

    "button_exit[7.5,0;0.5,0.5;exit;X]")

end

function minelife_jobsystem.tool_gui_object(player_name, object_name)

    local amount = 0
    
    minetest.show_formspec(player_name , "minelife_jobsystem:register_object", "size[8,8]"..
    "field[0.5,0.65;6,1;object_name_field;Object Name: ;"..object_name.."]"..
   -- "field[0.5,2;6,1;param2_field; Param2: ;"..param2.."]"..
    "field[0.5,2;6,1;amount_field; Amount: ;]"..
  --  "checkbox[0.5,4;param2_need;Param2 need? enter yes;false]"..

    "button[2.5,5.5;3,1;hunter_button;Hunter]"..
--    "button[2.5,6.5;3,1;miner_button;Miner]"..
--    "button[2.5,7.5;3,1;builder_button;Builder]"..

    "button_exit[7.5,0;0.5,0.5;exit;X]")

end

minetest.register_on_player_receive_fields(function(player, formname, fields)

    local player_name = player:get_player_name()
    local job = ""
    local object_name = ""
    local param2 = 0

    if formname == ("minelife_jobsystem:register_object") then
        local amount = nil
        if tonumber(fields.amount_field) == nil then
            return false
        else
            amount = tonumber(fields.amount_field)
        end
        if fields.object_name_field == nil then
            return false
        else
            object_name = fields.object_name_field
        end

        if fields["hunter_button"] then
            job = "hunter"
        end
        if  not minelife_jobsystem.add_node(job, amount, object_name, param2) == true then
            minetest.chat_send_player(player_name, colorize("#0 Can't add the node!"))
            return
        end

        minetest.close_formspec(player_name, "minelife_jobsystem:register_node")
        minetest.chat_send_player(player_name, colorize("#3 +Object: "..object_name.." | Param2: "..param2.." | Amount: "..amount))
    
    elseif formname == ("minelife_jobsystem:register_node") then

        local amount = nil
        local param2 = ""
        local param2_n = "false"
        local node = ""
        local job = ""

        if tonumber(fields.amount_field) == nil then
            return false
        else
            amount = tonumber(fields.amount_field)
        end

        if fields.param2_field == nil then
            return false
        else
            param2 = fields.param2_field
        end

        if fields.node_name_field == nil then
            return false
        else
            node = fields.node_name_field
        end

        if fields["builder_button"] then
            job = "builder"
        elseif fields["farmer_button"] then
            job = "farmer"
        elseif fields["miner_button"] then
            job = "miner"
        end 

        if  not minelife_jobsystem.add_node(job, amount, node, param2) == true then
            minetest.chat_send_player(player_name, colorize("#0 Can't add the node!"))
            return
        end

        minetest.close_formspec(player_name, "minelife_jobsystem:register_node")
        minetest.chat_send_player(player_name, colorize("#3 +Node: "..node.." | Param2: "..param2.." | Amount: "..amount))


    end

end)