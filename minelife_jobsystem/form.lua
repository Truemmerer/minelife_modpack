local form_prefix = "jobform:"
local jobname = "freelancer"

local function get_formspec(form,playername)

    local jobhours = "01"
    local jobminutes = "02"
    local jobseconds = "13"

    local pmeta = minetest.get_player_by_name(playername):get_meta()
      local aqtime = pmeta:get_int("job:aqtime")
      if  aqtime == nil then
        aqtime = 0
      end
    local jobname = pmeta:get_string("job:job")
      if jobname == nil or jobname == "" then
        jobname = "freelancer"
      end
    local joblevel = pmeta:get_int("job:level")
      if joblevel == nil then
        joblevel = 0
      end

    local time1 = minetest.get_gametime() - aqtime
    local secondsToJob = minelife_jobsystem.COOLDOWN_IN_SECONDS - time1

    if secondsToJob <= 0 then
      secondsToJob = 0
      jobhours = "00"
      jobminutes = "00"
      jobseconds = "00"
      --minetest.chat_send_player(playername, colorize("#1 ERROR - SECONDS = 0 pls write a Ticket with /ticket!"))      
    else
      jobhours = string.format("%02.f", math.floor(secondsToJob/3600));
      jobminutes = string.format("%02.f", math.floor(secondsToJob/60 - (jobhours*60)));
      jobseconds = string.format("%02.f", math.floor(secondsToJob - jobhours*3600 - jobminutes *60));
    end

    if form == "status" then
		return "size[5,9]\n"..
                "image[0,0;1,1;jobsicon.png]".. 
                "button_exit[4.5,0;0.5,0.5;close;X]"..
                "background[0,0;0.5,0.5;minelife_chest_background.png;true]"..
                
                -- Job Wahl
                "label[1.8,2;Change you Job:]"..
                "button[1.6,2.5;2,1;builder;Builder]"..
                "button[1.6,3.65;2,1;farmer;Farmer]"..
                "button[1.6,4.8;2,1;hunter;Hunter]"..
                "button[1.6,5.95;2,1;miner;Miner]"..

                -- Status
                "label[0,1;Current job: "..jobname.."]"..
                "label[0,1.5;Level: " .. joblevel .. "]"..
                
                -- Timer

                "label[0,8.5;You can change your job in " .. jobhours .. " Hours " .. jobminutes .. " Minutes " .. jobseconds .. " Seconds]"
                
	end
    
end

local function showForm(playername, form) 
	minetest.after(0.1, minetest.show_formspec, playername, form_prefix..form, get_formspec(form,playername))
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
    local playername = player:get_player_name()
  
    local pmeta = minetest.get_player_by_name(playername):get_meta()
      local aqtime = pmeta:get_int("job:aqtime")
      if  aqtime == nil then
        aqtime = 0
      end

   -- minetest.chat_send_player(playername, "Player submitted fields "..dump(fields))    -- DEBUG COMMAND
  if formname == (form_prefix .. "status") then

    if fields["builder"] then
      jobname = "builder"
      minelife_jobsystem.jobjoin(playername, jobname)
      showForm(playername, "status")
    elseif fields["miner"] then
      jobname = "miner"
      minelife_jobsystem.jobjoin(playername, jobname)     
      showForm(playername, "status")
    elseif fields["farmer"] then
      jobname = "farmer"
      minelife_jobsystem.jobjoin(playername, jobname)
      showForm(playername, "status")
    elseif fields["hunter"] then
      jobname = "hunter"
      minelife_jobsystem.jobjoin(playername, jobname)
      showForm(playername, "status")
    end
  end
end)

minetest.register_chatcommand("job_screen", {
    privs = {
    },
    func = function(name, param)
		showForm(name, "status")
    end
})

-- sfinv_buttons

local jobscreen_button_action = function(player)
	local name = player:get_player_name()
	showForm(name, "status")
end

if minetest.get_modpath("sfinv_buttons") ~= nil then
        sfinv_buttons.register_button("jobscreen", {
                image = "jobsicon.png",
                tooltip = ("Change your Job and see your Job Status"),
                title = ("Jobs"), 
                action = jobscreen_button_action,
    })
end
