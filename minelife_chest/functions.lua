-----------------------------------
-- MINELIFE CHEST ACCESS FUNCTION
-----------------------------------

function minelife_chest.proof_access(player)
    
    local player_name = player:get_player_name()
    
    local pos = minelife_chest.minelife_chests_current_position[player:get_player_name()]

    local meta = minetest.get_meta(pos)
    local owner = meta:get_string("chest:owner")

    local chest_player_table = minetest.deserialize(meta:get_string("chest:players"))
   
    if player_name == owner or minetest.check_player_privs(player_name, "minelife_chest_admin") then
        -- minetest.chat_send_all("Owner Check")
        return true;
    
    elseif chest_player_table ~= nil then
        for k, v in pairs(chest_player_table) do
            if player_name == v then
                -- minetest.chat_send_all("Player Table Check")
                return true;
            end
        end
    end

    if meta:get_string("chest:access_switch") == "true" and minelife_chest.areas_activated == true
    then

        -- minetest.chat_send_all("access_switch = true")

        if areas:canInteractInArea(pos, pos, player_name, true) then
            return true;
        else
            return false;
        end

    else
        -- minetest.chat_send_all("player error")
        return false;
    
    end
end

-----------------------------------
-- MONEY CHECK AND MONEY REVOKE
-----------------------------------

function minelife_chest.money_check(player_name, coasts)

    if  minelife_chest.jeans_economy == true then
                    
        if jeans_economy.get_account(player_name) < coasts then
                minetest.chat_send_player(player_name, colorize("#0You don't have enough money.\n #2The costs are: "..coasts))
                return false;
        end

        jeans_economy_change_account(player_name, - coasts)
        return true;
    end

end

-----------------------------------
-- SHOW THE CORRECT FORM
-----------------------------------

function minelife_chest.openform(player, formname)
    if formname == ("minelife_chests:chest_pipeworks") then
        minelife_chest.minelife_chests_pipeworks_spec(player)
    elseif formname == ("minelife_chests:chest") then
        minelife_chest.minelife_chests_spec(player)
    end
end

-----------------------------------
-- SET OLD META ON NEW NODE
-----------------------------------

function minelife_chest.set_meta_new_node(pos, name_new_node)

    -- save the meta Data
    local meta = minetest.get_meta(pos)

    local upgrade_inv = meta:get_int("chest:upgrade_inv")
    local chest_owner = meta:get_string("chest:owner")
    local chest_players = meta:get_string("chest:players")
    local access_switch = meta:get_string("chest:access_switch")
    local inv = meta:get_inventory()
    local inv_list = inv:get_list("main")


   
    -- replace node
    minetest.remove_node(pos)
    minetest.set_node(pos, {name=name_new_node})

    -- load meta from new block
    local new_meta = minetest.get_meta(pos)

   -- set old meta on new block
    new_meta:set_int("chest:upgrade_inv", upgrade_inv)
    new_meta:set_string("chest:owner", chest_owner)
    new_meta:set_string("chest:players", chest_players)
    new_meta:set_string("chest:access_switch", access_switch)

    local inv_new = new_meta:get_inventory()
    inv_new:set_list("main", inv_list)



    return true

    
end

-----------------------------------
-- MINELIFE CHEST BASIC FUNCTIONS
-----------------------------------


minetest.register_on_player_receive_fields(function(player, formname, fields)

    if formname == ("minelife_chests:chest") or formname == ("minelife_chests:upgrade") or formname == ("minelife_chests:chest_pipeworks") or formname == ("minelife_chests:owner_change") then

        local player_name = player:get_player_name()
        local pos =  minelife_chest.minelife_chests_current_position[player_name]
        local meta = minetest.get_meta(pos)
        local chest_player_table = minetest.deserialize(meta:get_string("chest:players")) or {}
        local inv = meta:get_inventory()

        --minetest.chat_send_all(textlist_name)
  
        if formname == ("minelife_chests:chest") or formname == ("minelife_chests:chest_pipeworks") then

            if fields["button_change_owner"] then

                if minelife_chest.allow_change_owner ~= false or minetest.check_player_privs(player_name, "minelife_chest_admin") then
                    minelife_chest.minelife_chests_change_owner_spec(player, meta)
                else
                    minetest.chat_send_player(player_name, colorize("#0You can't change the owner. Please contact a Server Team member"))                    
                end
            end

            if fields["switch_members"] and minelife_chest.areas_activated == true then

                if meta:get_string("chest:access_switch") == "false" then
                    meta:set_string("chest:access_switch", "true")
                    minelife_chest.openform(player, formname)                  
                else 
                    meta:set_string("chest:access_switch", "false")
                    minelife_chest.openform(player, formname)
                end

            
            elseif fields["add_player"] then

                if fields["player_text"] ~= nil and fields["player_text"] ~= "" then
                    chest_player_table[fields.player_text] = fields.player_text
                    meta:set_string("chest:players", minetest.serialize(chest_player_table))
                    minelife_chest.openform(player, formname)                  
                end       

            elseif fields["chest_upgrade"] then

                minelife_chest.minelife_chests_upgrade_spec(player, meta)

            elseif fields["remove_player"] then

                if fields["player_text"] ~= nil and fields["player_text"] ~= "" then
                    chest_player_table[fields.player_text] = nil
                    meta:set_string("chest:players", minetest.serialize(chest_player_table))
                    minelife_chest.openform(player, formname)                  
                end


            -- Pipeworks splitt toglgle
            elseif fields["pipeworks_splitt_toggle"] then
                
                if meta:get_int("chest:pipeworks_splitt") == 1 then

                    meta:set_int("chest:pipeworks_splitt", 0)
                    minelife_chest.openform(player, formname)                  
                else

                    meta:set_int("chest:pipeworks_splitt", 1)
                    minelife_chest.openform(player, formname)                  

                
                end

            end


-----------------------------------
-- MINELIFE CHEST UPGRADE FORM
-----------------------------------

        elseif formname == ("minelife_chests:upgrade") then

                
            if fields["button_upgrade_enderchest"] and minelife_chest.upgrate_enderchest == true then

                if  not inv:is_empty("main") then
                    minetest.chat_send_player(player_name, colorize("#0The upgrade is only available when there are no items in the chest."))

                else
                    -- Prüfe ob der Spieler genug Geld hat und falls ja, führe alles aus
                    if minelife_chest.money_check(player_name, minelife_chest.upgrate_enderchest_costs) == true then
                       
                        minetest.remove_node(pos)
                        minetest.set_node(pos, {name="minelife_chests:enderchest"})
                        minetest.chat_send_player(player_name, colorize("#3Upgrade Chest to a Enderchest"))                    
                        minelife_chest.minelife_enderchests_spec(player)

                    end

                end
            elseif fields["button_more_inventory"] then

                -- Prüfe ob der Spieler genug Geld hat und falls ja, führe alles aus

                if meta:get_int("chest:upgrade_inv") < minelife_chest.upgrate_expand then
                    if minelife_chest.money_check(player_name, minelife_chest.upgrate_space_coasts) == true then
                        meta:set_int("chest:upgrade_inv", meta:get_int("chest:upgrade_inv") + 1)
                        local new_chest_high = minelife_chest.default_chest_high + meta:get_int("chest:upgrade_inv")
                        inv:set_size("main", new_chest_high*minelife_chest.default_chest_bright)

                        minelife_chest.minelife_chests_upgrade_spec(player, meta)
                    end

                else
                    minetest.chat_send_player(player_name, colorize("#0You can no longer enlarge the chest. You have already reached the maximum size."))
                end

            elseif fields["button_add_pipeworks"] then

                -- Prüfe ob der Spieler genug Geld hat und falls ja, führe alles aus
    
                if meta:get_string("chest:pipeworks") == "true" then
                    
                    minetest.chat_send_player(player_name, colorize("#0Already enabled"))


                elseif meta:get_string("chest:pipeworks") == "disabled" or meta:get_string("chest:pipeworks") == "" or meta:get_string("chest:pipeworks") == nil then
    
                    if minelife_chest.money_check(player_name, minelife_chest.Pipeworks_costs) == true then
                            
                        meta:set_string("chest:pipeworks", "enabled");

                        local name_new_node = "minelife_chests:chest_pipeworks"
                        if minelife_chest.set_meta_new_node(pos, name_new_node) == true then
                            minetest.chat_send_player(player_name, colorize("#3Add Pipeworks"))
                        
                        else 
                            minetest.chat_send_player(player_name, colorize("#0Error by adding Pipeworks"))

                        end

                      minelife_chest.minelife_chests_upgrade_spec(player, meta)
 
                    end
                end
            
            end

-----------------------------------
-- MINELIFE CHEST OWNER CHANGE
-----------------------------------
        
        elseif formname == ("minelife_chests:owner_change") then

                
            if fields["button_owner_save"] then

                if fields["field_new_owner"] ~= nil and fields["field_new_owner"] ~= "" then
                    local new_owner = fields.field_new_owner
                    meta:set_string("chest:owner", new_owner)
                    minetest.close_formspec(player_name, "minelife_chests:owner_change")
                elseif fields["field_new_owner"] == nil or fields["field_new_owner"] == "" then
                    minetest.chat_send_player(player_name, colorize("#0You need to enter a playername"))
                else
                    minetest.chat_send_player(player_name, colorize("#0Error by change owner"))
                end   

            end
        
        
        end    
    end
end)

