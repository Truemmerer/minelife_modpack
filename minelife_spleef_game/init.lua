
-----------------------
-- CHAT COLOR
-----------------------

local colors = {
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

-----------------------
-- FUNCTION PREFIX
-----------------------

minelife_spleef_game = {}

-----------------------
--SETTINGS
-----------------------

minelife_spleef_game.register_not_move = true -- not in use now
minelife_spleef_game.register_not_move_seconds = 6  -- not in use now

-----------------------
--REGISTER PRIVILEGES
-----------------------

minetest.register_privilege("minelife_spleef_team", {
  description ="The privilege to administrate spleef games ",
  give_to_singleplayer = false,
  })


-----------------------
-- LOAD LUA FILES
-----------------------

dofile(minetest.get_modpath("minelife_spleef_game").."/tool.lua")
dofile(minetest.get_modpath("minelife_spleef_game").."/function.lua")



-----------------------
-- LOG IF MOD LOADED
-----------------------

minetest.log("info", "[minelife_spleef_game]: loaded")


