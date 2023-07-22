jeans_shopsystems = {}

minetest.register_privilege("jeans_shopsystems", {
  description = "Priv to build and configure adminshops, and watch in usershops",
  give_to_singleplayer = true,
  give_to_admin = true,
})

jeans_shopsystems.player_positions = {}

jeans_shopsystems.licenses_activated = false
if minetest.get_modpath("jeans_licenses") then
  jeans_shopsystems.licenses_activated = true
end



function jeans_shopsystems.check_priv(player_name)
  return minetest.check_player_privs(player_name, { jeans_shopsystems=true })
end

local modpath = minetest.get_modpath(minetest.get_current_modname())
dofile(modpath.."/functions.lua")
dofile(modpath.."/adminshop.lua")
