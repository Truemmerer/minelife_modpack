-- Pipeworks Chest
-- The Code is modified from digilines

local tube_entry = "^pipeworks_tube_connection_wooden.png"
local chest_side_image = "default_chest_side.png"
local chest_top_image = "default_chest_top.png"
local chest_front_image = "default_chest_front.png"

-- A place to remember things from allow_metadata_inventory_put to
-- on_metadata_inventory_put. This is a hack due to issue
-- minetest/minetest#6534 that should be removed once that’s fixed.
local last_inventory_put_index
local last_inventory_put_stack

-- A place to remember things from allow_metadata_inventory_take to
-- tube.remove_items. This is a hack due to issue minetest-mods/pipeworks#205
-- that should be removed once that’s fixed.
local last_inventory_take_index


minetest.register_node("minelife_chests:chest_pipeworks", {
	description = "MineLife Chest with Pipeworks",
	tiles = {
		chest_top_image..tube_entry,
		chest_top_image..tube_entry,
		chest_side_image..tube_entry,
		chest_side_image..tube_entry,
		chest_side_image..tube_entry,
    chest_front_image
  },
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	groups = {choppy=2, oddly_breakable_by_hand=2, tubedevice=1, tubedevice_receiver=1},
	sounds = default.node_sound_wood_defaults(),
	
  on_construct = function(pos)
    local meta = minetest.get_meta(pos)     

    local chest_player_table = {}
    meta:set_string("chest:players", minetest.serialize(chest_player_table))
    meta:set_string("chest:access_switch", "false")
    meta:set_int("chest:upgrade_inv", 0)
    meta:set_string("infotext", ("MineLife Chest"))
    meta:set_string("chest:pipeworks", "enabled")
    pipeworks.scan_for_tube_objects(pos)
  end,

  after_place_node = function(pos, placer)
    local meta = minetest.get_meta(pos)     
    local inv = meta:get_inventory()
    meta:set_string("chest:owner", placer:get_player_name())
    inv:set_size("main", 48)

  end,

  -- interagieren
  on_rightclick = function(pos, node, player, itemstack, pointed_thing)

    minelife_chest.minelife_chests_current_position[player:get_player_name()] = pos
    if minelife_chest.proof_access(player) == true then
      minetest.sound_play("default_chest_open", {gain = 0.3, pos = pos, max_hear_distance = 10}, true)
      minelife_chest.minelife_chests_pipeworks_spec(player)
    else 
      local player_name = player:get_player_name()
      local meta = minetest.get_meta(pos)
      minetest.chat_send_player(player_name, colorize("#0 The chest is closed for you."))
      minetest.chat_send_player(player_name, colorize("#0 Chest Owner: " ..meta:get_string("chest:owner")))
    end
  end,

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
  end,


--------------
-- Pipeworks
--------------

	after_dig_node = function(pos)
    pipeworks.scan_for_tube_objects(pos)
  end,
	
	on_receive_fields = function(pos, _, fields, sender)
		local name = sender:get_player_name()
		if minetest.is_protected(pos, name) and not minetest.check_player_privs(name, {protection_bypass=true}) then
			minetest.record_protection_violation(pos, name)
			return
		end
	end,

	tube = {
		connect_sides = {left=1, right=1, back=1, front=1, bottom=1, top=1},
		connects = function(i,param2)
			return not pipeworks.connects.facingFront(i,param2)
		end,
		input_inventory = "main",
		can_insert = function(pos, _, stack, direction)
			local ret = minetest.get_meta(pos):get_inventory():room_for_item("main", stack)
			if not ret then
				-- The stack cannot be accepted. It will never be passed to
				-- insert_object, but it should be reported as a toverflow.
				-- Here, direction = direction item is moving, which is into
				-- side.
				local side = vector.multiply(direction, -1)
			end
			return ret
		end,
		insert_object = function(pos, _, original_stack, direction)
			-- Here, direction = direction item is moving, which is into side.
			local side = vector.multiply(direction, -1)
			local inv = minetest.get_meta(pos):get_inventory()
			local inv_contents = inv:get_list("main")
			local any_put = false
			local stack = original_stack
			local stack_name = stack:get_name()
			local stack_count = stack:get_count()
			-- Walk the inventory, adding items to existing stacks of the same
			-- type.
			for i = 1, #inv_contents do
				local existing_stack = inv_contents[i]
				if not existing_stack:is_empty() and existing_stack:get_name() == stack_name then
					local leftover = existing_stack:add_item(stack)
					local leftover_count = leftover:get_count()
					if leftover_count ~= stack_count then
						-- We put some items into the slot. Update the slot in
						-- the inventory, tell Digilines listeners about it,
						-- and keep looking for the a place to put the
						-- leftovers if any.
						any_put = true
						inv:set_stack("main", i, existing_stack)
						local stack_that_was_put
						if leftover_count == 0 then
							stack_that_was_put = stack
						else
							stack_that_was_put = ItemStack(stack)
							stack_that_was_put:set_count(stack_count - leftover_count)
						end
						stack = leftover
						stack_count = leftover_count
						if stack_count == 0 then
							break
						end
					end
				end
			end
			if stack_count ~= 0 then
				-- Walk the inventory, adding items to empty slots.
				for i = 1, #inv_contents do
					local existing_stack = inv_contents[i]
					if existing_stack:is_empty() then
						local leftover = existing_stack:add_item(stack)
						local leftover_count = leftover:get_count()
						if leftover_count ~= stack_count then
							-- We put some items into the slot. Update the slot in
							-- the inventory, tell Digilines listeners about it,
							-- and keep looking for the a place to put the
							-- leftovers if any.
							any_put = true
							inv:set_stack("main", i, existing_stack)
							local stack_that_was_put
							if leftover_count == 0 then
								stack_that_was_put = stack
							else
								stack_that_was_put = ItemStack(stack)
								stack_that_was_put:set_count(stack_count - leftover_count)
							end
							stack = leftover
							stack_count = leftover_count
							if stack_count == 0 then
								break
							end
						end
					end
				end
			end
			return stack
		end,
		remove_items = function(pos, _, stack, dir, count)
			-- Here, stack is the ItemStack in our own inventory that is being
			-- pulled from, NOT the stack that is actually pulled out.
			-- Combining it with count gives the stack that is pulled out.
			-- Also, note that Pipeworks doesn’t pass the index to this
			-- function, so we use the one recorded in
			-- allow_metadata_inventory_take; because we don’t implement
			-- tube.can_remove, Pipeworks will call
			-- allow_metadata_inventory_take instead and will pass it the
			-- index.
			local taken = stack:take_item(count)
			minetest.get_meta(pos):get_inventory():set_stack("main", last_inventory_take_index, stack)
			return taken
		end,
	},
	allow_metadata_inventory_put = function(pos, _, index, stack)
		-- Remember what was in the target slot before the put; see
		-- on_metadata_inventory_put for why we care.
		last_inventory_put_index = index
		last_inventory_put_stack = minetest.get_meta(pos):get_inventory():get_stack("main", index)
		return stack:get_count()
	end,
	allow_metadata_inventory_take = function(_, _, index, stack)
		-- Remember the index value; see tube.remove_items for why we care.
		last_inventory_take_index = index
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		-- See what would happen if we were to move the items back from in the
		-- opposite direction. In the event of a normal move, this must
		-- succeed, because a normal move subtracts some items from the from
		-- stack and adds them to the to stack; the two stacks naturally must
		-- be compatible and so the reverse operation must succeed. However, if
		-- the user *swaps* the two stacks instead, then due to issue
		-- minetest/minetest#6534, this function is only called once; however,
		-- when it is called, the stack that used to be in the to stack has
		-- already been moved to the from stack, so we can detect the situation
		-- by the fact that the reverse move will fail due to the from stack
		-- being incompatible with its former contents.
		local inv = minetest.get_meta(pos):get_inventory()
		local from_stack = inv:get_stack("main", from_index)
		local to_stack = inv:get_stack("main", to_index)
		local reverse_move_stack = ItemStack(to_stack)
		reverse_move_stack:set_count(count)
		local swapped = from_stack:add_item(reverse_move_stack):get_count() == count
		if swapped then
			to_stack:set_count(count)
			local msg = {
				action = "uswap",
				-- The slot and stack do not match because this function is
				-- called after the action has taken place, but the Digilines
				-- message is from the perspective of a viewer who hasn’t
				-- observed the movement yet.
				x_stack = to_stack:to_table(),
				x_slot = from_index,
				y_stack = from_stack:to_table(),
				y_slot = to_index,
			}
		else
			to_stack:set_count(count)
		end
		minetest.log("action", player:get_player_name().." moves stuff in chest at "..minetest.pos_to_string(pos))
	end,
	on_metadata_inventory_put = function(pos, _, index, stack, player)
		-- Get what was in the target slot before the put; it has disappeared
		-- by now (been replaced by the result of the put action) but we saved
		-- it in allow_metadata_inventory_put. This should always work
		-- (allow_metadata_inventory_put should AFAICT always be called
		-- immediately before on_metadata_inventory_put), but in case of
		-- something weird happening, just fall back to using an empty
		-- ItemStack rather than crashing.
		local old_stack
		if last_inventory_put_index == index then
			old_stack = last_inventory_put_stack
			last_inventory_put_index = nil
			last_inventory_put_stack = nil
		else
			old_stack = ItemStack(nil)
		end
		-- If the player tries to place a stack into an inventory, there’s
		-- already a stack there, and the existing stack is either of a
		-- different item type or full, then obviously the stacks can’t be
		-- merged; instead the stacks are swapped. This information is not
		-- reported to mods (Minetest core neither tells us that a particular
		-- action was a swap, nor tells us a take followed by a put). In core,
		-- the condition for swapping is that you try to add the new stack to
		-- the existing stack and the leftovers are as big as the original
		-- stack to put. Replicate that logic here using the old stack saved in
		-- allow_metadata_inventory_put. If a swap happened, report it to the
		-- Digilines network as a utake followed by a uput.
		local leftovers = old_stack:add_item(stack)
	end,

})