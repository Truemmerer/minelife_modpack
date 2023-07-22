areas_pay = {}

minelife_areas_pay = {}

-- CHAT COLOR
colors = {
  ["0"] = "#ff0000", -- red
  ["1"] = "#ff5500", -- orange
  ["2"] = "#0000ff", -- blue
  ["3"] = "#00ff00", -- green
  ["4"] = "#ffff00", -- yellow 
}


function get_escape(color)
return minetest.get_color_escape_sequence(colors[string.upper(color)] or "#FFFFFF")
end

function colorize(text)
return string.gsub(text,"#([01234])",get_escape)
end

--------------------------------------------------------------------------------
-- MEMORY ----------------------------------------------------------------------
--------------------------------------------------------------------------------

areas_pay.storage = minetest.get_mod_storage()
local rents = minetest.deserialize(areas_pay.storage:get_string("rents"))
if rents == nil then
  rents = {}
end
areas_pay.storage:set_string("groups", minetest.serialize(rents))

local groups = minetest.deserialize(areas_pay.storage:get_string("groups"))
if groups == nil then
  groups = {}
end
areas_pay.storage:set_string("groups", minetest.serialize(groups))

local rents_registry = minetest.deserialize(areas_pay.storage:get_string("rents_registry"))
if rents_registry == nil then
  rents_registry = {}
end
areas_pay.storage:set_string("rents_registry", minetest.serialize(rents_registry))

local modpath = minetest.get_modpath(minetest.get_current_modname())
dofile(modpath.."/functions.lua")
dofile(modpath.."/config.lua")
dofile(modpath.."/block.lua")
dofile(modpath.."/more_slots_formspec.lua")
dofile(modpath.."/settings.lua")
dofile(modpath.."/register_on_click.lua")





areas_pay.update_areas()
