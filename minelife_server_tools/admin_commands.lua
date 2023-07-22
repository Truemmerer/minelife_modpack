minetest.register_privilege("minelifeadmin", {
    description ="The privilege for MineLifeTeam ",
    give_to_singleplayer = false,
    })
    
    --end of register privilege "serversay"
    
--------------------------------------------------------------------------
-- SERVERSAY
    minetest.register_chatcommand("ssay", {
        params = "<message>",
        description = "Write as server",
        privs = {minelifeadmin = true},
      func = function( _ , message)
        minetest.chat_send_all(colorize("#0[SERVER] #0")..message)
        end,
})

--------------------------------------------------------------------------
-- CREATIVE

local cplayers = {}

minetest.register_on_joinplayer(function(player)
  
	local playerName = player:get_player_name()
  local pmeta = minetest.get_player_by_name(playerName):get_meta()

	cplayers[playerName] = {
		cstatus = true
	}
end)

minetest.register_on_leaveplayer(function(player)
	local playerName = player:get_player_name()
	cplayers[playerName] = nil
end)


minetest.register_chatcommand("creative", {
  description = "Toggle Creative On/Off",
  privs = {minelifeadmin = true},

  func = function(playername, param)

    local creapriv = minetest.check_player_privs(playername, {creative=true})
    local cpriv = minetest.get_player_privs(playername)

    -- CREA OFF
    if creapriv == true then
  
      -- CREATIVE
      cpriv.creative = nil
      minetest.set_player_privs(playername, cpriv)
      minetest.chat_send_player(playername, colorize("#3 Creative Off"))

      -- GODMODE
      players[playername]["god_mode"] = not players[playername]["god_mode"];
      minetest.chat_send_player(playername, colorize("#3 Godmode is now off"))

      -- HUNGER
      cplayers[playername] = {
        cstatus = true
      }
      minetest.chat_send_player(playername, colorize("#3 Hunger is now on"))


      -- CREA ON
    elseif creapriv == nil or creapriv == false then
    
      -- CREATIVE
      cpriv.creative = true
      minetest.set_player_privs(playername, cpriv)
      minetest.chat_send_player(playername, colorize("#3 Creative On"))
      
      -- GODMODE
      players[playername]["god_mode"] = not players[playername]["god_mode"];
      minetest.chat_send_player(playername, colorize("#3 Godmode is now on"))

      -- HUNGER
      cplayers[playername] = {
        cstatus = false
      }
      hunger_set(playername)
      minetest.chat_send_player(playername, colorize("#3 Hunger is now off"))

       
    else 
      minetest.chat_send_player(playername, colorize("#1 ERROR CREATIVE"))
    
    end  

  end
})

local ctimer = 0
minetest.register_globalstep(function(dtime)

  ctimer = ctimer + dtime;
	if ctimer >= 300 then
		-- DEV COMMAND:
    -- minetest.chat_send_all("ctimer " .. ctimer .. "")
    
    for playerName, info in pairs(cplayers) do
      local player = minetest.get_player_by_name(playerName)

      if player then
        if info["cstatus"] == false then
          hunger_set(playerName)
          -- DEV COMMAND:
          -- minetest.chat_send_all("info false " .. playerName .. "")
        end
      else
        -- Clean up garbage
        cplayers[playerName] = nil
      end

    end
        
    
    ctimer = 0
	end

end)

hunger_set = function(playername)
    -- DEV COMMAND:
    -- minetest.chat_send_all("hunger_set open")

    local targetname = playername
      if not targetname then
        targetname = playername
      end  
    local target = minetest.get_player_by_name(playername)
    hbhunger.hunger[targetname] = 30
    hbhunger.set_hunger_raw(target)
  end

 
    ---------------------------------------------------------------------------
    -- Time --
    -- Day
    
    minetest.register_chatcommand("day", {
      description = "A new day has begin",
      privs = {minelifeadmin = true},
      func = function(name, param)
        minetest.set_timeofday(0.225)
        minetest.chat_send_player(name, colorize("#1 The new day has begun"))
      end,  
    
    })
    
    -- Night
    minetest.register_chatcommand("night", {
      description = "The Darknes is comming",
      privs = {minelifeadmin = true},
    
      func = function(name, param)
      minetest.set_timeofday(0.825)
      minetest.chat_send_player(name, colorize("#1 The night has appeared"))
      end,
    
    })

    minetest.register_chatcommand("ma", {
      params = "<message>",
      description = "Admin Chat",
      privs = {minelifeadmin = true},

      func = function(chatter, param)
        for _,player in ipairs(minetest.get_connected_players()) do
          local name = player:get_player_name()
          if licenses.check(name, "admin") or licenses.check(name, "support") then
            minetest.chat_send_player(name, colorize("#1" ..chatter.. ": #4" ..param))
          end
        end
      end
    })


    minetest.register_chatcommand("playercheck", {
      params = "<player>",
      description = "Check a player",
      privs = {minelifeadmin = true},

      func = function(name, playertwo)
        
        
        

        local playername = name
        local player = minetest.get_player_by_name(playertwo)
        if player then
          playername = player:get_player_name()
        end

        if minetest.player_exists(playertwo) then

          minetest.chat_send_player(name, colorize("#2Check for ".. playertwo..":"))
          minetest.chat_send_player(name, colorize("#2---------------------------"))
          minetest.chat_send_player(name, colorize("#2IP: " ..minelife_stats.check_player_ip(playertwo)))
          minetest.chat_send_player(name, colorize("#2Last login: " ..minelife_stats.check_last_login(playertwo)))
          minetest.chat_send_player(name, colorize("#2First login: " ..minelife_stats.check_first_login(playertwo)))
          minetest.chat_send_player(name, colorize("#2Played Time: " ..minelife_stats.check_played_time(playertwo)))
          minetest.chat_send_player(name, colorize("#2---------------------------"))
          minetest.chat_send_player(name, colorize("#2Language: " ..minelife_server_tools.check_language(playertwo)))
          minetest.chat_send_player(name, colorize("#2---------------------------"))
          --minetest.chat_send_player(name, colorize("#2Current Job: " ..jobsystem.checkjob(playertwo)))
          minetest.chat_send_player(name, colorize("#2Change Jobs (not implemented)"))
        else
          minetest.chat_send_player(name, colorize("#1Player "..playertwo.." not found!"))
        end
      end
    })


    minetest.register_chatcommand("ma_add", {
      params = "<player> <anzahl>",
      description = "Add more Areas to a player",
      privs = {minelifeadmin = true},

      func = function (name, param)
        local player_name, anzahl = string.match(param, "(%S+) (%S+)")

        local player = minetest.get_player_by_name(player_name)

        if not minelife_server_tools.add_max_area_of_player(player, anzahl) == true then
          minetest.chat_send_player(player_name, colorize("#0ERROR: by add max areas for player"..player_name))
          minetest.chat_send_player(name, colorize("#0ERROR: by add max areas for player"..player_name))
        end

        local max_areas = minelife_server_tools.check_max_areas_of_player(player)

        if licenses_check_player_by_licese(name, "language-de") then
           minetest.chat_send_player(name, colorize("#3Dem Spieler "..player_name.." wurden neue Areas zugeschrieben. Maximal kannst du nun maximal "..max_areas.." Areas besitzen"))

        else
          minetest.chat_send_player(name, colorize("#3The player "..player_name.." has been assigned new areas. You can now have a maximum of "..max_areas.." Areas own"))
        end

        if licenses_check_player_by_licese(player_name, "language-de") then
          minetest.chat_send_player(player_name, colorize("#3Dir wurden neue Areas zugeschrieben. Maximal kannst du nun maximal "..max_areas.." Areas besitzen"))

        else
          minetest.chat_send_player(player_name, colorize("#3You have been assigned new areas. You can now have a maximum of "..max_areas.." Areas own"))

        end


      end

    })
    
minetest.register_chatcommand("ma_set", {
  params = "<player> <anzahl>",
  description = "Add more Areas to a player",
  privs = {minelifeadmin = true},

  func = function (name, param)
    local player_name, anzahl = string.match(param, "(%S+) (%S+)")
    local player = minetest.get_player_by_name(player_name)

    if not minelife_server_tools.set_max_area_of_player(player, anzahl) == true then
      minetest.chat_send_player(name, colorize("#0ERROR: by set max areas for player"..player_name))
    end

    minetest.chat_send_player(player_name, colorize("#3The player "..player_name.." can now have a maximum of "..anzahl.." areas own"))
 
  end
})