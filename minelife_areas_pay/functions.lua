function areas_pay.update_areas()
    -- Remove rented areas, theren time is up
    --minetest.debug(areas_pay.storage:get_string("rents"))
    local rents = minetest.deserialize(areas_pay.storage:get_string("rents"))
  if not rents then
    minetest.after(areas_pay.UPDATE_TIME, function() areas_pay.update_areas() end)
    return
  end
  local now = minetest.get_gametime()
  if now == nil then
    minetest.after(areas_pay.UPDATE_TIME, function() areas_pay.update_areas() end)
    return
   end

  for id, table in pairs(rents) do
    if(rents[id].rented_to ~=  nil) then -- rented_to fehlt
      if (rents[id].rented_to < now) then -- Rent time over
        areas_pay:rents_registry_remove(rents[id].customer, rents[id].group)
        if rents[id].block_pos ~= nil and minetest.get_node(rents[id].block_pos).name == "areas_pay:shop_block_red" then
          minetest.swap_node(rents[id].block_pos, {name = "areas_pay:shop_block_green", param2 = 0})
        end
        areas_pay.remove_recursive_areas(rents[id].owner, rents[id].rentID)
        rents[id] = nil
        if areas.areas[id] ~= nil then
          -- Remove ALL Chests, LockedChests, LockedDoors, .... from the area
          for k, v in pairs(areas_pay.BLOCKS_TO_REMOVE) do
            worldedit.replace(areas.areas[id].pos1, areas.areas[id].pos2, v, "air")
          end
        end
      else
        areas_pay.remove_recursive_areas(rents[id].owner, rents[id].rentID)
        areas_pay.select_area(rents[id].owner, id)
        rents[id].rentID = areas_pay.add_owner(rents[id].owner, id.." "..rents[id].customer.." Rented Area")
      end
    end
  end
  areas_pay.storage:set_string("rents", minetest.serialize(rents))
  minetest.after(areas_pay.UPDATE_TIME, function() areas_pay.update_areas() end)
end




--------------------------------------------------------------------------------
-- Area Functions:
-- These are Functions from https://github.com/minetest-mods/areas
-- released under GNU LESSER GENERAL PUBLIC LICENSE   Version 2.1
--------------------------------------------------------------------------------
function areas_pay.change_owner(name, param)
  local id, newOwner = param:match("^(%d+)%s(%S+)$")
  if not id then
    return false, "Invalid usage, see"
        .." /help change_owner."
  end

  if not areas:player_exists(newOwner) then
    return false, "The player \""..newOwner
        .."\" does not exist."
  end

  id = tonumber(id)
  if not areas:isAreaOwner(id, name) then
    return false, "Area "..id.." does not exist"
        .." or is not owned by you."
  end
  areas.areas[id].owner = newOwner
  areas:save()
  minetest.chat_send_player(newOwner,
    ("%s has given you control over the area %q (ID %d).")
      :format(name, areas.areas[id].name, id))
  return true, "Owner changed."
end

function areas_pay.remove_recursive_areas(name, param)
	local id = tonumber(param)
	if not id then
		return false, "Invalid usage, see"
				.." /help recursive_remove_areas"
	end

	if not areas:isAreaOwner(id, name) then
		return false, "Area "..id.." does not exist or is"
				.." not owned by you."
	end
	areas:remove(id, true)
	areas:save()
	return true, "Removed area "..id.." and it's sub areas."
end

function areas_pay.add_owner(name, param)
	local pid, ownerName, areaName
			= param:match('^(%d+) ([^ ]+) (.+)$')

	if not pid then
		minetest.chat_send_player(name, "Incorrect usage, see /help add_owner")
		return -1
	end

	local pos1, pos2 = areas:getPos(name)
	if not (pos1 and pos2) then
		return false, "You need to select an area first."
	end

	if not areas:player_exists(ownerName) then
		return -1, "The player \""..ownerName.."\" does not exist."
	end

	minetest.log("action", name.." runs /add_owner. Owner = "..ownerName..
			" AreaName = "..areaName.." ParentID = "..pid..
			" StartPos = "..pos1.x..","..pos1.y..","..pos1.z..
			" EndPos = "  ..pos2.x..","..pos2.y..","..pos2.z)

	-- Check if this new area is inside an area owned by the player
	pid = tonumber(pid)
	if (not areas:isAreaOwner(pid, name)) or
	   (not areas:isSubarea(pos1, pos2, pid)) then
		return -1
	end

	local id = areas:add(ownerName, areaName, pos1, pos2, pid)
	areas:save()

	return id
end

function areas_pay.select_area(name, param)
	local id = tonumber(param)
	if not id then
		return false, "Invalid usage, see /help select_area."
	end
	if not areas.areas[id] then
		return false, "The area "..id.." does not exist."
	end

	areas:setPos1(name, areas.areas[id].pos1)
	areas:setPos2(name, areas.areas[id].pos2)
	return true, "Area "..id.." selected."
end


--------------------------------------------------------------------------------
-- Group
--------------------------------------------------------------------------------
-- Check if the Player has an area of the given group.
-- If he hasn't, then save this, and return true.
-- If he already owns an area of this group,

function areas_pay.handle_group_buy(player_name, group, area_id)
  if group == nil then
    return true
  end
  local groups = minetest.deserialize(areas_pay.storage:get_string("groups"))
  if groups[player_name] == nil then
     groups[player_name] = {}
  end

  if groups[player_name][group] == nil then
    groups[player_name][group] = area_id
    areas_pay.storage:set_string("groups", minetest.serialize(groups))
    return true
  else
    if areas:isAreaOwner(area_id, player_name) then -- Check if he owns his area, which is saved in his group.
      return false
    else
      groups[player_name][group] = area_id
      areas_pay.storage:set_string("groups", minetest.serialize(groups))
      return true
    end
  end
end


-- For Renting
function areas_pay:rents_registry_add(player_name, group)
  if group == nil then return end
  local rents_registry = minetest.deserialize(areas_pay.storage:get_string("rents_registry"))
  if rents_registry[player_name] == nil then
    rents_registry[player_name] = {}
  end
  rents_registry[player_name][group] = 1
  areas_pay.storage:set_string("rents_registry", minetest.serialize(rents_registry))
end

function areas_pay:rents_registry_remove(player_name, group)
  if group == nil then return end
  local rents_registry = minetest.deserialize(areas_pay.storage:get_string("rents_registry"))
  if rents_registry[player_name] == nil then
    rents_registry[player_name] = {}
  end
  rents_registry[player_name][group] = nil
  areas_pay.storage:set_string("rents_registry", minetest.serialize(rents_registry))
end

-- Returns true, if player dont currently rent such an area
function areas_pay:rents_registry_check(player_name, group)
  local rents_registry = minetest.deserialize(areas_pay.storage:get_string("rents_registry"))
  if rents_registry[player_name] == nil then
    rents_registry[player_name] = {}
  end
  if rents_registry[player_name][group] == nil then
    return true
  else
    return false
  end
end

