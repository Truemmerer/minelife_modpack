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

-- end of color

minelife_server_tools = {}  -- global prefix for functions


dofile(minetest.get_modpath("minelife_server_tools").."/check_license.lua")
dofile(minetest.get_modpath("minelife_server_tools").."/user_commands.lua")
dofile(minetest.get_modpath("minelife_server_tools").."/admin_commands.lua")
dofile(minetest.get_modpath("minelife_server_tools").."/spawn.lua")
dofile(minetest.get_modpath("minelife_server_tools").."/new_player.lua")
dofile(minetest.get_modpath("minelife_server_tools").."/timeaction.lua")
dofile(minetest.get_modpath("minelife_server_tools").."/minelife_ads.lua")
dofile(minetest.get_modpath("minelife_server_tools").."/functions.lua")
dofile(minetest.get_modpath("minelife_server_tools").."/afk_kick.lua")
dofile(minetest.get_modpath("minelife_server_tools").."/hud.lua")
dofile(minetest.get_modpath("minelife_server_tools").."/minelife_stats/minelife_stats_api.lua")
dofile(minetest.get_modpath("minelife_server_tools").."/minelife_stats/minelife_stats_register.lua")
dofile(minetest.get_modpath("minelife_server_tools").."/minelife_stats/minelife_stats.lua")
dofile(minetest.get_modpath("minelife_server_tools").."/server_settings.lua")



-- List Team Members:
Admin = "Admin: Toni_Total, Truemmerer";
Support = "Support: Myrddin";
Devs = "Devs: Truemmerer";












