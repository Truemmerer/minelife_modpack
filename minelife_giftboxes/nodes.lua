-- Register Node
minetest.register_node("minelife_giftboxes:christmas", {
	description = "MineLife Christmas Gift",
    tiles = {
		"christmas_gift_top.png",
		"christmas_gift_top.png",
		"christmas_gift_side.png",
		"christmas_gift_side.png",
		"christmas_gift_side.png",
		"christmas_gift_side.png",
	},
    is_ground_content = false,
    groups = {choppy = 2, oddly_breakable_by_hand = 2},
    paramtype2 = "facedir",
    paramtype = "light",
    drawtype = "nodebox",
    

    -- Legt den Standart Wert der Node Meta fest
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("infotext", ("MineLife Christmas Gift"))
        local inv = meta:get_inventory()
        inv:set_size("main", minelife_giftboxes.default_inv_high*minelife_giftboxes.default_inv_bright)

        meta:set_string("minelife_giftboxes_used", "")
        meta:set_int("minelife_giftboxes_use_day", 0)
        meta:set_int("minelife_giftboxes_use_month", 0)
        
    end,
    after_place_node = function(pos, placer)
        local meta = minetest.get_meta(pos)
        meta:set_string("chest:owner", placer:get_player_name())
    end,

    -- Ruft die Form auf, damit der Tag bzw das Codeword festgelegt werden kann
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        minelife_giftboxes.minelife_giftboxes_current_position[player:get_player_name()] = pos
        minelife_giftboxes.showform(pos, player)
    end,

    
})