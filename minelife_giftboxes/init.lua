minelife_giftboxes = {}
minelife_giftboxes.minelife_giftboxes_current_position = {}

local modpath = minetest.get_modpath("minelife_giftboxes")
dofile(modpath.."/settings.lua")
dofile(modpath.."/nodes.lua")
dofile(modpath.."/functions.lua")


minetest.register_privilege("minelife_giftboxes_admin", {
    description ="The privilege for Edit minelife_giftboxes",
    give_to_singleplayer = false,
})
