--------
-- API
--------
minelife_stats = {}
local minelife_playerstats = {}
minelife_stats.registered_stats = {}

function minelife_stats.register_stat(stat_name)
    table.insert(minelife_stats.registered_stats, stat_name)
end

function minelife_stats.set_stat(player, statsname, value)
    local playername = player
    if type(playername) ~= "string" then
        playername = player:get_player_name()
    end
    if not minelife_playerstats[playername] then
        minelife_playerstats[playername] {}
    end
    minelife_playerstats[playername][statsname] = value
end

function minelife_stats.increase_stat(player, statsname, value)
	local playername = player
	if type(playername) ~= "string" then
		playername = player:get_player_name()
	end
	if not minelife_playerstats[playername] then
		minelife_playerstats[playername] = {}
	end
	if not minelife_playerstats[playername][statsname] then
		minelife_playerstats[playername][statsname] = 0
	end
	minelife_playerstats[playername][statsname] = minelife_playerstats[playername][statsname] + value
end

-- Generiere Top 10 Listen einer Statistik
function minelife_stats_top_10(statistik)

	local sorttable = {}
	for player, stat in pairs(minelife_playerstats) do
		for name, wert in pairs(stat) do


		end
	end
end

function minelife_stats_test()

	local t = {1, 33, 5, 9};
	local test = ""

	--[[
	for k, v in ipairs(t) do
		test = test .. k .. ") " .. v .."\n"
	end
	--]]

	table.sort(t)
	return "sorted table"
end


function minelife_stats_get_stat_list(player_name, statistik, eintrag)
	local playerlist = ""
	local listforplayers = ""
	local statlist = ""

	local zähler = 0

	-- minelife_playerstats ist table:
	-- 1. Ebene Spieler
	-- 2. Ebene Statistik
	-- Ergebnis Wert
	for player, stat in pairs(minelife_playerstats) do
		-- player ist Name des Spielers
		-- stat ist ein Table oder Liste:
		-- 1. Ebene : Statistik
		-- Ergebnis Wert
		for name, wert in pairs(stat) do
			--minetest.chat_send_all("Spieler: " .. player .. " | Stat: " .. name .. " | Wert: " .. wert);
			
			-- Gibt vom Spieler alle Stats und dessen Werte wieder
			if player_name == player then
				zähler = zähler + 1				
				if zähler <= 1 then
					listforplayers = "Stat: " .. name .. " | " .. wert
				elseif zähler >= 2 then
					listforplayers = listforplayers .. "\n Stat: " .. name .. " | " .. wert
				end
			end

			-- Gibt die Spieler mit dem gleichen Wert wieder.
			if eintrag == wert then
				zähler = zähler + 1
				if zähler <= 1 then
					playerlist =  player
				elseif zähler >= 2 then
					playerlist = playerlist .. " | " .. player
				end
			end
		end
	end	
	
	if zähler >= 2 then
		return playerlist
	else 
		-- Wenn Zähler = 0 oder 1
		return false
	end


end


function minelife_stats.get_stat(player, statsname)
	local playername = player
	if type(playername) ~= "string" then
		playername = player:get_player_name()
	end
	if not minelife_playerstats[playername] then
		minelife_playerstats[playername] = {}
	end
	if not minelife_playerstats[playername][statsname] then
		minelife_playerstats[playername][statsname] = 0
	end
	return minelife_playerstats[playername][statsname]
end

------------
-- End API
------------

--------------
-- Save Stats
--------------

local file = io.open(minetest:get_worldpath().."/minelife_stats.txt", "r")
if file then
		local table = minetest.deserialize(file:read("*all"))
		if type(table) == "table" then
			minelife_playerstats = table
		else
			minetest.log("error", "Corrupted minelife_stats file")
		end
		file:close()
end

function minelife_stats.save_minelife_stats()
	local file = io.open(minetest:get_worldpath().."/minelife_stats.txt", "w")
	if file then
		file:write(minetest.serialize(minelife_playerstats))
		file:close()
	else
		minetest.log("error", "Can't save minelife_stats")
	end
end

minetest.register_on_shutdown(function() 
	minelife_stats.save_minelife_stats()
end)


