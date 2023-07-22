
minelife_jobsystem.builder_nodes = {}
minelife_jobsystem.farmer_nodes = {}
minelife_jobsystem.miner_nodes = {}
minelife_jobsystem.hunter_nodes = {}

--------------------------------------
-- FUNCTION CHECK THE JOB OF PLAYER
--------------------------------------

function minelife_jobsystem.check_job(player_name)

    local jobname
    if licenses_check_player_by_licese(player_name, "miner") then
        jobname = "miner" 
    elseif licenses_check_player_by_licese(player_name, "farmer") then
        jobname = "farmer" 

    elseif licenses_check_player_by_licese(player_name, "builder") then
        jobname = "builder" 

    elseif licenses_check_player_by_licese(player_name, "hunter") then
        jobname = "hunter" 
    else
        jobname = "no"
    end

    return jobname
    
end


--------------------------------------
-- FUNCTION TO ADD A NODE
--------------------------------------

function minelife_jobsystem.add_node(job, amount, node, param2)

    if job == nil or job == "" then
        return false
    end

    if amount == nil or amount == "" then
        return false
    end

    if node == nil or node == "" then
        return false
    end

    if param2 == nil then
        return false
    end

    if job == "miner" then
        
        minelife_jobsystem.miner_nodes[node] = {
            amount = amount,
            param2 = param2,
        }

    elseif job == "farmer" then

        minelife_jobsystem.farmer_nodes[node] = {
            amount = amount,
            param2 = param2,
        }

    elseif job == "builder" then

        minelife_jobsystem.builder_nodes[node] = {
            amount = amount,
            param2 = param2,
        }
    elseif job == "hunter" then

        minelife_jobsystem.hunter_nodes[node] = {
            amount = amount,
            param2 = param2,
        }
    end
    return true


end

--------------------------------------
-- FUNCTION TO REMOVE NODES
--------------------------------------

function minelife_jobsystem.remove_node(job, node)

    local new_joblist = {}

    if job == "miner" then
        
        if minelife_jobsystem.miner_nodes[node] == nil then
            return false
        end

        for listnode in pairs(minelife_jobsystem.miner_nodes) do
            if listnode ~= node then
                if new_joblist[node] then
                    new_joblist[node] = {}
                end
                new_joblist[node] = node
            end
        end 
        minelife_jobsystem.miner_nodes = new_joblist
        return true


    elseif job == "farmer" then

        if minelife_jobsystem.farmer_nodes[node] == nil then
            return false
        end

        for listnode in pairs(minelife_jobsystem.farmer_nodes) do
            if listnode ~= node then
                if new_joblist[node] then
                    new_joblist[node] = {}
                end
                new_joblist[node] = node
            end
        end 
        minelife_jobsystem.farmer_nodes = new_joblist
        return true

    elseif job == "builder" then

        if minelife_jobsystem.builder_nodes[node] == nil then
            return false
        end

        for listnode in pairs(minelife_jobsystem.builder_nodes) do
            if listnode ~= node then
                if new_joblist[node] then
                    new_joblist[node] = {}
                end
                new_joblist[node] = node
            end
        end 
        minelife_jobsystem.builder_nodes = new_joblist
        return true
    elseif job == "hunter" then

        if minelife_jobsystem.hunter_nodes[node] == nil then
            return false
        end

        for listnode in pairs(minelife_jobsystem.hunter_nodes) do
            if listnode ~= node then
                if new_joblist[node] then
                    new_joblist[node] = {}
                end
                new_joblist[node] = node
            end
        end 
        minelife_jobsystem.hunter_nodes = new_joblist
        return true
    end
    return false

end


---------------------------------------
-- FUNCTION TO CHECK AMOUNT OF A BLOCK
---------------------------------------


function minelife_jobsystem.check_amount(job, node)

    local amount = 0
    local param2 = ""
    local param2_need = "false"

    if job == "miner" then
        
        --minetest.chat_send_all(minelife_jobsystem.miner_nodes[node].amount)

        if minelife_jobsystem.miner_nodes[node] ~= nil then
            if minelife_jobsystem.miner_nodes[node].amount ~= nil then
                amount = minelife_jobsystem.miner_nodes[node].amount
            end
            if minelife_jobsystem.miner_nodes[node].param2 ~= nil then
                param2 = minelife_jobsystem.miner_nodes[node].param2
            end
            if minelife_jobsystem.miner_nodes[node].param2_need ~= nil then
                param2_need = minelife_jobsystem.miner_nodes[node].param2_need
            end
        end

    elseif job == "farmer" then

        if minelife_jobsystem.farmer_nodes[node] ~= nil then
            if minelife_jobsystem.farmer_nodes[node].amount ~= nil then
                amount = minelife_jobsystem.farmer_nodes[node].amount
            end
            if minelife_jobsystem.farmer_nodes[node].param2 ~= nil then
                param2 = minelife_jobsystem.farmer_nodes[node].param2
            end
            if minelife_jobsystem.farmer_nodes[node].param2_need ~= nil then
                param2_need = minelife_jobsystem.farmer_nodes[node].param2_need
            end
        end

    elseif job == "builder" then

        if minelife_jobsystem.builder_nodes[node] ~= nil then
            if minelife_jobsystem.builder_nodes[node].amount ~= nil then
                amount = minelife_jobsystem.builder_nodes[node].amount
            end
            if minelife_jobsystem.builder_nodes[node].param2 ~= nil then
                param2 = minelife_jobsystem.builder_nodes[node].param2
            end
            if minelife_jobsystem.builder_nodes[node].param2_need ~= nil then
                param2_need = minelife_jobsystem.builder_nodes[node].param2_need
            end
        end

    elseif job == "hunter" then

        if minelife_jobsystem.hunter_nodes[node] ~= nil then
            if minelife_jobsystem.hunter_nodes[node].amount ~= nil then
                amount = minelife_jobsystem.hunter_nodes[node].amount
            end
            if minelife_jobsystem.hunter_nodes[node].param2 ~= nil then
                param2 = minelife_jobsystem.hunter_nodes[node].param2
            end
            if minelife_jobsystem.hunter_nodes[node].param2_need ~= nil then
                param2_need = minelife_jobsystem.hunter_nodes[node].param2_need
            end
        end
    end

    return amount, param2, param2_need
    

end



--------------------------------------
-- FUNCTION TO SAVE JOB NODES
--------------------------------------

local save_path = minetest.get_worldpath().."/minelife_jobsystem"


function minelife_jobsystem.save_jobs()

    minetest.mkdir(save_path) -- legt den save_path an, sollte dieser noch nicht existieren.

    local miner_save = 1
    local farmer_save = 1
    local builder_save = 1
    local hunter_save = 1

    local miner_file = io.open(save_path.."/miner.json", "w")
	if miner_file then
		miner_file:write(minetest.serialize(minelife_jobsystem.miner_nodes))
		miner_file:close()
		minetest.log("info", "[minelife_jobsystem]: miner_nodes saved")

	else
		minetest.log("error", "[minelife_jobsystem]: Can't save miner_nodes")
        miner_save = 0
    end

    local farmer_file = io.open(save_path.."/farmer.json", "w")
	if farmer_file then
		farmer_file:write(minetest.serialize(minelife_jobsystem.farmer_nodes))
		farmer_file:close()
		minetest.log("info", "[minelife_jobsystem]: farmer_nodes saved")

	else
		minetest.log("error", "[minelife_jobsystem]: Can't save farmer_nodes")
        farmer_save = 0
    end

    local builder_nodes = io.open(save_path.."/builder.json", "w")
	if builder_nodes then
		builder_nodes:write(minetest.serialize(minelife_jobsystem.builder_nodes))
		builder_nodes:close()
		minetest.log("info", "[minelife_jobsystem]: builder_nodes saved")

	else
		minetest.log("error", "[minelife_jobsystem]: Can't save builder_nodes")
        builder_save = 0
    end

    local hunter_nodes = io.open(save_path.."/hunter.json", "w")
	if hunter_nodes then
		hunter_nodes:write(minetest.serialize(minelife_jobsystem.hunter_nodes))
		hunter_nodes:close()
		minetest.log("info", "[minelife_jobsystem]: hunter_nodes saved")

	else
		minetest.log("error", "[minelife_jobsystem]: Can't save hunter_nodes")
        hunter_save = 0
	end

    return miner_save, farmer_save, builder_save, hunter_save


end


--------------------------------------
--------------------------------------
-- NO API FUNCTIONS:
--------------------------------------
--------------------------------------

--------------------------------------
-- FUNCTIONS OPEN THE SAVES LISTS
--------------------------------------

local miner_file = io.open(save_path.."/miner.json", "r")
if miner_file then
		local table = minetest.deserialize(miner_file:read("*all"))
		if type(table) == "table" then
			minelife_jobsystem.miner_nodes = table
		else
			minetest.log("error", "[minelife_jobsystem]: Corrupted miner_file")
		end
		miner_file:close()
end

local farmer_file = io.open(save_path.."/farmer.json", "r")
if farmer_file then
		local table = minetest.deserialize(farmer_file:read("*all"))
		if type(table) == "table" then
			minelife_jobsystem.farmer_nodes = table
		else
			minetest.log("error", "[minelife_jobsystem]: Corrupted farmer_file")
		end
		farmer_file:close()
end

local builder_file = io.open(save_path.."/builder.json", "r")
if builder_file then
		local table = minetest.deserialize(builder_file:read("*all"))
		if type(table) == "table" then
			minelife_jobsystem.builder_nodes = table
		else
			minetest.log("error", "[minelife_jobsystem]: Corrupted builder_file")
		end
		builder_file:close()
end

local hunter_file = io.open(save_path.."/list_areas.txt", "r")
if hunter_file then
		local table = minetest.deserialize(hunter_file:read("*all"))
		if type(table) == "table" then
			minelife_jobsystem.hunter_nodes = table
		else
			minetest.log("error", "[minelife_jobsystem]: Corrupted hunter_file")
		end
		hunter_file:close()
end
