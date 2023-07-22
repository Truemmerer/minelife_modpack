-- DEFINE On WHICH AXE THE MOD SHOULD DECIDE
local VARIABLE = "x"

-- DEFINE HERE COLORS
local wild_name = "MineLife World"
local colors ={}
colors[wild_name] = 0x888888 -- Gray
colors["Landkreis"] = 0x00FF00 -- Green
colors["Stadt"] = 0xFF0000 -- Red

-- DEFINE HERE UPDATE INTERVAL IN SECONDS:
local INTERVAL = 2

local hud = {}
local current_zone = {}
local old_zone = {}
local delta = 0

dofile(minetest.get_modpath(minetest.get_current_modname()) .. "/config.lua")
-- minetest.debug(dump(zone_data))
for _,value in pairs(zone_data) do
--	minetest.debug(value["name"])
	colors[value["name"]] = value["color"]
end


function buildingfarmingzone_define(player)
    local position = player:get_pos()
	for _,value in pairs(zone_data) do
		if  position["x"] >= value["min"][1] and
			position["z"] >= value["min"][2] and
			position["x"] <= value["max"][1] and
			position["z"] <= value["max"][2] then
			return value["name"]
		end
	end
	return wild_name
end

minetest.register_on_joinplayer(function(player)
  hud[player] = player:hud_add({
    hud_elem_type = "text",
    name = "Zones",
    number = 0xFF0000,
    position = {x=1, y=1},
    offset = {x=-120, y=-10},
    text = "",
    scale = {x=200, y=60},
    alignment = {x=1, y=-1},
  })
end)

minetest.register_on_leaveplayer(function(player)
  --player:hud_remove("Zones")
  hud[player] = nil
  current_zone[player] = nil
    old_zone[player] = nil
end)



minetest.register_globalstep(function(dtime)
  if delta > INTERVAL then
    for _, player in pairs(minetest.get_connected_players()) do
      current_zone[player] = buildingfarmingzone_define(player)
      if current_zone[player] ~= old_zone[player] then
        player:hud_change(hud[player] , "text", current_zone[player])
        player:hud_change(hud[player] , "number", colors[current_zone[player]])
        old_zone[player] = current_zone[player]
      end
    end
    delta = 0
  else
    delta = delta + dtime
  end
end)
