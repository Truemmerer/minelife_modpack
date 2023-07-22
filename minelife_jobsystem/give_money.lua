--FARMER, MINER
minetest.register_on_dignode(function(pos, node, digger)
    
    local player_name = digger:get_player_name()
    local jobname = minelife_jobsystem.check_job(player_name)
    local nodename = node.name

    if jobname == "" or jobname == "freelancer" or jobname == nil then
        return
    end

    if nodename == "" or nodename == nil then
        return
    end

    local amount = minelife_jobsystem.check_amount(jobname, nodename)
    if amount == 0 then
        return
    end

    local readpos = minetest.pos_to_string(pos)

  --  minetest.chat_send_all(amount)
    if amount == 0 or amount == nil or amount == "" then
        return
    end
    jeans_economy_book("!SERVER!", player_name, amount, "Payout for: "..nodename.." at pos: "..readpos)

end)

-- BUILDER
minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
    if licenses_check_player_by_licese(placer:get_player_name(), "builder") then
        local readpos = minetest.pos_to_string(pos)
        local player_name = placer:get_player_name()
        local jobname = "builder"
        local node_name = newnode.name
        local amount = minelife_jobsystem.check_amount(jobname, node_name)
        if amount == 0 or amount == nil or amount == "" then
            return
        end
        jeans_economy_book("!SERVER!", player_name, amount, "Payout for: "..node_name.." at pos: "..readpos)

    end
end)

  -- Hunter
function minelife_jobsystem.check_hunt(player_name, entinity)

    if licenses_check_player_by_licese(player_name, "hunter") then
        local jobname = "hunter"
        local amount = minelife_jobsystem.check_amount(jobname, entinity)
        if amount == 0 or amount == nil or amount == "" then
            return
        end
        jeans_economy_book("!SERVER!", player_name, amount, "Payout for kill: "..entinity)
    end


end
