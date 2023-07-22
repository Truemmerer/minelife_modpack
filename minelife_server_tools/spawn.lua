--OLD SPAWN: local SPAWN = {x = -3, y = 10, z = -16}
local SPAWN = {x = 0, y = 2.5, z = -283}
local spawns = {}
local spawnpending = {}


-- Set Bed-Spawn Point, if it is null ------------
minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local pos = beds.spawn[name]
	if pos == nil then
		beds.spawn[name] = SPAWN
	end


end)

-- Teleporting to Spawn: ------------------------
minetest.register_chatcommand("spawn", {
  description = "Enter /spawn twice in succession if you are stuck somewhere. You will then get to the spawn for free. However, the command is only executed after 4 minutes! Tip: You can also use '/tp spawn' at any time.",
  privs = {
      interact = true,
  },
  func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if player:get_pos()["y"] < -100 then
			minetest.chat_send_player(name, "Under y = -100 you can use '/tp spawn' only.")
		elseif spawnpending[name] == nil then
	    spawnpending[name] = 0
	    minetest.chat_send_player(name, "You would be teleportet to spawn in 4 minutes. If you want this, then type '/spawn' again. Otherwise you can type '/tp spawn' to teleport immediately.")
    else
      spawnpending[name] = nil
      spawns[name] = 0
      minetest.chat_send_player(name, "Great, I will teleport you in 4 minutes, Roger...")
		end
  end
})

-- On Leave -------------------------------------
minetest.register_on_leaveplayer(function(player)
    local name = player:get_player_name()
    spawns[name] = nil
end)

-------------------------------------------------

minetest.register_globalstep(function(dtime)
    for k, v in pairs(spawns) do
      spawns[k] = v + dtime
      local player = minetest.get_player_by_name(k)
      if v > 240 and player:is_player() then
        minetest.chat_send_player(k, "Teleporting....")
        jeans_economy_book(k, "!SERVER!", 0, "Teleported "..k.." to the spawn.")
        player:set_pos(SPAWN)
        spawns[k] = nil
      end
    end
    -- After 60 seconds a teleportation request will be deleted.
    for k, v in pairs(spawnpending) do
      spawnpending[k] = v + dtime
      if v > 60 then
        spawnpending[k] = nil
      end
    end
  end)
  
