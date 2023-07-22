-- MineLife Enderchest
minetest.register_node("minelife_chests:enderchest", {

    description = "MineLife Enderchest",
    tiles = {
      "minelife_enderchest_top.png",
      "minelife_enderchest_side.png",
      "minelife_enderchest_side.png",
      "minelife_enderchest_side.png",
      "minelife_enderchest_side.png",
      "minelife_enderchest_front.png",
     },
    is_ground_content = false,
	  groups = {cracky = 1, level = 2},
    sounds = default.node_sound_wood_defaults(),
    sound_open = "default_chest_open",
    sound_close = "default_chest_close",
    paramtype2 = "facedir",
    paramtype = "light",
    drawtype = "nodebox",

    on_construct = function(pos)
	  	local meta = minetest.get_meta(pos)
       meta:set_string("infotext", ("MineLife Enderchest"))
	  end,

    on_rightclick = function(pos, node, player, itemstack, pointed_thing)

      minelife_chest.minelife_chests_current_position[player:get_player_name()] = pos
      minelife_chest.minelife_enderchests_spec(player)

    end,

})

if minelife_chest.replace_xdecor_enderchests == true and minetest.get_modpath("xdecor")then
  minetest.register_alias_force("xdecor:enderchest", "minelife_chests:enderchest")
end
