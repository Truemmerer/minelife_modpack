-- Add Licences

licenses_add("worldedit")


-- Check Player Privileges: ------------------------------------

minetest.register_on_joinplayer(function(player)
	local pmeta = player:get_meta()
  local privs = {interact = true, shout = true}
  if pmeta:get_string("12383") ~= "activated" then
    privs = {interact = true, shout = true}
  end
 
  -- Admin License
  if licenses_check_player_by_licese(player:get_player_name(), "admin") then
    privs = {minelife_chest_admin = true, setspeed = true, kill = true, broadcast = true, minelife_spleef_team = true, pvp_areas_admin = true, rollback = true, licenses = true, minelifeadmin = true, noafk = true, cloaking = true, interact = true, worldedit = true,  shout = true, home = true, msp_admin = true, jobadmin = true,  noclip = true, godmode = true, whois = true, heal = true, train_operator = true, fly = true, top = true, teleport = true, bring = true, areas_high_limit = true, ban = true, chatspam = true, fast = true, canafk = true, travelnet_attach = true, protection_bypass = true, serversay = true, settime = true, gamemode = true, kick = true, areas = true, economy = true, atlatc = true, track_builder = true, adminshop = true, train_admin = true, railway_operator = true, interlocking = true, ticketmaster = true, server = true, give = true, privs = true}
  end

  if licenses_check_player_by_licese(player:get_player_name(), "support") then
    privs = {minelife_chest_admin = true, pvp_areas_admin = true, minelifeadmin = true, minelife_spleef_team = true, noafk = true, cloaking = true, interact = true, shout = true, home = true, msp_admin = true, jobadmin = true,  noclip = true, godmode = true, whois = true, heal = true, train_operator = true, fly = true, top = true, teleport = true, bring = true, areas_high_limit = true, ban = true, chatspam = true, fast = true, canafk = true, travelnet_attach = true, protection_bypass = true, serversay = true, settime = true, gamemode = true, kick = true, areas = true, economy = true, atlatc = true, track_builder = true, adminshop = true, train_admin = true, railway_operator = true, interlocking = true, ticketmaster = true, server = true, give = true, privs = true}
  end
  
  if licenses_check_player_by_licese(player:get_player_name(), "worldedit") then
    privs.worldedit = true
  end

  -- User License
  if licenses_check_player_by_licese(player:get_player_name(), "playerlicense") then
    privs = {interact = true, shout = true}
  end
  
  if licenses_check_player_by_licese(player:get_player_name(), "news") then
    privs.news_bypass = true
  end

  minetest.set_player_privs(player:get_player_name(), privs)
end)


