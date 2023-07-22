-- check the last login
function minelife_stats.check_last_login(player)
    local pauth = minetest.get_auth_handler().get_auth(player)
    if pauth and pauth.last_login and pauth.last_login ~= -1 then
        local lastLogin = os.date("!%d-%m-%Y - %H:%M:%S", pauth.last_login)
        return lastLogin
    else
        lastLogin = "unkown"
        return lastLogin
    end
end

-- set the IP and the first_login of a player
minetest.register_on_joinplayer(function(player)

	local stunde  = tonumber( os.date( "%H"));
	local minute  = tonumber( os.date( "%M"));
	local sekunde = tonumber( os.date( "%S"));

	local tag     = tonumber( os.date( "%d"));
	local monat   = tonumber( os.date( "%m"));
	local jahr    = tonumber( os.date( "%Y"));

    local name = player:get_player_name()
    local ip = minetest.get_player_ip(name)

      if minelife_stats.get_stat(player, "firstlogin_day") == nil or minelife_stats.get_stat(player, "firstlogin_day") == "" or minelife_stats.get_stat(player, "firstlogin_day") == 0 then
		minelife_stats.set_stat(player, "firstlogin_day", tag)
	  end

	  if minelife_stats.get_stat(player, "firstlogin_month") == nil or minelife_stats.get_stat(player, "firstlogin_month") == "" or minelife_stats.get_stat(player, "firstlogin_month") == 0 then
		minelife_stats.set_stat(player, "firstlogin_month", monat)
	  end

	  if minelife_stats.get_stat(player, "firstlogin_year") == nil or minelife_stats.get_stat(player, "firstlogin_year") == "" or minelife_stats.get_stat(player, "firstlogin_year") == 0 then
		minelife_stats.set_stat(player, "firstlogin_year", jahr)
	  end

	  if minelife_stats.get_stat(player, "firstlogin_hour") == nil or minelife_stats.get_stat(player, "firstlogin_hour") == "" or minelife_stats.get_stat(player, "firstlogin_hour") == 0 then
		minelife_stats.set_stat(player, "firstlogin_hour", stunde)
	  end

	  if minelife_stats.get_stat(player, "firstlogin_minute") == nil or minelife_stats.get_stat(player, "firstlogin_minute") == "" or minelife_stats.get_stat(player, "firstlogin_minute") == 0 then
		minelife_stats.set_stat(player, "firstlogin_minute", minute)
	  end

	  if minelife_stats.get_stat(player, "firstlogin_second") == nil or minelife_stats.get_stat(player, "firstlogin_second") == "" or minelife_stats.get_stat(player, "firstlogin_second") == 0 then
		minelife_stats.set_stat(player, "firstlogin_second", sekunde)
	  end

	  minelife_stats.set_stat(player, "player_ip", ip)
end)


-- log the played time
local timer = 0
local timer2 = 0


-- played Time:
local timer = 0
local timer2 = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	timer2 = timer2 + dtime
	
	-- NOTE: Set this to a higher value to remove some load from the server
	if timer > 0 then
		for _,player in ipairs(minetest.get_connected_players()) do
			minelife_stats.increase_stat(player, "played_time", timer)
		end
		timer = 0
	end
	
	if timer2 > 30 then
		timer2 = 0
		minelife_stats.save_minelife_stats()
	end
end)

function minelife_stats.check_played_time(name)
	local playername = name
	local player = minetest.get_player_by_name(name)
	if player then
		playername = player:get_player_name()
	end

	playedTimeinSeconds = minelife_stats.get_stat(playername, "played_time") 

	time = math.floor(playedTimeinSeconds)
	local timestring = "" .. (time%60) .. "s"
	time = math.floor(time/60)
	if time > 0 then
		timestring = (time%60) .. "m " .. timestring
	end
	time = math.floor(time/60)
	if time > 0 then
		timestring = (time%24) .. "h " .. timestring
	end
	time = math.floor(time/24)
	if time > 0 then
		timestring = time .. "d " .. timestring
	end

	return timestring

end
-- end played time


-- check player ip
function minelife_stats.check_player_ip(name)
	local playername = name
	local player = minetest.get_player_by_name(name)
	if player then
	  playername = player:get_player_name()
	end
	if minelife_stats.get_stat(playername, "player_ip") ~= nil and minelife_stats.get_stat(playername, "player_ip") ~= "" and minelife_stats.get_stat(playername, "player_ip") ~= 0 then
		local ip = minelife_stats.get_stat(playername, "player_ip")
		-- Check IP double
		local checkdoubleip = minelife_stats_get_stat_list("", "", ip)
		if checkdoubleip == false then
			return "#3".. ip
		else
			return "#1".. ip .. " > Used by: " .. checkdoubleip .. ""
		end		
	else
		return "unkown"
	end
end

-- check first_login_date & time
function minelife_stats.check_first_login(name)
	local playername = name
	local player = minetest.get_player_by_name(name)
	if player then
		playername = player:get_player_name()
	end

	local day =  minelife_stats.get_stat(playername, "firstlogin_day")
	local month = minelife_stats.get_stat(playername, "firstlogin_month")
	local year = minelife_stats.get_stat(playername, "firstlogin_year")
	local hour = minelife_stats.get_stat(playername, "firstlogin_hour")
	local minute = minelife_stats.get_stat(playername, "firstlogin_minute")
	local sekunde = minelife_stats.get_stat(playername, "firstlogin_second")

	return ""..day.."-"..month.."-"..year.." - "..hour..":" ..minute..":"..sekunde..""
end

-- register if a player die
minetest.register_on_dieplayer(function(player)
    minelife_stats.increase_stat(player, "died", 1)
end)

--[[
minetest.register_chatcommand("test", {

	func = function ()

		minetest.chat_send_all(minelife_stats_test())
		
	end
})
--]]