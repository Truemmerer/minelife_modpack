----------------------------------------------------------------------------
-- Area Sell/Rent Block
----------------------------------------------------------------------------
default.areas_pay_pos = {}


minetest.register_node("areas_pay:more_areas_block", {

  description = "Buy more Area Slots",
  tiles = {"area_pay_top.png",
  "area_pay_top.png",
  "buy_more_plot_slots.png",
  "buy_more_plot_slots.png",
  "buy_more_plot_slots.png",
  "buy_more_plot_slots.png",},
  is_ground_content = true,
  groups = {dig_immediate=2},
  sounds = default.node_sound_wood_defaults(),
  light_source = 8,

  on_construct = function(pos)
    local meta = minetest.get_meta(pos)
    meta:set_string("infotext", "Buy more Area Slots")
  end,

  on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
    minelife_areas_pay.areas_pay_more_slots(clicker)
  end,
  
})

--[[
minetest.register_craft({
  output = "areas_pay:shop_block_red",
	recipe = {
		{"", "", ""},
		{"group:dye", "group:wood", "group:dye"},
		{"default:mese_crystal_fragment", "default:mese_crystal_fragment", "default:mese_crystal_fragment"}
	}
})
--]]

for i, color in pairs( {"red", "green", "blue"}) do
  minetest.register_node("areas_pay:shop_block_"..color, {

      description = "Area Shop Block",
  		tiles = {"area_pay_top.png",
  				"area_pay_top.png",
  				"area_pay_front_"..color..".png",
          "area_pay_front_"..color..".png",
          "area_pay_front_"..color..".png",
          "area_pay_front_"..color..".png",},
      is_ground_content = true,
      groups = {dig_immediate=2},
      sounds = default.node_sound_wood_defaults(),
      light_source = 8,
  -- Registriere den Owner beim Platzieren:
      after_place_node = function(pos, placer, itemstack)
        local meta = minetest.get_meta(pos)
  			meta:set_string("areas_pay:rs", "Sell")
  			meta:set_int("areas_pay:price", 0)
        meta:set_int("areas_pay:area_id", 0)
        meta:set_int("areas_pay:period", 7)
        meta:set_string("areas_pay:status", "still to have")
        meta:set_string("owner", placer:get_player_name())
        meta:set_string("areas_pay:customer", "")
      end,
      on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        default.areas_pay_pos[player:get_player_name()] = pos
        areas_pay_update_information(player)
        local meta = minetest.get_meta(pos)
        -- Remove obsolete Blocks (If the owner of the block doesnt own the area anymore)
        if meta:get_string("owner") ~= player:get_player_name() and not areas:isAreaOwner(meta:get_int("areas_pay:area_id"), meta:get_string("owner")) and meta:get_int("areas_pay:area_id") ~= 0  then
          minetest.remove_node(pos);
          return
        end
        areas_pay_show_spec(player)
      end,
      can_dig = function(pos, player)
        local meta = minetest.get_meta(pos)
        if player:get_player_name() == meta:get_string("owner") then
          return true
        else
          return false
      end
    end


  })
end

areas_pay_update_information = function (customer)
  local pos = default.areas_pay_pos[customer:get_player_name()]
  local meta = minetest.get_meta(pos)
  local rents = minetest.deserialize(areas_pay.storage:get_string("rents"))
  local id = meta:get_int("areas_pay:area_id")
  if rents ~= nil and rents[id] ~= nil then
    if(rents[id].rented_to ~=  nil) then
    meta:set_string("areas_pay:customer", rents[id].customer)
    meta:set_string("areas_pay:status", "Rented for "..math.floor((rents[meta:get_int("areas_pay:area_id")].rented_to - minetest.get_gametime()) / (24*3600)) .." days by "..rents[id].customer.."." )
    end
  else
    meta:set_string("areas_pay:customer", "")
    meta:set_string("areas_pay:status", "still to have" )
  end
end

areas_pay_show_spec = function (player)
    local pos = default.areas_pay_pos[player:get_player_name()]
    local meta = minetest.get_meta(pos)
    local player_name = player:get_player_name()
    local listname = "nodemeta:"..pos.x..','..pos.y..','..pos.z
    local rents = minetest.deserialize(areas_pay.storage:get_string("rents"))
		if player:get_player_name() == meta:get_string("owner") then
		minetest.show_formspec(player:get_player_name(), "areas_pay_owner", "size[6.5,6.5]"..
     "label[0,0;Status: ".. meta:get_string("areas_pay:status").."]" ..
     "field[0.3,1.3;3,1;area_id_field;Areas ID:;"..meta:get_string("areas_pay:area_id").."]" ..
     "field[3.55,1.3;3.2,1;area_group;Group:;"..meta:get_string("areas_pay:group").."]" ..
		 "field[0.3,2.3;3,1;price_field;Price:;"..meta:get_string("areas_pay:price").."]" ..
     "field[3.55,2.3;3.2,1;period_field;Period in Days (Just for Rent):;"..meta:get_string("areas_pay:period").."]" ..
		 "button[0,3.3;6.5,1;save_fields_button;Save Fields]" ..
     "button[0,4.3;6.5,1;set_rent_sell_button;"..meta:get_string("areas_pay:rs").."]"..
     "label[0,5.3;When you set a group, a player can only rent/buy one area of the same]"..
     "label[0,5.55;group. (These groups are global)]"..
     "label[0,6;On Buy Mode the 'Period in Days' field is ignored.]"

   )
 elseif meta:get_string("areas_pay:rs") == "Sell" then -- For Buying
      minetest.show_formspec(player:get_player_name(), "areas_pay_customer", "size[8,1.7]"..
      "label[0,0;Welcome, "..player:get_player_name()..", the Area with the ID "..meta:get_string("areas_pay:area_id").." is for Sell.]" ..
      "label[0,0.5;Price: "..meta:get_string("areas_pay:price").."]" ..
      "button[5,1;3,1;buy_button;Buy Now]"
    )
  elseif meta:get_string("areas_pay:customer") == player_name then -- For the current customer in renting
    minetest.show_formspec(player:get_player_name(), "areas_pay_customer_rent", "size[8,1.7]"..
    "label[0,0;Welcome back, "..player:get_player_name()..", you are renting the area "..meta:get_string("areas_pay:area_id").." the next ".. math.floor((rents[meta:get_int("areas_pay:area_id")].rented_to - minetest.get_gametime()) / (24*3600)) .." Days.]" ..
    "label[0,0.5;Price: "..meta:get_string("areas_pay:price").."]" ..
    "label[1.5,0.5;Period: "..meta:get_string("areas_pay:period").." Days]" ..
    "button[5,1;3,1;rent_button;Increase Rent Length")
  elseif meta:get_string("areas_pay:status") == "still to have" then -- For other custumers
    minetest.show_formspec(player:get_player_name(), "areas_pay_customer_rent", "size[8,1.7]"..
    "label[0,0;Welcome, "..player:get_player_name()..", the area with the ID "..meta:get_string("areas_pay:area_id").." is open for rent.]" ..
    "label[0,0.5;Price: "..meta:get_string("areas_pay:price").."]" ..
    "label[1.5,0.5;Period: "..meta:get_string("areas_pay:period").." Days]" ..
    "button[5,1;3,1;rent_button;Rent Now]")
  else -- When the area is rented
    minetest.show_formspec(player:get_player_name(), "areas_pay_customer_rented", "size[8,0.7]"..
    "label[0,0;Welcome, "..player:get_player_name()..".  Unfortunately the area with the ID "..meta:get_string("areas_pay:area_id").." is rented.]" ..
    "label[0,0.5;Price: "..meta:get_string("areas_pay:price").."]")
  end
end

    --[[
    local pos = default.areas_pay_pos[customer:get_player_name()]
		local meta = minetest.get_meta(pos)
    if meta:get_int("areas_pay:area_id") == 0 then
      minetest.chat_send_player(customer:get_player_name(), "Shop unconfigured")
      minetest.close_formspec(customer:get_player_name(), "areas_pay_customer")
      return
    end
   -- if not areas_pay.handle_group_buy(customer:get_player_name(), meta:get_string("areas_pay:group"), meta:get_int("areas_pay:area_id")) then
   --   minetest.chat_send_player(customer:get_player_name(), "You already own such a area whithin this area group.")
   --   return
   if not areas_pay:pay_registry_check(customer:get_player_name(), meta:get_string("areas_pay:group")) then
    minetest.chat_send_player(customer:get_player_name(), "You already rented such a area whithin this area group.")
    return
  
  end

    -- Check if the customer has enough money, give him the area, and remove the block.
	  if jeans_economy_book(customer:get_player_name(), meta:get_string("owner"), meta:get_int("areas_pay:price"), customer:get_player_name().." buys the Area with the ID " .. meta:get_string("areas_pay:area_id").." from " .. meta:get_string("owner")) then
      minetest.chat_send_player(customer:get_player_name(), "Buyed successfully Area")
      areas_pay.change_owner(meta:get_string("owner"), meta:get_string("areas_pay:area_id").." "..customer:get_player_name() )
      minetest.remove_node(pos);
    else
      minetest.chat_send_player(customer:get_player_name(), "You dont have enough money, to buy this!")
    end
	end
  minetest.close_formspec(customer:get_player_name(), "areas_pay_customer")
end)

--]]


