local chest_side_image = "default_chest_side.png"
local chest_top_image = "default_chest_top.png"
local chest_front_image = "default_chest_front.png"



-- Normal Minelife Chest
minetest.register_node("minelife_chests:chest", {

    description = "MineLife Chest",   
      
      tiles = {
        chest_top_image,
        chest_top_image,
        chest_side_image,
        chest_side_image,
        chest_side_image,
        chest_front_image,
     },

    is_ground_content = false,
    groups = {choppy = 2, oddly_breakable_by_hand = 2},
    sounds = default.node_sound_wood_defaults(),
    sound_close = "default_chest_close",
    paramtype2 = "facedir",
    paramtype = "light",
    drawtype = "nodebox",

    on_construct = function(pos)
      local meta = minetest.get_meta(pos)
      local chest_player_table = {}
      meta:set_string("chest:players", minetest.serialize(chest_player_table))
      meta:set_string("chest:access_switch", "false")
      meta:set_int("chest:upgrade_inv", 0)
      meta:set_string("infotext", ("MineLife Chest"))
      meta:set_string("chest:pipeworks", "disabled")

      local inv = meta:get_inventory()
      inv:set_size("main", minelife_chest.default_chest_high*minelife_chest.default_chest_bright)
    end,

    -- Registriere den Owner beim Platzieren:
    after_place_node = function(pos, placer, itemstack)
      local meta = minetest.get_meta(pos)     
      meta:set_string("chest:owner", placer:get_player_name())
    end,

    -- interagieren
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)

      minelife_chest.minelife_chests_current_position[player:get_player_name()] = pos
      if minelife_chest.proof_access(player) == true then
        minetest.sound_play("default_chest_open", {gain = 0.3, pos = pos, max_hear_distance = 10}, true)
        minelife_chest.minelife_chests_spec(player)
      else 
        local player_name = player:get_player_name()
        local meta = minetest.get_meta(pos)
        minetest.chat_send_player(player_name, colorize("#0 The chest is closed for you."))
        minetest.chat_send_player(player_name, colorize("#0 Chest Owner: " ..meta:get_string("chest:owner")))
      end
    end,

    -- hineinlegen
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        local meta = minetest.get_meta(pos)
        return stack:get_count()
    end,

    -- herausnehmen
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
        local meta = minetest.get_meta(pos)
        return stack:get_count()
    end,

    -- abbauen
    can_dig = function(pos, player)
      local meta = minetest.get_meta(pos)
      if player:get_player_name() == meta:get_string("chest:owner") or minetest.check_player_privs(player:get_player_name(), {protection_bypass}) then
        local inv = meta:get_inventory()
        if inv:is_empty("main") then
          return true
        end
      else
        minetest.chat_send_player(player:get_player_name(), colorize("#0 You arent the owner of the chest!"))
        return false
      end 
    end
})

