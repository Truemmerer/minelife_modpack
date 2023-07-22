-- Basic Commands: ----------------------------------------------------------------------------

minetest.register_chatcommand("home", {
    description = "To teleport to a home point, use /tp NAME",
    func = function(name, param)
      minetest.chat_send_player(name, colorize("#1 To teleport to a home point, use /tp NAME"))
    end
  })
  minetest.register_chatcommand("sethome", {
    description = "To set a Home point, use /tp_add home",
    func = function(name, param)
      minetest.chat_send_player(name, colorize("#1 To set a Home point, use /tp_add home"))
    end
  })
    
  minetest.register_chatcommand("rules", {
    description = "You can read our rules in our Wiki: /wiki",
    privs = {
    },
    func = function(name, param)
      minetest.chat_send_player(name, colorize("#2 You can read our rules in our Wiki: /wiki"))
    end
  })
  

  -- Get free Free Kit -----------------------------------------
minetest.register_chatcommand("kit", {
    description = "You can get a survival kit every 12 hours.",
    privs = {
    },
    func = function(name, param)
      local COOLDOWNTIME = 12 * 3600 -- 12 Hours
      local player = minetest.get_player_by_name(name)
      local pmeta = player:get_meta()
      if pmeta:get_int("34287932") + COOLDOWNTIME <= minetest.get_gametime() then
        local pinv = player:get_inventory()
        local items = {{name="default:sword_steel", count=1, wear=0, metadata=""}, {name="default:axe_stone", count=1, wear=0, metadata=""}, {name="default:shovel_stone", count=1, wear=0, metadata=""}, {name="default:pick_stone", count=1, wear=0, metadata=""}, {name="farming:bread", count=3, wear=0, metadata=""}, {name="default:torch", count=3, wear=0, metadata=""}}
        for k, v in pairs(items) do
          pinv:add_item("main", v)
        end
        pmeta:set_int("34287932", minetest.get_gametime())
        minetest.chat_send_player(name, colorize("#3 Successfully added Survival Kit to your inventory"))
      else
        minetest.chat_send_player(name, colorize("#1 You can use this command only every 12 hours!"))
      end
    end
  })

  -------------------------------------------------------
  --- Wiki: ---------------------------------------------
minetest.register_chatcommand("wiki", {
    description = "Open MineLife Wiki",
    -- privs = {
    --     interact = true,
    -- },
    func = function(name, param)
      --minetest.chat_send_player(name, "Open This Site to get to the wiki: minelife.server-jean.de ")
      doc.show_doc(name)
    end
  })
  
  minetest.register_chatcommand("doc", {
    description = "Open MineLife Wiki",
    -- privs = {
    --     interact = true,
    -- },
    func = function(name, param)
      --minetest.chat_send_player(name, "Open This Site to get to the wiki: minelife.server-jean.de ")
      doc.show_doc(name)
    end
  })
  
  -------------------------------------------------------
  --- Online: ------------------------------------------

  minetest.register_chatcommand("discord", {
    description = "Shows you the link from our Discord",
    func = function(name, param)
      minetest.chat_send_player(name, colorize("#2 no url in code"))
    end
  })

  minetest.register_chatcommand("website", {
    description = "Shows you the link from our Website",
    func = function(name, param)
      minetest.chat_send_player(name, colorize("#2 Website with FAQ, documentation, map, and more: no url in code"))
    end
  })

  minetest.register_chatcommand("twitter", {
    description = "Shows you the link from our Twitter Channel",
    func = function(name, param)
      minetest.chat_send_player(name, colorize("#2 Follow our tweets :) no url in code"))
    end
  })
  minetest.register_chatcommand("youtube", {
    description = "Shows you the link from our YouTube Channel",

    func = function(name, param)
      minetest.chat_send_player(name, colorize("#2 Follow us on youtube! no url in code"))
    end
  })
  minetest.register_chatcommand("radio", {
    description = "Shows you the link from our Radio",
    func = function(name, param)
      minetest.chat_send_player(name, colorize("#2 no url in code"))
    end
  })

  
--------------------------------------------------------------------------
-- NEWS HIDE / SHOW COMMAND 

-- licenses_add("news")

--[[
minetest.register_chatcommand("news_conf", {
  privs = {
      interact = true,
  },
  params = "hide|show",
  description = "Hide or show the News Panel after login.",
   func = function(player, mode)
    if mode == "hide" then
      minetest.chat_send_player(player, colorize("#3 Hide the News Panel after login"))
      licenses.assign(player, "news")
    elseif mode == "show" then
      minetest.chat_send_player(player, colorize("#3 Show the News Panel after login"))
      licenses.revoke(player, "news")
    else
      minetest.chat_send_player(player, colorize("#1 Wrong Command! Please enter: news <show|hide>"))
    end 
   end
   })
   --]]

--------------------------------------------------------------------------
-- Language Configuration

   minetest.register_chatcommand("speech", {
     privs = {
       interact = true,
     },
     params = "<playertwo>",
     description = "Check the language of a player",
    
    func = function(player, playertwo)
      if playertwo == nil then
        minetest.chat_send_player(player, "Playertwo is nil")
      else
        if licenses_check_player_by_licese(player, "language-de") then
          if licenses_check_player_by_licese(playertwo, "language-de") then
            minetest.chat_send_player(player, colorize("#3Der Spieler "..playertwo.." hat die Sprache Deutsch ausgewählt."))
          elseif licenses_check_player_by_licese(playertwo, "language-en") then
            minetest.chat_send_player(player, colorize("#3Der Spieler "..playertwo.." hat die Sprache Englisch language."))
          elseif not minetest.player_exists(playertwo) then
            minetest.chat_send_player(player, colorize("#1Der Spieler "..playertwo.." existiert nicht."))
          else 
            minetest.chat_send_player(player, colorize("#1Der Spieler "..playertwo.." hat keine Sprache ausgewählt."))
          end
        else
          if licenses_check_player_by_licese(playertwo, "language-de") then
            minetest.chat_send_player(player, colorize("#3The player "..playertwo.." has selected the german language."))
          elseif licenses_check_player_by_licese(playertwo, "language-en") then
            minetest.chat_send_player(player, colorize("#3The player "..playertwo.." has selected the english language."))
          elseif not minetest.player_exists(playertwo) then
            minetest.chat_send_player(player, colorize("#1The player "..playertwo.." didn't exists."))
          else 
            minetest.chat_send_player(player, colorize("#1The player "..playertwo.." didn't selected a language."))
          end  
        end
      end
    end 
   })

   minetest.register_chatcommand("language", {
    privs = {
      interact = true,
    },
    params = "<de|en>",
    description = "Change your language",
    func = function(player, language)
      if language == "de" then
        licenses_unassign(player, "language-en")
			  licenses_assign(player, "language-de")	
        minetest.chat_send_player(player, colorize("#3Du hast auf deutsche Sprache gewechselt."))
      elseif language == "en" then
        licenses_unassign(player, "language-de")
		   	licenses_assign(player, "language-en")	
        minetest.chat_send_player(player, colorize("#3Your new language is english"))
      else 
        minetest.chat_send_player(player, colorize("#1 Wrong language! Use language <de|en>"))
      end
    end  
   })
   

   minetest.register_chatcommand("mods", {
    privs = {
      },
    params = "",
    description = "MineLife Mods information",
    func = function(player)
      if licenses_check_player_by_licese(player, "language-de") then
        minetest.chat_send_player(player, colorize("#2 MineLife verwendet ausgewählte Mods der Community. Desweiteren haben wir eigene exklusive Mods, die dein Spielerlebnis verbessern."))
        minetest.chat_send_player(player, colorize("#2 Weitere Informationen findest du hier:"))
        minetest.chat_send_player(player, colorize("#2 no url in code"))
      else 
        minetest.chat_send_player(player, colorize("#2 MineLife uses selected mods from the community. Furthermore, we have our own exclusive mods that enhance your gaming experience."))
        minetest.chat_send_player(player, colorize("#2 You can find more information here:"))
        minetest.chat_send_player(player, colorize("#2 no url in code"))
      end
    end  
   })

   minetest.register_chatcommand("admin", {
    privs = {
      },

    params = "",
    description = "Lists the members of the team",
    func = function(player)
      minetest.chat_send_player(player, colorize("#2 Team Members:"))
      minetest.chat_send_player(player, colorize("#2 " ..Admin))
      minetest.chat_send_player(player, colorize("#2 " ..Support))
      minetest.chat_send_player(player, colorize("#2 " ..Devs))
    end
   })

   

   minetest.register_chatcommand("ma_check", {
    params = "<player>",
    description = "Check the max Areas of a player",

    func = function(name, param)
      local player = minetest.get_player_by_name(param)
      local max_areas = minelife_server_tools.check_max_areas_of_player(player)

      if licenses_check_player_by_licese(param, "language-de") then
        minetest.chat_send_player(name, colorize("#3Der Spieler "..param.." kann maximal "..max_areas.." Areas anlegen"))
      else
        minetest.chat_send_player(name, colorize("#The Player "..param.." can create a maximum of "..max_areas.." areas"))
      end
    end

  })