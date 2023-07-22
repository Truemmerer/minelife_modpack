minetest.register_on_player_receive_fields(function(customer, formname, fields)
	----------------------------
    -- RENT BLOCKS
    ----------------------------
    if formname == "areas_pay_customer_rent" and fields.rent_button ~= nil and fields.rent_button ~= "" then
		local pos = default.areas_pay_pos[customer:get_player_name()]
		local meta = minetest.get_meta(pos)
        -- Check, if the area can be rented
        local rents = minetest.deserialize(areas_pay.storage:get_string("rents")) or {}
        local id = meta:get_int("areas_pay:area_id")
        if id == 0 then
        minetest.chat_send_player(customer:get_player_name(), "Shop unconfigured")
        minetest.close_formspec(customer:get_player_name(), "areas_pay_customer_rent")
        return
        end
        if not areas_pay:rents_registry_check(customer:get_player_name(), meta:get_string("areas_pay:group")) then
        minetest.chat_send_player(customer:get_player_name(), "You already rented such a area whithin this area group.")
        return
        end
        --       If the area is rented, and the time after renting is lower then two full periods
        if rents == nil or rents[id] == nil or (rents[id] ~= nil and (rents[id].rented_to + meta:get_int("areas_pay:period")*3600*24 - minetest.get_gametime()) < (meta:get_int("areas_pay:period")*3600*24 * areas_pay.MAX_RENT_PERIODS)) then
        -- Check if the customer has enough money, give him the area, and remove the block.
        local owner = meta:get_string("owner")
            if jeans_economy_book(customer:get_player_name(), meta:get_string("owner"), meta:get_int("areas_pay:price"), customer:get_player_name().." buys the Area with the ID " .. meta:get_string("areas_pay:area_id").." from " .. meta:get_string("owner")) then
            -- Select, and create a new area
            if rents ~= nil and rents[id] ~= nil and rents[id].rentID ~= nil then
            areas_pay.remove_recursive_areas(owner, rents[id].rentID)
            end
            minetest.chat_send_player(customer:get_player_name(), "Rented area successfully")
            areas_pay.select_area(owner, meta:get_string("areas_pay:area_id"))
            local newID = areas_pay.add_owner(owner, meta:get_string("areas_pay:area_id").." "..customer:get_player_name().." Rented Area")
            -- Figure out rented_to time
            local rented_to = 0
            if rents == nil or rents[id] == nil or rents[id].rented_to < minetest.get_gametime() then
            rented_to = minetest.get_gametime() + meta:get_int("areas_pay:period") * 24 * 3600
            else
            rented_to = rents[id].rented_to + meta:get_int("areas_pay:period") * 24 * 3600
            end
            rents[id] = {owner = owner, customer = customer:get_player_name(), rented_to=rented_to, rentID=newID, group = meta:get_string("areas_pay:group"), block_pos = pos}
            areas_pay.storage:set_string("rents", minetest.serialize(rents))
            meta:set_string("areas_pay:customer", customer:get_player_name())
            minetest.swap_node(pos, {name = "areas_pay:shop_block_red", param2 = 0})
            areas_pay:rents_registry_add(customer:get_player_name(), meta:get_string("areas_pay:group"))
        else
            minetest.chat_send_player(customer:get_player_name(), "You dont have enough money, to rent this!")
        end
        else
        minetest.chat_send_player(customer:get_player_name(), "You can only rent the area "..areas_pay.MAX_RENT_PERIODS.." times at once!")

        end
        minetest.close_formspec(customer:get_player_name(), "areas_pay_customer_rent")
	
    ----------------------------
    -- BUY BLOCKS
    ----------------------------
    elseif formname == "areas_pay_customer" and fields.buy_button ~= nil and fields.buy_button ~= "" then
        local pos = default.areas_pay_pos[customer:get_player_name()]
            local meta = minetest.get_meta(pos)
        -- Check, if the area can be rented
        local rents = minetest.deserialize(areas_pay.storage:get_string("rents")) or {}
        local id = meta:get_int("areas_pay:area_id")
        if id == 0 then
          minetest.chat_send_player(customer:get_player_name(), "Shop unconfigured")
          minetest.close_formspec(customer:get_player_name(), "areas_pay_customer")
          return
        end
        if not areas_pay:rents_registry_check(customer:get_player_name(), meta:get_string("areas_pay:group")) then
          minetest.chat_send_player(customer:get_player_name(), "You already buy such a area whithin this area group.")
          return
        end
        local owner = meta:get_string("owner")
        if jeans_economy_book(customer:get_player_name(), meta:get_string("owner"), meta:get_int("areas_pay:price"), customer:get_player_name().." buys the Area with the ID " .. meta:get_string("areas_pay:area_id").." from " .. meta:get_string("owner")) then
             -- Select, and create a new area
            if rents ~= nil and rents[id] ~= nil and rents[id].rentID ~= nil then
              areas_pay.remove_recursive_areas(owner, rents[id].rentID)
            end
            minetest.chat_send_player(customer:get_player_name(), "Buyed area successfully")
            areas_pay.select_area(owner, meta:get_string("areas_pay:area_id"))
            minetest.chat_send_player(customer:get_player_name(), "Buyed successfully Area")
            areas_pay.change_owner(meta:get_string("owner"), meta:get_string("areas_pay:area_id").." "..customer:get_player_name() )
            rents[id] = {owner = owner, customer = customer:get_player_name(), rented_to=rented_to, rentID=newID, group = meta:get_string("areas_pay:group"), block_pos = pos}
            areas_pay.storage:set_string("rents", minetest.serialize(rents))
            meta:set_string("areas_pay:customer", customer:get_player_name())
            areas_pay:rents_registry_add(customer:get_player_name(), meta:get_string("areas_pay:group"))
            minetest.remove_node(pos);
        else
            minetest.chat_send_player(customer:get_player_name(), "You dont have enough money, to rent this!")
        end
        minetest.close_formspec(customer:get_player_name(), "areas_pay_customer")
        
    ----------------------------
    -- SAVE FIELDS
    ----------------------------

    elseif formname == "areas_pay_owner" and fields.save_fields_button ~= nil and fields.save_fields_button ~= "" then
        local pos = default.areas_pay_pos[customer:get_player_name()]
        local meta = minetest.get_meta(pos)
        
        if not areas:isAreaOwner(tonumber(fields.area_id_field), customer:get_player_name()) then
          minetest.chat_send_player(customer:get_player_name(), "You don't own that area!")
          areas_pay_show_spec(customer)
          return
        end
        if tonumber(fields.price_field) ~= nil then
            meta:set_int("areas_pay:price", fields.price_field)
        end
        if tonumber(fields.price_field) ~= nil then
          meta:set_int("areas_pay:area_id", fields.area_id_field)
        end
        if tonumber(fields.price_field) ~= nil then
          meta:set_int("areas_pay:period", fields.period_field)
        end
        meta:set_string("areas_pay:group", fields.area_group)
        if meta:get_string("areas_pay:rs") == "Rent" then
          minetest.swap_node(pos, {name = "areas_pay:shop_block_green", param2 = 0})
          minetest.chat_send_player(customer:get_player_name(), "You set the Area ["..fields.area_id_field.."] for rent for "..fields.price_field.."$ per "..fields.period_field.." days.")
        else
          minetest.swap_node(pos, {name = "areas_pay:shop_block_blue", param2 = 0})
          minetest.chat_send_player(customer:get_player_name(), "You set the Area ["..fields.area_id_field.."] for buy for "..fields.price_field.."$.")
        end
        minetest.close_formspec(customer:get_player_name(), "areas_pay_owner")
    
    ----------------------------
    -- SET RENT / SALE
    ----------------------------

    elseif formname == "areas_pay_owner" and fields.set_rent_sell_button ~= nil and fields.set_rent_sell_button ~= "" then
        local pos = default.areas_pay_pos[customer:get_player_name()]
        local meta = minetest.get_meta(pos)
        if meta:get_string("areas_pay:rs") == "Rent" then
            meta:set_string("areas_pay:rs", "Sell")
        else
            meta:set_string("areas_pay:rs", "Rent")
        end
        areas_pay_show_spec(customer)

    ----------------------------
    -- MORE SLOT PLOTS BLOCK
    ----------------------------

    elseif formname == "more_area_slots" then
        local price_for_one = minelife_areas_pay.price_for_one_slot
        local price_for_five = minelife_areas_pay.price_for_one_slot * 5
        local price_for_ten = minelife_areas_pay.price_for_one_slot * 10
        local player_name = customer:get_player_name()
        local money_of_player = jeans_economy.get_account(player_name)

        if fields["buy_one_slot"] then

            --check Enoug Money ?
            if money_of_player < price_for_one then
                minetest.chat_send_player(player_name, colorize("#0You don't have enough money. Your account balance is: "..money_of_player))
                return false
            end

            minelife_server_tools.add_max_area_of_player(customer, 1)
            jeans_economy_change_account(player_name, - price_for_one)
            minelife_areas_pay.areas_pay_more_slots(customer)
            
        elseif fields["buy_five_slots"] then

            --check Enoug Money ?
            if money_of_player < price_for_five then
                minetest.chat_send_player(player_name, colorize("#0You don't have enough money. Your account balance is: "..money_of_player))
                return false
            end

            minelife_server_tools.add_max_area_of_player(customer, 5)
            jeans_economy_change_account(player_name, - price_for_five)
            minelife_areas_pay.areas_pay_more_slots(customer)

        elseif fields["buy_ten_slots"] then

            --check Enoug Money ?
            if money_of_player < price_for_ten then
                minetest.chat_send_player(player_name, colorize("#0You don't have enough money. Your account balance is: "..money_of_player))
                return false
            end

            minelife_server_tools.add_max_area_of_player(customer, 10)
            jeans_economy_change_account(player_name, - price_for_ten)
            minelife_areas_pay.areas_pay_more_slots(customer)

        end

    end

end)