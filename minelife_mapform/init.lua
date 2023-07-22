local form_prefix = "mapform:"
local old_idx = {}

local mappath = minetest.get_worldpath().."/mapform/"

mapform_data = {}

dofile(minetest.get_modpath("mapform").."/mapdata.lua")

local function get_entry_idx(sb_value)
	return math.floor(sb_value/1000 * (#mapform_data["entries"] - 3) + 0.5)
end

local function is_new_idx(playername, idx)
	if old_idx[playername] then
		return old_idx[playername] ~= idx
	end
	return true
end

local function get_formspec(form, sb_value)
	if form == "overview" then
	
		entry = get_entry_idx(sb_value)
		formspec = "size[18,7]\n"..

		-- Form
			"image[16.15,0.5;2,2;map_icon.png]"..
			"button_exit[16,0;2,0.5;close;Close]"..
			"label[12.5,0;MineLife Maps]".. 
		
			"label[12.5,0.70;The normal maps are updated daily!]".. 
			"label[12.5,1;The train maps are updated as needed.]".. 

			"label[12.5,1.6;You can find a map of the full world]"..
			"label[12.5,1.9;on our homepage:]".. 
			"label[12.5,2.2;https://minelife-minetest.de]".. 

		-- Region Container Open
			"container[0.75,0.25]"..
			"scrollbar[0,0;0.5,6;vertical;mapform_scrollbar;" .. sb_value .. "]"
		
		for i = 1, #mapform_data["entries"], 1 do
			
			local idx = i - entry - 1
			
			if idx >= 0 and idx <= 2 then
			
				formspec = formspec ..
				"container[0.75,".. idx*2 .."]".. 
				"box[0.05,0.05;10,1.75;#626262]"..
				"label[0.25,0.07;Region: ".. mapform_data["entries"][i]["name"] .. "]"
				
				for j = 1, #mapform_data["entries"][i]["buttons"], 1 do
					formspec = formspec .. "button[" .. ((j * 2.25) - 2) .. ",0.25;2.25,2;" .. i .. "_" .. j .. ";" .. mapform_data["entries"][i]["buttons"][j]["name"] .. "]"
				end
				formspec = formspec .. "container_end[]"
			end

		end
		
		
			
		--Region Container Close
		formspec = formspec .. "container_end[]"
			
		return formspec

	-- Unterformen zum Anzeigen der Karten
	elseif form == "map" then
		formspec = "size[15,7]\n"..
		"button[13,0;2,0.5;mapform_back_button;Back]"..
		"box[0,0;2.5,0.5;#626262]"..
		"label[0,0;" .. sb_value["name"] .. "]"
		
		if sb_value["picture"] then
			formspec = formspec .. "background[0,0;15,7;" ..sb_value["picture"] .. ";auto_clip]"
		end
		return formspec

	end
    
end

function showForm(playername, form, sb_value)
	sb_value = sb_value or 1
	minetest.show_formspec(playername, form_prefix..form, get_formspec(form, sb_value))
	--minetest.chat_send_all(mappath)
end
--[[ 
minetest.register_on_joinplayer(function(player)
     local playername = player:get_player_name()
        if licenses_check_player_by_licese(playername, "beginnerguide") then  
			showForm(playername, "mlw-home")
        end        
end)
--]]


minetest.register_on_player_receive_fields(function(player, formname, fields)
    local playername = player:get_player_name()
    --minetest.chat_send_player(playername, "Player submitted fields "..dump(fields))    -- DEBUG COMMAND
	if formname == (form_prefix .. "overview") then
	
		if fields["quit"] then
			return true;
		end
		
		-- Vallee
		for k, v in pairs(mapform_data["buttons"]) do
			if fields[k] then
				showForm(playername, "map", v)
				return true
			end
		end
		
		
		-- Scoolbar
		if fields["mapform_scrollbar"] then
			local scroll = string.split(fields["mapform_scrollbar"], ":")
			if scroll[1] ~= "VAL" and is_new_idx(playername, get_entry_idx(scroll[2])) then
				old_idx[playername] = get_entry_idx(scroll[2])
				showForm(playername, "overview", scroll[2])
			end
		end
		return true
	elseif formname == (form_prefix .. "map") then
		-- Back Button
		if fields["mapform_back_button"] then
			showForm(playername, "overview")
		end
		return true
	end
	return false
end)


minetest.register_chatcommand("maps", {
    privs = {
    },
    func = function(name, param)
		showForm(name, "overview")
    end
})


-- sfinv_buttons

local maps_button_action = function(player)
	local name = player:get_player_name()
	showForm(name, "overview")
end

if minetest.get_modpath("sfinv_buttons") ~= nil then
        sfinv_buttons.register_button("maps", {
                image = "map_icon.png",
                tooltip = ("Show Maps from this Server"),
                title = ("Maps"), 
                action = maps_button_action,
    })
end
