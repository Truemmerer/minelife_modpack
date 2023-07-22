--------------------------------------------------------------------------------
-- User Command for Job:
--------------------------------------------------------------------------------

minetest.register_chatcommand("job", {
    privs = {
        interact = true,
    },
    params = "<jobname_command>",
    description = "Handles your current job.\n"..
    "To acquire a Job:"..
    "\n /job <job_name>" ..
    "\n <---->" ..
    "\nAvaible jobs:"..
    -- Add here job:
    "\n miner, farmer, builder, hunter",
  
    func = function(player, param)
      --local jobname_command = param:match('^(%S+)%s(.+)$')
      local jobname_command = param
  
      if jobname_command == "" or jobname_command == nil then
        minetest.chat_send_player(player, colorize("#1 You need to specify a job!"))
        minetest.chat_send_player(player, colorize("#1 Avaible Jobs:"))
        for i = 1, 10 do
          if minelife_jobsystem.joblist[i] == nil then
            return
          else 
            minetest.chat_send_player(player, colorize("#1- " .. minelife_jobsystem.joblist[i]))
          end
        end
      else
        minelife_jobsystem.jobjoin(player, jobname_command)
      end
  
   end
  
  })
  
  minetest.register_chatcommand("job_amount", {
    description = "Information about amount",
    params = "<job> <node_name>",

    
    func = function(name, param)
        local job, node = string.match(param, "(%S+) (%S+)")

        local amount = minelife_jobsystem.check_amount(job, node) 

        minetest.chat_send_all(amount)

    end

  })

  --------------------------------------------------------------------------------
  -- Admin Commands:
  --------------------------------------------------------------------------------
  
  -- Register the jobadmin command priv
  
    minetest.register_privilege("jobadmin", {
    description = "Admin can change the Job for Users",
    give_to_singleplayer = false,
    give_to_admin = true,
  })
  
  minetest.register_chatcommand("job_cooldown", {
  
  -- command
    privs = {
        jobadmin = true,
    },
    params = "<player> yes",
    description = "Handles Players current job_cooldown",

    func = function(admin, param)
      local player_name, cooldown = string.match(param, "(%S+) (%S+)")
      

      if cooldown == "yes" and player_name ~= "" and player_name ~= nil then
        local player = minetest.get_player_by_name(player_name)
        local pmeta = player:get_meta()

        pmeta:set_int("job:aqtime", 0)

        minetest.chat_send_player(admin, colorize("#3 Cooldown reset"))
        minetest.chat_send_player(player_name, colorize("#3 You can change your job again now"))
        return true
      else
        return false
      end
    end
  })


  minetest.register_chatcommand("job_save", {
    privs = {
        jobadmin = true,
    },
    params = "<job>",
    description = "Save the jobs in a file",
    
    func = function (name)
        
        local miner, farmer, builder, hunter = minelife_jobsystem.save_jobs()
        local saved_files = miner + farmer + builder + hunter 

        minetest.chat_send_player(name, colorize("#3Job files saved: "..saved_files))


    end

  })



  
  --------------------------------------------------------------------------------
  -- CommandBlock Command for Job:
  --------------------------------------------------------------------------------
  
  minetest.register_chatcommand("jobcb", {
  
    privs = {
    jobadmin = true,
  },
  params = "<player> <job>",
  description = "Handles Players current job.\n"..
  "To acquire a Player Job:"..
  "\n /jobadmin acquire <player> <job_name>" ..
  "\n <---->" ..
  "\nAvaible jobs:"..
  -- Add here job:
  "\n miner, farmer, builder, hunter"..
  "\n <---->" ..
  "\n Displays Players current job:"..
  "\n /jobadmin info <player>",
  func = function(admin, param)
  local player, job = string.match(param, "(%S+) (%S+)")
  
    if player == nil and player == "" then
      return
    end
    if job ~= "" or job ~= nil then
      minelife_jobsystem.jobjoin(player, job)
    end
  end
  
  })