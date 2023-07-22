--Chat colors
local colors = {
  ["0"] = "#ff0000", -- red
  ["1"] = "#ff5500", -- orange
  ["2"] = "#0000ff", -- blue
  ["3"] = "#00ff00", -- green
  ["4"] = "#ffff00", -- yellow 
}


function get_escape(color)
return minetest.get_color_escape_sequence(colors[string.upper(color)] or "#FFFFFF")
end

function colorize(text)
return string.gsub(text,"#([01234])",get_escape)
end

-- end of color


-- For jobadmin you need the priv "jobadmin"

minelife_jobsystem = {}

-- Add here job:
minelife_jobsystem.joblist = {"miner", "farmer", "builder", "hunter"}

for i, job in pairs(minelife_jobsystem.joblist) do
  licenses_add(job)
end

local modpath = minetest.get_modpath(minetest.get_current_modname())
dofile(modpath.."/config.lua")
dofile(modpath.."/form.lua")
dofile(modpath.."/commands.lua")
dofile(modpath.."/function.lua")
dofile(modpath.."/give_money.lua")
dofile(modpath.."/tool.lua")


--------------------------------
  --- JOB CHANGE FUNCTION
--------------------------------

function minelife_jobsystem.jobjoin(playername, jobname)
  local pmeta = minetest.get_player_by_name(playername):get_meta()
  local aqtime = pmeta:get_int("job:aqtime")
    if  aqtime == nil then
      aqtime = 0
    end
  
    if minetest.get_gametime() - aqtime < minelife_jobsystem.COOLDOWN_IN_SECONDS then
      minetest.chat_send_player(playername, colorize("#0 You can only change your job every " .. minelife_jobsystem.COOLDOWN_IN_SECONDS .. " seconds!"))
      return false

    else
   
    for i = 0, 10 do
      if minelife_jobsystem.joblist[i] ~= nil and minelife_jobsystem.joblist[i] == jobname then
        for z = 0, 10 do 
          if minelife_jobsystem.joblist[z] ~= nil then
            licenses_unassign(playername, minelife_jobsystem.joblist[z])
          end
        end
        licenses_assign(playername, jobname)
        minetest.chat_send_player(playername, colorize("#3 You are now a " ..jobname))
        minetest.log("action", playername.." acquires the job" .. jobname)
  
        aqtime = minetest.get_gametime()
        pmeta:set_int("job:aqtime", aqtime)
        pmeta:set_string("job:job", jobname)
        pmeta:set_int("job:level", "1")        

        return
      end
    end
    return true
  end
end


-- THIS IS A DEVELOP FUNCTION:
function minelife_jobsystem.joinfreelancer(playername)
  licenses_unassign(playername, "farmer")
  licenses_unassign(playername, "miner")
  licenses_unassign(playername, "builder")
  licenses_unassign(playername, "hunter")
  
  local pmeta = minetest.get_player_by_name(playername):get_meta()
  local aqtime = pmeta:get_int("job:aqtime")
  if  aqtime == nil then
    aqtime = 0
  end

  pmeta:set_int("job:aqtime", aqtime) 
  pmeta:set_string("job:job", "freelancer")
  pmeta:set_int("job:level", "0")

  minetest.chat_send_player(playername, colorize("#1 You are now a Freelancer!"))
end