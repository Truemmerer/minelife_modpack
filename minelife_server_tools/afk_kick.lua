-- This Code ist from https://github.com/GunshipPenguin/afkkick

local MAX_INACTIVE_TIME = 900 -- in seconds  
local CHECK_INTERVAL = 1
local WARN_TIME = 20

local players = {}
local checkTimer = 0

minetest.register_privilege("noafk", {
    description ="no afk kick",
    give_to_singleplayer = false,
    })
    
minetest.register_on_joinplayer(function(player)
	local playerName = player:get_player_name()
	players[playerName] = {
		lastAction = minetest.get_gametime()
	}
end)

minetest.register_on_leaveplayer(function(player)
	local playerName = player:get_player_name()
	players[playerName] = nil
end)

minetest.register_on_chat_message(function(playerName, message)
	players[playerName]["lastAction"] = minetest.get_gametime()
end)

minetest.register_globalstep(function(dtime)
	local currGameTime = minetest.get_gametime()

	--Check for inactivity once every CHECK_INTERVAL seconds
	checkTimer = checkTimer + dtime

	local checkNow = checkTimer >= CHECK_INTERVAL
	if checkNow then
		checkTimer = checkTimer - CHECK_INTERVAL
	end

	--Loop through each player in players
	for playerName, info in pairs(players) do
		local player = minetest.get_player_by_name(playerName)
		if player then
			--Check if this player is doing an action
			for _, keyPressed in pairs(player:get_player_control()) do
				if keyPressed then
					info["lastAction"] = currGameTime
				end
			end

			if checkNow then
				if minetest.get_player_privs(playerName).noafk then
				 return
			    else
				  --Kick player if he/she has been inactive for longer than MAX_INACTIVE_TIME seconds
				  if info["lastAction"] + MAX_INACTIVE_TIME < currGameTime then
					minetest.kick_player(playerName, "Kicked for inactivity")
				  end
				end

				if minetest.get_player_privs(playerName).noafk then
					return
				else
				--Warn player if he/she has less than WARN_TIME seconds to move or be kicked
				  if info["lastAction"] + MAX_INACTIVE_TIME - WARN_TIME < currGameTime then
					minetest.chat_send_player(playerName,
						minetest.colorize("#FF8C00", "Warning, you have " ..
						tostring(info["lastAction"] + MAX_INACTIVE_TIME - currGameTime + 1) ..
						" seconds to move or be kicked"))
				  end
				end
			end
		else
			-- Clean up garbage
			players[playerName] = nil
		end
	end
end)