-- Returns quantity of buyed items, else 0
function jeans_shopsystems.buy(player, item, quantity, price_per_item)
  local player_name = player:get_player_name()
  local pinv = player:get_inventory()

  if not item:set_count(quantity) then
    minetest.chat_send_player(player_name, "Please take a lower number!")
    return 0
  end

  if not pinv:room_for_item("main", item) then
    minetest.chat_send_player(player_name, "You don't have enough space in your inventory!")
    return 0
  end

  if jeans_economy.book(player_name, "!SERVER!", jeans_shopsystems.calculate_price(price_per_item, quantity), player_name.. " buys "..quantity.." "..item:get_name().." at the adminshop" ) ~= true then
    minetest.chat_send_player(player_name, "You don't have enough money!")
    return 0
  end

  pinv:add_item("main", item)
  return quantity
end

-- Returns quantity of buyed items, else 0
function jeans_shopsystems.buy_fill_inventory(player, item, price_per_item)
  local player_name = player:get_player_name()
  local pinv = player:get_inventory()
  local returnvalue = 0
  local quantity = -1
  if not pinv:room_for_item("main", item) then
    minetest.chat_send_player(player_name, "You don't have enough space in your inventory!")
    return 0
  end
  while returnvalue == 0 do
    returnvalue = pinv:add_item("main", item):get_count()
    quantity = quantity + 1
  end



  if not jeans_economy.book(player_name, "!SERVER!", jeans_shopsystems.calculate_price(price_per_item, quantity), player_name.. " buys "..quantity.." "..item:get_name().." at the adminshop" ) then
    item:set_count(quantity)
    pinv:remove_item("main", item)
    minetest.chat_send_player(player_name, "You don't have enough money! It costs "..jeans_shopsystems.calculate_price(price_per_item, quantity))
    return 0
  end
  minetest.chat_send_player(player_name, "Successfully buyed "..quantity.." items for "..jeans_shopsystems.calculate_price(price_per_item, quantity))
  return quantity
end

-- Returns quantity of sold items, else 0
function  jeans_shopsystems.sell(player, item, quantity, sell_price_per_item)
  local player_name = player:get_player_name()
  local pinv = player:get_inventory()

  item:set_count(quantity)
  print("Huhu")
  if not pinv:contains_item("main", item) then
    minetest.chat_send_player(player_name, "You dont have the required items in your inventory!")
    return 0
  end

  jeans_economy.book("!SERVER!", player_name, jeans_shopsystems.calculate_price(sell_price_per_item, quantity), player_name.. " sells "..quantity.." "..item:get_name().." at the adminshop" )

  pinv:remove_item("main", item)
  return quantity
end

-- Returns quantity of sold items, else 0
function jeans_shopsystems.empty_inventory(player, item, sell_price_per_item)
  local player_name = player:get_player_name()
  local pinv = player:get_inventory()
  local quantity = 0

  if not pinv:contains_item("main", item) then
    minetest.chat_send_player(player_name, "You dont have the required items in your inventory!")
    return 0
  end

  while pinv:contains_item("main", item) do
    quantity = quantity + 1
    pinv:remove_item("main", item)
  end

  jeans_economy.book("!SERVER!", player_name, jeans_shopsystems.calculate_price(sell_price_per_item, quantity), player_name.. " sells "..quantity.." "..item:get_name().." at the adminshop" )
  minetest.chat_send_player(player_name, "Successfully selled "..quantity.." items. You got "..jeans_shopsystems.calculate_price(sell_price_per_item, quantity))
  return quantity
end

function jeans_shopsystems.calculate_price(price, quantity)
  local returnvalue = math.floor(price*quantity)
  if returnvalue < 1 then
    return 1
  else
    return returnvalue
  end
end

function jeans_shopsystems.check_licenses(player_name, licenses_table)
  for k, v in pairs(licenses_table) do
    if not licenses.check(player_name, k) then
      return false
    end
  end
  return true
end
