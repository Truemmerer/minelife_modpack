minelife_spleef_game.registerd_game_areas = {}
local save_path = minetest.get_worldpath().."/minelife_spleef_game"

--------------------------------------
--------------------------------------
-- API FUNCTIONS:
--------------------------------------
--------------------------------------


--------------------------------------
-- FUNCTION TO CHECK IF AREA EXISTS
--------------------------------------

function minelife_spleef_game.check_if_exists(area_name)

	if minelife_spleef_game.registerd_game_areas[area_name] then
		return true
	else
		return false
	end
end

--------------------------------------
-- FUNCTION TO REMOVE GAME AREA
--------------------------------------

function minelife_spleef_game.remove_game_area(area_name)

	if not minelife_spleef_game.check_if_exists(area_name) == true then
		return false
	end

	local new_area_list = {}
	for area in pairs(minelife_spleef_game.registerd_game_areas) do
		if area ~= area_name then
			if not new_area_list[area_name] then
				new_area_list[area_name] = {}
			end
			new_area_list[area_name] = area_name
		end
	end 
	minelife_spleef_game.registerd_game_areas = new_area_list

	if minelife_spleef_game.save_area_list() ~= true then
		return false
	end

	minetest.log("info", "[minelife_spleef_game]: Remove "..area_name.." in area file")
	
	local area_file = save_path.."/"..area_name..".txt"
	os.remove(area_file)
	return true

end

--------------------------------------
-- FUNCTION TO RESTORE GAME AREA
--------------------------------------

function minelife_spleef_game.restore_game_area(area_name)
	if minelife_spleef_game.check_if_exists(area_name) == true then
		local area_file = io.open(save_path.."/"..area_name..".txt", "r")
		local currentArea = {}

		if area_file then
			currentArea = minetest.deserialize(area_file:read("*all"))
		
			if currentArea == nil then
				minetest.log("error", "[minelife_spleef_game]: Area table is nil")
				return false
			end
			

    		for variable, pos_id in pairs (currentArea) do
                minetest.set_node(pos_id.pos, {name=pos_id.node_name})
				local node_meta = minetest.get_meta(pos_id.pos)
                node_meta:set_int("spleef", 1)
            end

			minetest.log("info", "Restore area: " ..area_name )
			return true
			
		end
	end
	return false
end


--------------------------------------
-- FUNCTION CHECK PLAYER PRIV
--------------------------------------

function minelife_spleef_game.check_priv(player_name)

	if minetest.check_player_privs(player_name, {creative=true}) == true then
		return true
 
	else
		return false
 
	end
 
 end

--------------------------------------
-- FUNCTION TO SAVE AREA
--------------------------------------

function minelife_spleef_game.save_area(area_name, current_table)
	
	minetest.mkdir(save_path) -- erstelle Speicherpfad, sollte dieser noch nicht existieren

	local file = io.open(save_path.."/"..area_name..".txt", "w")
	if file then
		file:write(current_table)
		file:close()
		minetest.log("info", "[minelife_spleef_game]: File with Spleefarea informations for following area created: "..area_name)
	else
		minetest.log("error", "[minelife_spleef_game]: Can't save "..area_name)
		return false
	end

	if not minelife_spleef_game.registerd_game_areas[area_name] then
		minelife_spleef_game.registerd_game_areas[area_name] = {}
	end

	minelife_spleef_game.registerd_game_areas[area_name] = area_name
	
	if minelife_spleef_game.save_area_list() == true then
		minetest.log("info", "[minelife_spleef_game]: Area File with following new area updated: "..area_name)
		return true
	else
		minetest.log("error", "[minelife_spleef_game]: By saving the new area not minelife_spleef_game.save_area_list == true")

	end
end


--------------------------------------
-- FUNCTION TO SAVE AREA LIST
--------------------------------------

function minelife_spleef_game.save_area_list()

	local area_file = io.open(save_path.."/list_areas.txt", "w")
	if area_file then
		area_file:write(minetest.serialize(minelife_spleef_game.registerd_game_areas))
		area_file:close()
		minetest.log("info", "[minelife_spleef_game]: Area File saved")
		return true
	else
		minetest.log("error", "[minelife_spleef_game]: Can't save Area File")
		return false
	end
end

--------------------------------------
--------------------------------------
-- NO API FUNCTIONS:
--------------------------------------
--------------------------------------

--------------------------------------
-- FUNCTION OPEN THE SAVES AREA
--------------------------------------
local file = io.open(save_path.."/list_areas.txt", "r")
if file then
		local table = minetest.deserialize(file:read("*all"))
		if type(table) == "table" then
			minelife_spleef_game.registerd_game_areas = table
		else
			minetest.log("error", "[minelife_spleef_game]: Corrupted list_areas file")
		end
		file:close()
end

--------------------------------------
-- FUNCTION IF PLAYER LEAVE MT
--------------------------------------

minetest.register_on_leaveplayer(function(player)

        local meta = player:get_meta()
        meta:set_string("spleef_area_name", "")
        meta:set_int("spleef_area_pos_id", 0)
		meta:set_string("currentArea", "")

end)