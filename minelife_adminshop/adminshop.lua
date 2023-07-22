minetest.register_node("jeans_shopsystems:adminshop_sign", {
    description = "Adminshop",
  
    tiles = {"adminshop.png"},
    --[[
    tiles = {"adminshop_top.png",
				"adminshop_top.png",
        "adminshop.png",
				"adminshop.png",
				"adminshop.png",
				"adminshop.png",},
    --]]
    node_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, 7/16, 0.5, 0.5, 0.5}
    },     
    selection_box = {
      type = "fixed",
      fixed = {-0.5, -0.5, 7/16, 0.5, 0.5, 0.5}
    },   
    paramtype = "light",
    paramtype2="facedir",
    drawtype = "nodebox",


    groups = {dig_immediate=2},
    sounds = default.node_sound_stone_defaults(),
    after_place_node = function(pos, placer, itemstack)
      local meta = minetest.get_meta(pos)
      meta:set_int("jeans_shopsystems:buyed", 0)
      meta:set_int("jeans_shopsystems:sold", 0)
      meta:set_float("jeans_shopsystems:buy_price", -1)
      meta:set_float("jeans_shopsystems:sell_price", -1)
      local licenses_table = {}
      meta:set_string("adminshop:ltable", minetest.serialize(licenses_table))
      local inv = meta:get_inventory()
      inv:set_size("item", 1)
    end,
    can_dig = function(pos, player)
      return jeans_shopsystems.check_priv(player:get_player_name())
    end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
      if not jeans_shopsystems.check_priv(player:get_player_name()) then return 0 end
	      return stack:get_count()
    end,
		allow_metadata_inventory_take = function(pos, listname, index, stack, player)
      if not jeans_shopsystems.check_priv(player:get_player_name()) then return 0 end
        return stack:get_count()
    end,
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
      jeans_shopsystems.player_positions[player:get_player_name()] = pos
      jeans_shopsystems.show_adminshop(pos, player)
    end,
    drop = {
        items = {
            -- assume that mod:cobblestone also has the same palette
            {items = {}},
        }
    }
})

minetest.register_node("jeans_shopsystems:adminshop", {
  description = "Adminshop",
  tiles = {"adminshop_top.png",
      "adminshop_top.png",
      "adminshop.png",
      "adminshop.png",
      "adminshop.png",
      "adminshop.png",},
  groups = {dig_immediate=2},
  sounds = default.node_sound_stone_defaults(),
  after_place_node = function(pos, placer, itemstack)
    local meta = minetest.get_meta(pos)
    meta:set_int("jeans_shopsystems:buyed", 0)
    meta:set_int("jeans_shopsystems:sold", 0)
    meta:set_float("jeans_shopsystems:buy_price", -1)
    meta:set_float("jeans_shopsystems:sell_price", -1)
    local licenses_table = {}
    meta:set_string("adminshop:ltable", minetest.serialize(licenses_table))
    local inv = meta:get_inventory()
    inv:set_size("item", 1)
  end,
  can_dig = function(pos, player)
    return jeans_shopsystems.check_priv(player:get_player_name())
  end,
  allow_metadata_inventory_put = function(pos, listname, index, stack, player)
    if not jeans_shopsystems.check_priv(player:get_player_name()) then return 0 end
      return stack:get_count()
  end,
  allow_metadata_inventory_take = function(pos, listname, index, stack, player)
    if not jeans_shopsystems.check_priv(player:get_player_name()) then return 0 end
      return stack:get_count()
  end,
  on_rightclick = function(pos, node, player, itemstack, pointed_thing)
    jeans_shopsystems.player_positions[player:get_player_name()] = pos
    jeans_shopsystems.show_adminshop(pos, player)
  end,
  drop = {
      items = {
          -- assume that mod:cobblestone also has the same palette
          {items = {}},
      }
  }
})





function jeans_shopsystems.show_adminshop(pos, player)
  local meta = minetest.get_meta(pos)
  local player_name = player:get_player_name()
  -- Prepare Licenses Table
  local licenses_string = " "
  local licenses_table = minetest.deserialize(meta:get_string("adminshop:ltable"))
  if licenses_table ~= nil then
    for k, v in pairs(licenses_table) do
      licenses_string = licenses_string .. v .. ", "
    end
  end
  local listname = "nodemeta:"..pos.x..','..pos.y..','..pos.z
  local buy_price = meta:get_float("jeans_shopsystems:buy_price")
  local sell_price = meta:get_float("jeans_shopsystems:sell_price")
  if jeans_shopsystems.check_priv(player_name) then -- NOT WEGSTREICHEN!!!
    -- Admin View:
    minetest.show_formspec(player_name, "jeans_shopsystems:adminshop_admin", "size[11,7.5]"..
      "label[0,0;Welcome, "..player_name.."]" ..
      "label[0,0.25;Buyed: "..meta:get_int("jeans_shopsystems:buyed").."]" ..
      "label[0,0.5;Sold: "..meta:get_int("jeans_shopsystems:sold").."]" ..

      -- Licenses:
      "label[8,0;Licenses:]" ..
      "textlist[8,0.5;2.8,5;license_list;"..licenses_string.."]" ..
      "button[8,5.5;1.5,1;add_license;Add]" ..
      "button[9.5,5.5;1.5,1;remove_license;Remove]" ..
      "field[8.3,6.7;3,1;license_text;;]" ..
      -------------
      "label[3.68,0.5;Item:]" ..
      "list["..listname..";item;3.5,1;1,1;]"..
      "field[0.3,2.5;3,1;buy_price;price for buying;"..buy_price.."]" ..
      "field[5.3,2.5;3,1;sell_price;price for selling;"..sell_price.."]" ..
      "button[3,2.2;2,1;save;Save]" ..
      "list[current_player;main;0,3.5;8,4;]")
  else
    -- Customer View:
    local formspec_string =  "size[10,8]"..
      "label[0,0;Welcome, "..player_name.."]" ..
      "label[0,0.5;Your ballance: "..jeans_economy.get_account(player_name).."]" ..
      "label[4.68,0;Item:]" ..
      "list["..listname..";item;4.5,0.5;1,1;]" ..
      "list[current_player;main;1,4;8,4;]"
    if buy_price >= 0 then
       formspec_string = formspec_string .. "button[0,1.5;2,1;buy_1;Buy 1 ("..jeans_shopsystems.calculate_price(buy_price, 1)..")]" ..
       "button[2,1.5;2,1;buy_5;Buy 5 ("..jeans_shopsystems.calculate_price(buy_price, 5)..")]" ..
       "button[4,1.5;2,1;buy_10;Buy 10 ("..jeans_shopsystems.calculate_price(buy_price, 10)..")]" ..
       "button[6,1.5;2,1;buy_99;Buy 99 ("..jeans_shopsystems.calculate_price(buy_price, 99)..")]" ..
       "button[8,1.5;2,1;buy_all;Fill Inventory (!)]"
     end
     if sell_price >= 0 then
       formspec_string = formspec_string ..   "button[0,2.5;2,1;sell_1;Sell 1 ("..jeans_shopsystems.calculate_price(sell_price, 1)..")]" ..
         "button[2,2.5;2,1;sell_5;Sell 5 ("..jeans_shopsystems.calculate_price(sell_price, 5)..")]" ..
         "button[4,2.5;2,1;sell_10;Sell 10 ("..jeans_shopsystems.calculate_price(sell_price, 10)..")]" ..
         "button[6,2.5;2,1;sell_99;Sell 99 ("..jeans_shopsystems.calculate_price(sell_price, 99)..")]" ..
         "button[8,2.5;2,1;sell_all;Sell All (!)]"
     end
     if licenses_string ~= " " then
       formspec_string = formspec_string .. "label[0,1;Licenses required:"..licenses_string.."]"
     end

    minetest.show_formspec(player_name, "jeans_shopsystems:adminshop_customer", formspec_string)
  end
end




--------------------------------------------------------------------------------
-- Admin Functions:
--------------------------------------------------------------------------------
-- Item field:
minetest.register_on_player_receive_fields(function(player, formname, fields)
  if player == nil or formname == nil or fields == nil then
    return
  else
     jeans_shopsystems.save_fields_adminshop(player, formname, fields)
  end   
end)


function jeans_shopsystems.save_fields_adminshop(player, formname, fields)
  -- Save Prices
	if formname == "jeans_shopsystems:adminshop_admin" and fields.save ~= nil and fields.save ~= "" then
    local player_name = player:get_player_name()
    local pos = jeans_shopsystems.player_positions[player_name]
    local meta = minetest.get_meta(pos)
    meta:set_float("jeans_shopsystems:sell_price", tonumber(fields.sell_price))
    meta:set_float("jeans_shopsystems:buy_price", tonumber(fields.buy_price))
    jeans_shopsystems.show_adminshop(pos, player)
	end
	minetest.close_formspec(player:get_player_name(), "formspecname")
  -- Correct Item-Field
  local player_name = player:get_player_name()
  local pos = jeans_shopsystems.player_positions[player_name]
  if pos == nil then return end
  local meta = minetest.get_meta(pos)
  local minv = meta:get_inventory()
  local pinv = player:get_inventory()
  local item = minv:get_list("item")[1]
  if (item:get_count() > 1) then
    item:set_count(item:get_count() -1)
    pinv:add_item("main",item)
    minv:remove_item("item",item)
    minetest.chat_send_player(player_name, "Adminshop is only accepting one item!")
   end
  -- for i, item in pairs(item_array) do
  --   minetest.chat_send_player(player_name, i.." "..item:get_count())
  -- end
end


-- Add License
minetest.register_on_player_receive_fields(function(player, formname, fields)
  local player_name = player:get_player_name()
  if formname == "jeans_shopsystems:adminshop_admin" and fields.add_license ~= nil and fields.add_license ~= "" and fields.license_text ~= "" then
    if jeans_shopsystems.licenses_activated then
      local pos = jeans_shopsystems.player_positions[player_name]
      local meta = minetest.get_meta(pos)
      local licenses_table = minetest.deserialize(meta:get_string("adminshop:ltable")) or {}
      -- Checke, ob das wirklich existiert
      if licenses.exists(fields.license_text) then
        licenses_table[fields.license_text] = fields.license_text
        meta:set_string("adminshop:ltable", minetest.serialize(licenses_table))
        jeans_shopsystems.show_adminshop(pos, player)
      else
        minetest.chat_send_player(player_name,"This license doesn't exist! Add this with /licenses add " .. fields.license_text )
      end

      else
        minetest.chat_send_player(player_name, "Mod jeans_licenses not found! Function deactivated")
      end
    end
end)

-- Remove License
minetest.register_on_player_receive_fields(function(player, formname, fields)
  local player_name = player:get_player_name()
  if formname == "jeans_shopsystems:adminshop_admin" and fields.remove_license ~= nil and fields.remove_license ~= "" and fields.license_text ~= "" then
    if jeans_shopsystems.licenses_activated then
    	local pos = jeans_shopsystems.player_positions[player_name]
    	local meta = minetest.get_meta(pos)
    	local ltable = minetest.deserialize(meta:get_string("adminshop:ltable")) or {}
    	ltable[fields.license_text] = nil
    	meta:set_string("adminshop:ltable", minetest.serialize(ltable))
    	jeans_shopsystems.show_adminshop(pos, player)
    else
      minetest.chat_send_player(player_name, "Mod jeans_licenses not found! Function deactivated")
    end
 end
end)


--------------------------------------------------------------------------------
-- Customer Functions:
--------------------------------------------------------------------------------
-- Buy/Sell:
local playerSellTimes = {}
minetest.register_on_player_receive_fields(function(player, formname, fields)
  local player_name = player:get_player_name()
  if formname ~= "jeans_shopsystems:adminshop_customer" then
    return
  end

  local pos = jeans_shopsystems.player_positions[player_name]
  local meta = minetest.get_meta(pos)
  local minv = meta:get_inventory()
  local item = minv:get_list("item")[1]
  local buy_price = meta:get_float("jeans_shopsystems:buy_price")
  local sell_price = meta:get_float("jeans_shopsystems:sell_price")
  local licenses_table = minetest.deserialize(meta:get_string("adminshop:ltable"))

  local quantity = -1
  if fields.buy_1 ~= nil and fields.buy_1 ~= "" then
    quantity = 1
  elseif fields.buy_5 ~= nil and fields.buy_5 ~= "" then
    quantity = 5
  elseif fields.buy_10 ~= nil and fields.buy_10 ~= "" then
    quantity = 10
  elseif fields.buy_99 ~= nil and fields.buy_99 ~= "" then
    quantity = 99
  elseif fields.buy_all ~= nil and fields.buy_all ~= "" then
    quantity = -2
  end

  if quantity >= 0 then
    if not jeans_shopsystems.check_licenses(player_name, licenses_table) then
      minetest.chat_send_player(player_name, "You dont have the required licenses!")
      return
    end
    local buyedItems = jeans_shopsystems.buy(player, item, quantity, buy_price)
    meta:set_int("jeans_shopsystems:buyed", meta:get_int("jeans_shopsystems:buyed") + buyedItems)
    jeans_shopsystems.show_adminshop(pos, player)
    return
  end
  if quantity == -2 then
    if not jeans_shopsystems.check_licenses(player_name, licenses_table) then
      minetest.chat_send_player(player_name, "You dont have the required licenses!")
      return
    end
    local buyedItems = jeans_shopsystems.buy_fill_inventory(player, item, buy_price)
    meta:set_int("jeans_shopsystems:buyed", meta:get_int("jeans_shopsystems:buyed") + buyedItems)
    jeans_shopsystems.show_adminshop(pos, player)
    return
  end

-- SELL:

  local quantity = -1
  if fields.sell_1 ~= nil and fields.sell_1 ~= "" then
    quantity = 1
  elseif fields.sell_5 ~= nil and fields.sell_5 ~= "" then
    quantity = 5
  elseif fields.sell_10 ~= nil and fields.sell_10 ~= "" then
    print("Huhu2")
    quantity = 10
  elseif fields.sell_99 ~= nil and fields.sell_99 ~= "" then
    quantity = 99
  elseif fields.sell_all ~= nil and fields.sell_all ~= "" then
    quantity = -2
  end

  -- allow that the player can sell just every 5 Seconds
  if quantity >= 0 then
    local gametime = minetest.get_gametime()
    if (playerSellTimes[player_name] ~= nil) then
      if gametime - playerSellTimes[player_name] < 5 then
        minetest.chat_send_player(player_name, "You can only sell every 5 seconds!")
        return
      end
    end
    playerSellTimes[player_name] = gametime
    if not jeans_shopsystems.check_licenses(player_name, licenses_table) then
      minetest.chat_send_player(player_name, "You dont have the required licenses!")
      return
    end
    local soldItems = jeans_shopsystems.sell(player, item, quantity, sell_price)
    meta:set_int("jeans_shopsystems:sold", meta:get_int("jeans_shopsystems:sold") + soldItems)
    jeans_shopsystems.show_adminshop(pos, player)
    return
  end
  if quantity == -2 then
    if not jeans_shopsystems.check_licenses(player_name, licenses_table) then
      minetest.chat_send_player(player_name, "You dont have the required licenses!")
      return
    end
    local soldItems = jeans_shopsystems.empty_inventory(player, item, sell_price)
    meta:set_int("jeans_shopsystems:sold", meta:get_int("jeans_shopsystems:sold") + soldItems)
    jeans_shopsystems.show_adminshop(pos, player)
    return
  end


end)
