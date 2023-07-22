----------------------------------------------------------------------------
-- usershop with licenses and currency with atm support
----------------------------------------------------------------------------

-- REGISTER CRAFT:
--[[
minetest.register_craft({
	output = "minelife_usershop:usershop",
	recipe = {
		{"default:bronze_ingot", "default:bronze_ingot", "default:bronze_ingot"},
		{"default:bronze_ingot", "default:chest_locked", "default:bronze_ingot"},
		{"default:bronze_ingot", "default:mese_crystal", "default:bronze_ingot"}
	}
})
--]]

local mail_boolean = false
if minetest.get_modpath("mail") then mail_boolean = true end


-- REGISTER NODE
default.usershop_current_atm_shop_position = {}
minetest.register_node("minelife_usershop:usershop", {

    description = "Usershop",
		tiles = {"usershop_top.png",
				"usershop_top.png",
				"usershop_side.png",
				"usershop_side.png",
				"usershop_side.png",
				"usershop_side.png",},
    is_ground_content = false,
  	groups = {cracky = 1, level = 2},
  	sounds = default.node_sound_metal_defaults(),
  -- Registriere den Owner beim Platzieren:
    after_place_node = function(pos, placer, itemstack)
      local meta = minetest.get_meta(pos)
		
      meta:set_string("usershop:bs", "Buy")
      meta:set_string("usershop:bs_5", "Buy")
      meta:set_string("usershop:bs_10", "Buy")
      meta:set_string("usershop:bs_99", "Buy")
			meta:set_int("usershop:price", 0)
      meta:set_int("usershop:price_5", 0)
      meta:set_int("usershop:price_10", 0)
      meta:set_int("usershop:price_99", 0)

      meta:set_string("owner", placer:get_player_name())
			meta:set_int("usershop:counter", 0)
      local inv = meta:get_inventory()
      inv:set_size("itemfield", 1*1)
      inv:set_size("main", 4*8)
    end,
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
      -- Schreibe die eigene Position des Blockes in eine öffentliche Variable mit dem Namen des Spielernamens, welcher auf den Block zugegriffen hat
      default.usershop_current_atm_shop_position[player:get_player_name()] = pos
      usershop_show_spec_atm(player)
    end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
      local meta = minetest.get_meta(pos)
      if player:get_player_name() ~= meta:get_string("owner") then return 0 end
      return stack:get_count()
    end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
      local meta = minetest.get_meta(pos)
      if player:get_player_name() ~= meta:get_string("owner") then return 0 end
      return stack:get_count()
    end,
    can_dig = function(pos, player)
      local meta = minetest.get_meta(pos)
      if player:get_player_name() == meta:get_string("owner") or minetest.check_player_privs(player:get_player_name(), {protection_bypass}) then
        return true
      else
        minetest.chat_send_player(player:get_player_name(), "You arent the owner of the shop!")
        return false
    end
  end


})

usershop_show_spec_atm = function (player)
    local pos = default.usershop_current_atm_shop_position[player:get_player_name()]
    local meta = minetest.get_meta(pos)
    local listname = "nodemeta:"..pos.x..','..pos.y..','..pos.z
    local playername = player:get_player_name()


    if player:get_player_name() == meta:get_string("owner") then

     minetest.show_formspec(player:get_player_name(), "usershop:usershop_atm", "size[8,10.5]"..
     "label[0,0;Welcome back, ".. meta:get_string("owner").."]" ..
		 "label[2.5,0.7;Counter: "..meta:get_int("usershop:counter").."]" ..
     "label[0.6,0.6;Item:]" ..
     "list["..listname..";itemfield;0.5,1.1;2,2;]"..
		 "field[5.4,0.8;2.7,1;price_field;Price:;"..meta:get_string("usershop:price").."]" ..
		 "button[5.1,1.3;2.7,1;set_price;Set Price]" ..
     "list["..listname..";main;0,2.5;8,4;]"..
     "list[current_player;main;0,6.8;8,4;]" ..
     "button_exit[7.75,0;0.5,0.5;exit_button;X]"..
     "button[2.2,1.1;2,1;set_buy_sell;"..meta:get_string("usershop:bs").."]"
   )
    else
      minetest.show_formspec(player:get_player_name(), "usershop:usershop_atm", "size[8,7.5]"..
      "label[0,0;Welcome, "..player:get_player_name().."]" ..
      "button_exit[7.75,0;0.5,0.5;exit_button;X]"..
      "label[0,0.5;Item:]" ..
     
      "list["..listname..";itemfield;0,1;2,2;]"..
		  "label[5.2,0.25;Price for 1:\t\t\t"..meta:get_string("usershop:price").."]" ..
      "label[5.2,0.55;Price for 5:\t\t\t"..meta:get_string("usershop:price_5").."]" ..
		  "label[5.2,0.85;Price for 10:\t\t"..meta:get_string("usershop:price_10").."]" ..
		  "label[5.2,1.15;Price for 99:\t\t"..meta:get_string("usershop:price_99").."]" ..

			"label[5.2,1.8;Your Balance: "..jeans_economy.get_account(playername).."]" ..
      "list[current_player;main;0,3.5;8,4;]" ..

      -- Buy / Sell Buttons
 
      "button[0,2.5;2,1;buy_sell_1;"..meta:get_string("usershop:bs").." 1]" ..
      "button[2,2.5;2,1;buy_sell_5;"..meta:get_string("usershop:bs_5").." 5]" ..
      "button[4,2.5;2,1;buy_sell_10;"..meta:get_string("usershop:bs_10").." 10]" ..
      "button[6,2.5;2,1;buy_sell_99;"..meta:get_string("usershop:bs_99").." 99]"
    
    )
  end
end

-- ======= 1 =======
-- Wenn der Spieler auf Exchange gedrückt hat:
minetest.register_on_player_receive_fields(function(customer, formname, fields)
	
  -- BUY / SELL 1
  if formname == "usershop:usershop_atm" and fields.buy_sell_1 ~= nil and fields.buy_sell_1 ~= "" then
    local pos = default.usershop_current_atm_shop_position[customer:get_player_name()]
    local meta = minetest.get_meta(pos)
    local minv = meta:get_inventory()
    local pinv = customer:get_inventory()
    local items = minv:get_list("itemfield")
    local owner = meta:get_string("owner")
    local playername = customer:get_player_name()

    if items == nil then return end -- do not crash the server

	-- Check if We Can Exchange: -------------------------------------
  -- INVENTORY
  for i, item in pairs(items) do
    if not pinv:room_for_item("main", item)  then
      minetest.chat_send_player(customer:get_player_name(),"You dont have enough room in your inventory!" )
    end
    -- Customer: Enough Items?
    if meta:get_string("usershop:bs") == "Sell" and not pinv:contains_item("main", item)  then
      minetest.chat_send_player(customer:get_player_name(),"You dont have enough items to sell!" )
      return
    end
    -- Does the Shop has enough space?
    if meta:get_string("usershop:bs") == "Sell" and not minv:room_for_item("main", item)  then
      minetest.chat_send_player(customer:get_player_name(),"The shop is full! Please contact the owner for that." )
      return
    end
  -- Does the Shop has the required Item?
    if  meta:get_string("usershop:bs") == "Buy" and not minv:contains_item("main", item)  then
      minetest.chat_send_player(customer:get_player_name(),"The shop is empty! The owner has automaticly been contacted." )
			if mail_boolean then
				mail.send("Usershop", owner, "Usershop Empty! ("..minetest.pos_to_string(pos)..")", "Dear " .. owner .. ", your usershop at " .. minetest.pos_to_string(pos) .. " with " .. item:get_name() .. " is empty! \nPlease refill your shop soon!")
			end
      return
    end
  end

  -- MONEY:
	-- Customer: Enough Money???

	if meta:get_string("usershop:bs") == "Buy" and jeans_economy.get_account(playername) < meta:get_int("usershop:price") then
		minetest.chat_send_player(customer:get_player_name(),"You dont have enough money on your account!" )
		return
  end

  -- Owner: Enough Money???

  if meta:get_string("usershop:bs") == "Sell" and jeans_economy.get_account(meta:get_string("owner")) < meta:get_int("usershop:price") then
    minetest.chat_send_player(customer:get_player_name(),"The Owner hansn't enough money to pay you out! Contact the owner for that." )
    return
  end

  -- 1
	-- Buy / Sell Process: --------------------------------------------------------------
		-- BUY:
		if meta:get_string("usershop:bs") == "Buy" then
			local item_name = "Nothing"
			local item_count = 1
      for i, item in pairs(items) do
				pinv:add_item("main",item)
        minv:remove_item("main", item)
				item_name = item:get_name()
				item_count = item:get_count()
      end
    jeans_economy_change_account(customer:get_player_name(), - meta:get_int("usershop:price"))
		jeans_economy_change_account(owner, meta:get_int("usershop:price"))

			usershop_show_spec_atm(customer)
			meta:set_int("usershop:counter", meta:get_int("usershop:counter") + 1)
			jeans_economy_save(customer:get_player_name(), owner, meta:get_int("usershop:price"), customer:get_player_name().." buys "..item_count.." "..item_name.." at the usershop from "..owner..".")

		-- SELL:
		else
			local item_name = "Nothing"
			local item_count = 1
      for i, item in pairs(items) do
        minv:add_item("main",item)
        pinv:remove_item("main", item)
				item_name = item:get_name()
				item_count = item:get_count()
      end

     jeans_economy_change_account(customer:get_player_name(), meta:get_int("usershop:price"))
		 jeans_economy_change_account(owner, - meta:get_int("usershop:price"))

			usershop_show_spec_atm(customer)
			meta:set_int("usershop:counter", meta:get_int("usershop:counter") + 1)
      jeans_economy_save(owner, customer:get_player_name(), meta:get_int("usershop:price"), customer:get_player_name().." sells "..item_count.." "..item_name.." at the usershop from "..owner..".")
		end
  end
end)


-- ======= 5 =======
-- Wenn der Spieler auf Exchange gedrückt hat:
minetest.register_on_player_receive_fields(function(customer, formname, fields)
	
  -- BUY / SELL 5
  if formname == "usershop:usershop_atm" and fields.buy_sell_5 ~= nil and fields.buy_sell_5 ~= "" then
    local pos = default.usershop_current_atm_shop_position[customer:get_player_name()]
    local meta = minetest.get_meta(pos)
    local minv = meta:get_inventory()
    local pinv = customer:get_inventory()
    local items = minv:get_list("itemfield")
    local owner = meta:get_string("owner")
    local playername = customer:get_player_name()
    local cI = 0

    if items == nil then return end -- do not crash the server

  -- MONEY:
	-- Customer: Enough Money???

	if meta:get_string("usershop:bs_5") == "Buy" and jeans_economy.get_account(playername) < meta:get_int("usershop:price_5") then
		minetest.chat_send_player(customer:get_player_name(),"You dont have enough money on your account!" )
		return
  end

  -- Owner: Enough Money???

  if meta:get_string("usershop:bs_5") == "Sell" and jeans_economy.get_account(meta:get_string("owner")) < meta:get_int("usershop:price_5") then
    minetest.chat_send_player(customer:get_player_name(),"The Owner hansn't enough money to pay you out! Contact the owner for that." )
    return
  end

	-- Buy / Sell Process: --------------------------------------------------------------
		-- BUY:
		if meta:get_string("usershop:bs_5") == "Buy" then
			local item_name = "Nothing"
			local item_count = 5

      local aI = 0
      while( aI < 5 ) do
          for i, item in pairs(items) do
        
            if  meta:get_string("usershop:bs_5") == "Buy" and not minv:contains_item("main", item)  then -- Prüfe ob im Shop genügend Blöcke vorhanden sind.
              minetest.chat_send_player(customer:get_player_name(),"The shop is empty and you only received a quantity of "..cI.."! The owner has been contacted automatically." )
              if mail_boolean then -- Sende eine Nachricht an den Inhaber des Shops raus
                mail.send("Usershop", owner, "Usershop Empty! ("..minetest.pos_to_string(pos)..")", "Dear " .. owner .. ", your usershop at " .. minetest.pos_to_string(pos) .. " with " .. item:get_name() .. " is empty! \nPlease refill your shop soon!")
              end
              aI = aI + 5
            elseif not pinv:room_for_item("main", item)  then -- Prüfe ob genügend Platz im Inventar des Verkäufers ist.
              minetest.chat_send_player(customer:get_player_name(),"You didn't have enough space in the inventory. Therefore you only received a number of  "..cI.."" )
              aI = aI + 5 
            else
				    pinv:add_item("main",item)
            minv:remove_item("main", item)
				    item_name = item:get_name()
				    item_count = item:get_count()
            aI = aI + 1
            cI = cI + 1
            end
        end 
      end
    
    jeans_economy_change_account(customer:get_player_name(), - meta:get_int("usershop:price")*cI)
		jeans_economy_change_account(owner, meta:get_int("usershop:price")*cI)

			usershop_show_spec_atm(customer)
			meta:set_int("usershop:counter", meta:get_int("usershop:counter") + cI)
			jeans_economy_save(customer:get_player_name(), owner, meta:get_int("usershop:price")*cI, customer:get_player_name().." buys "..item_count.." "..item_name.." at the usershop from "..owner..".")

		-- SELL:
		else
			local item_name = "Nothing"
			local item_count = 5

      local bI = 0
      while( bI < 5) do
        for i, item in pairs(items) do
          if meta:get_string("usershop:bs_5") == "Sell" and not pinv:contains_item("main", item)  then -- Prüfe ob der Verkäufer genügend Items hat.
            minetest.chat_send_player(customer:get_player_name(),"Only a quantity of "..cI.." was sold, as you did not have more!" )
            bI = bI + 5

          elseif meta:get_string("usershop:bs_5") == "Sell" and not minv:room_for_item("main", item)  then -- Prüfe ob der Shop voll ist.
            minetest.chat_send_player(customer:get_player_name(),"The shop is full! Please contact the owner for that." )
            if mail_boolean then -- Sende eine Nachricht an den Inhaber des Shops raus
              mail.send("Usershop", owner, "Usershop Empty! ("..minetest.pos_to_string(pos)..")", "Dear " .. owner .. ", your usershop at " .. minetest.pos_to_string(pos) .. " with " .. item:get_name() .. " is full!")
            end
            bI = bI + 5
          else

          minv:add_item("main",item)
          pinv:remove_item("main", item)
				  item_name = item:get_name()
				  item_count = item:get_count()
          bI = bI + 1
          cI = cI + 1
        end
      end
    end

     jeans_economy_change_account(customer:get_player_name(), meta:get_int("usershop:price")*cI)
		 jeans_economy_change_account(owner, - meta:get_int("usershop:price")*cI)

			usershop_show_spec_atm(customer)
			meta:set_int("usershop:counter", meta:get_int("usershop:counter") + cI)
      jeans_economy_save(owner, customer:get_player_name(), meta:get_int("usershop:price")*cI, customer:get_player_name().." sells "..item_count.." "..item_name.." at the usershop from "..owner..".")
		end
  end
end)

-- ======= 10 =======
-- Wenn der Spieler auf Exchange gedrückt hat:
minetest.register_on_player_receive_fields(function(customer, formname, fields)
	
  -- BUY / SELL 10
  if formname == "usershop:usershop_atm" and fields.buy_sell_10 ~= nil and fields.buy_sell_10 ~= "" then
    local pos = default.usershop_current_atm_shop_position[customer:get_player_name()]
    local meta = minetest.get_meta(pos)
    local minv = meta:get_inventory()
    local pinv = customer:get_inventory()
    local items = minv:get_list("itemfield")
    local owner = meta:get_string("owner")
    local playername = customer:get_player_name()
    local cI = 0

    if items == nil then return end -- do not crash the server

  -- MONEY:
	-- Customer: Enough Money???

	if meta:get_string("usershop:bs_10") == "Buy" and jeans_economy.get_account(playername) < meta:get_int("usershop:price_10") then
		minetest.chat_send_player(customer:get_player_name(),"You dont have enough money on your account!" )
		return
  end

  -- Owner: Enough Money???

  if meta:get_string("usershop:bs_10") == "Sell" and jeans_economy.get_account(meta:get_string("owner")) < meta:get_int("usershop:price_10") then
    minetest.chat_send_player(customer:get_player_name(),"The Owner hansn't enough money to pay you out! Contact the owner for that." )
    return
  end

	-- Buy / Sell Process: --------------------------------------------------------------
		-- BUY:
		if meta:get_string("usershop:bs_10") == "Buy" then
			local item_name = "Nothing"
			local item_count = 10

      local aI = 0
      while( aI < 10 ) do
          for i, item in pairs(items) do
        
            if  meta:get_string("usershop:bs_10") == "Buy" and not minv:contains_item("main", item)  then -- Prüfe ob im Shop genügend Blöcke vorhanden sind.
              minetest.chat_send_player(customer:get_player_name(),"The shop is empty and you only received a quantity of "..cI.."! The owner has been contacted automatically." )
              if mail_boolean then -- Sende eine Nachricht an den Inhaber des Shops raus
               -- minetest.chat_send_all("mail_boolean = true")
                mail.send("Usershop", owner, "Usershop Empty! ("..minetest.pos_to_string(pos)..")", "Dear " .. owner .. ", your usershop at " .. minetest.pos_to_string(pos) .. " with " .. item:get_name() .. " is empty! \nPlease refill your shop soon!")
              end
              aI = aI + 10
            elseif not pinv:room_for_item("main", item)  then -- Prüfe ob genügend Platz im Inventar des Verkäufers ist.
              minetest.chat_send_player(customer:get_player_name(),"You didn't have enough space in the inventory. Therefore you only received a number of  "..cI.."" )
              aI = aI + 10
            else
				    pinv:add_item("main",item)
            minv:remove_item("main", item)
				    item_name = item:get_name()
				    item_count = item:get_count()
            aI = aI + 1
            cI = cI + 1
            end
        end 
      end
    
    jeans_economy_change_account(customer:get_player_name(), - meta:get_int("usershop:price")*cI)
		jeans_economy_change_account(owner, meta:get_int("usershop:price")*cI)

			usershop_show_spec_atm(customer)
			meta:set_int("usershop:counter", meta:get_int("usershop:counter") + cI)
			jeans_economy_save(customer:get_player_name(), owner, meta:get_int("usershop:price")*cI, customer:get_player_name().." buys "..item_count.." "..item_name.." at the usershop from "..owner..".")

		-- SELL:
		else
			local item_name = "Nothing"
			local item_count = 10

      local bI = 0
      while( bI < 10) do
        for i, item in pairs(items) do
          if meta:get_string("usershop:bs_5") == "Sell" and not pinv:contains_item("main", item)  then -- Prüfe ob der Verkäufer genügend Items hat.
            minetest.chat_send_player(customer:get_player_name(),"Only a quantity of "..cI.." was sold, as you did not have more!" )
            bI = bI + 10

          elseif meta:get_string("usershop:bs_5") == "Sell" and not minv:room_for_item("main", item)  then -- Prüfe ob der Shop voll ist.
            minetest.chat_send_player(customer:get_player_name(),"The shop is full! Please contact the owner for that." )
            if mail_boolean then -- Sende eine Nachricht an den Inhaber des Shops raus
             -- minetest.chat_send_all("mail_boolean = true")
              mail.send("Usershop", owner, "Usershop Empty! ("..minetest.pos_to_string(pos)..")", "Dear " .. owner .. ", your usershop at " .. minetest.pos_to_string(pos) .. " with " .. item:get_name() .. " is full!")
            end
            bI = bI + 10
          else

          minv:add_item("main",item)
          pinv:remove_item("main", item)
				  item_name = item:get_name()
				  item_count = item:get_count()
          bI = bI + 1
          cI = cI + 1
        end
      end
    end

     jeans_economy_change_account(customer:get_player_name(), meta:get_int("usershop:price")*cI)
		 jeans_economy_change_account(owner, - meta:get_int("usershop:price")*cI)

			usershop_show_spec_atm(customer)
			meta:set_int("usershop:counter", meta:get_int("usershop:counter") + cI)
      jeans_economy_save(owner, customer:get_player_name(), meta:get_int("usershop:price")*cI, customer:get_player_name().." sells "..item_count.." "..item_name.." at the usershop from "..owner..".")
		end
  end
end)

-- ======= 99 =======
-- Wenn der Spieler auf Exchange gedrückt hat:
minetest.register_on_player_receive_fields(function(customer, formname, fields)
	
  -- BUY / SELL 99
  if formname == "usershop:usershop_atm" and fields.buy_sell_99 ~= nil and fields.buy_sell_99 ~= "" then
    local pos = default.usershop_current_atm_shop_position[customer:get_player_name()]
    local meta = minetest.get_meta(pos)
    local minv = meta:get_inventory()
    local pinv = customer:get_inventory()
    local items = minv:get_list("itemfield")
    local owner = meta:get_string("owner")
    local playername = customer:get_player_name()
    local cI = 0

    if items == nil then return end -- do not crash the server

  -- MONEY:
	-- Customer: Enough Money???

	if meta:get_string("usershop:bs_99") == "Buy" and jeans_economy.get_account(playername) < meta:get_int("usershop:price_99") then
		minetest.chat_send_player(customer:get_player_name(),"You dont have enough money on your account!" )
		return
  end

  -- Owner: Enough Money???

  if meta:get_string("usershop:bs_99") == "Sell" and jeans_economy.get_account(meta:get_string("owner")) < meta:get_int("usershop:price_99") then
    minetest.chat_send_player(customer:get_player_name(),"The Owner hansn't enough money to pay you out! Contact the owner for that." )
    return
  end

	-- Buy / Sell Process: --------------------------------------------------------------
		-- BUY:
		if meta:get_string("usershop:bs_99") == "Buy" then
			local item_name = "Nothing"
			local item_count = 99

      local aI = 0
      while( aI < 99 ) do
          for i, item in pairs(items) do
        
            if  meta:get_string("usershop:bs_99") == "Buy" and not minv:contains_item("main", item)  then -- Prüfe ob im Shop genügend Blöcke vorhanden sind.
              minetest.chat_send_player(customer:get_player_name(),"The shop is empty and you only received a quantity of "..cI.."! The owner has been contacted automatically." )
              if mail_boolean then -- Sende eine Nachricht an den Inhaber des Shops raus
               -- minetest.chat_send_all("mail_boolean = true")
                mail.send("Usershop", owner, "Usershop Empty! ("..minetest.pos_to_string(pos)..")", "Dear " .. owner .. ", your usershop at " .. minetest.pos_to_string(pos) .. " with " .. item:get_name() .. " is empty! \nPlease refill your shop soon!")
              end
              aI = aI + 99
            elseif not pinv:room_for_item("main", item)  then -- Prüfe ob genügend Platz im Inventar des Verkäufers ist.
              minetest.chat_send_player(customer:get_player_name(),"You didn't have enough space in the inventory. Therefore you only received a number of  "..cI.."" )
              aI = aI + 99
            else
				    pinv:add_item("main",item)
            minv:remove_item("main", item)
				    item_name = item:get_name()
				    item_count = item:get_count()
            aI = aI + 1
            cI = cI + 1
            end
        end 
      end
    
    jeans_economy_change_account(customer:get_player_name(), - meta:get_int("usershop:price")*cI)
		jeans_economy_change_account(owner, meta:get_int("usershop:price")*cI)

			usershop_show_spec_atm(customer)
			meta:set_int("usershop:counter", meta:get_int("usershop:counter") + cI)
			jeans_economy_save(customer:get_player_name(), owner, meta:get_int("usershop:price")*cI, customer:get_player_name().." buys "..item_count.." "..item_name.." at the usershop from "..owner..".")

		-- SELL:
		else
			local item_name = "Nothing"
			local item_count = 99

      local bI = 0
      while( bI < 99) do
        for i, item in pairs(items) do
          if meta:get_string("usershop:bs_5") == "Sell" and not pinv:contains_item("main", item)  then -- Prüfe ob der Verkäufer genügend Items hat.
            minetest.chat_send_player(customer:get_player_name(),"Only a quantity of "..cI.." was sold, as you did not have more!" )
            bI = bI + 99

          elseif meta:get_string("usershop:bs_5") == "Sell" and not minv:room_for_item("main", item)  then -- Prüfe ob der Shop voll ist.
            minetest.chat_send_player(customer:get_player_name(),"The shop is full! Please contact the owner for that." )
            if mail_boolean then -- Sende eine Nachricht an den Inhaber des Shops raus
             -- minetest.chat_send_all("mail_boolean = true")
              mail.send("Usershop", owner, "Usershop Empty! ("..minetest.pos_to_string(pos)..")", "Dear " .. owner .. ", your usershop at " .. minetest.pos_to_string(pos) .. " with " .. item:get_name() .. " is full!")
            end
            bI = bI + 99
          else

          minv:add_item("main",item)
          pinv:remove_item("main", item)
				  item_name = item:get_name()
				  item_count = item:get_count()
          bI = bI + 1
          cI = cI + 1
        end
      end
    end

     jeans_economy_change_account(customer:get_player_name(), meta:get_int("usershop:price")*cI)
		 jeans_economy_change_account(owner, - meta:get_int("usershop:price")*cI)

			usershop_show_spec_atm(customer)
			meta:set_int("usershop:counter", meta:get_int("usershop:counter") + cI)
      jeans_economy_save(owner, customer:get_player_name(), meta:get_int("usershop:price")*cI, customer:get_player_name().." sells "..item_count.." "..item_name.." at the usershop from "..owner..".")
		end
  end
end)

----
----
----

-- Set Buy / Sell
minetest.register_on_player_receive_fields(function(customer, formname, fields)
	if formname == "usershop:usershop_atm" and fields.set_buy_sell ~= nil and fields.set_buy_sell ~= "" then
		local pos = default.usershop_current_atm_shop_position[customer:get_player_name()]
		local meta = minetest.get_meta(pos)
		if meta:get_string("usershop:bs") == "Buy" then
			meta:set_string("usershop:bs", "Sell")
      meta:set_string("usershop:bs_5", "Sell")
      meta:set_string("usershop:bs_10", "Sell")
      meta:set_string("usershop:bs_99", "Sell")
    else
			meta:set_string("usershop:bs", "Buy")
      meta:set_string("usershop:bs_5", "Buy")
      meta:set_string("usershop:bs_10", "Buy")
      meta:set_string("usershop:bs_99", "Buy")
		end

		usershop_show_spec_atm(customer)
	end
end)

-- Set Price
minetest.register_on_player_receive_fields(function(customer, formname, fields)
	if formname == "usershop:usershop_atm" and fields.set_price ~= nil and fields.set_price ~= "" then
		local pos = default.usershop_current_atm_shop_position[customer:get_player_name()]
		local meta = minetest.get_meta(pos)
		if tonumber(fields.price_field) ~= nil then
			meta:set_int("usershop:price", fields.price_field)
      meta:set_int("usershop:price_5", fields.price_field*5)
      meta:set_int("usershop:price_10", fields.price_field*10)
      meta:set_int("usershop:price_99", fields.price_field*99)
		end;
		usershop_show_spec_atm(customer)
	end
end)
