local colors = {
    ["0"] = "#55ffff", -- Builder
    ["1"] = "#61300A", -- 
    ["2"] = "#00AA00", -- Farmer
    ["3"] = "#FFFFFF",
    ["4"] = "#ffaa00", -- Team
    ["5"] = "#00be9e", -- 
    ["6"] = "#AA5500",
    ["7"] = "#AAAAAA", -- Player
    ["8"] = "#555555", -- Miner
    ["9"] = "#717171", -- Language
    ["A"] = "#4d4d4d", 
    ["B"] = "#55FFFF",
    ["C"] = "#FF5555",
    ["D"] = "#248875", -- PlayerName
    ["E"] = "#a7a7a7", -- grau
    ["F"] = "#FFFFFF", -- White
}

local function get_escape(color)
    return minetest.get_color_escape_sequence(colors[string.upper(color)] or "#FFFFFF")
end

local function colorize(text)
    return string.gsub(text,"#([0123456789abcdefABCDEF])",get_escape)
end

minetest.register_on_chat_message(function(name,message)
    if licenses_check_player_by_licese(name, "admin") then
      minetest.chat_send_all(colorize("#4[Team]#D ")..name.." "..colorize("#3")..message)
    elseif licenses_check_player_by_licese(name, "support") then
      minetest.chat_send_all(colorize("#4[Team]#D ")..name.." "..colorize("#f")..message)
    
    elseif licenses_check_player_by_licese(name, "miner") then
      minetest.chat_send_all(colorize("#8[Miner]#D ")..name.." "..colorize("#f")..message)
    elseif licenses_check_player_by_licese(name, "farmer") then
      minetest.chat_send_all(colorize("#2[Farmer]#D ")..name.." "..colorize("#f")..message)
    elseif licenses_check_player_by_licese(name, "builder") then
      minetest.chat_send_all(colorize("#0[Builder]#D ")..name.." "..colorize("#f")..message)
    elseif licenses_check_player_by_licese(name, "hunter") then
      minetest.chat_send_all(colorize("#1[Hunter]#D ")..name.." "..colorize("#f")..message)
    else
      minetest.chat_send_all(colorize("#5[Freelancer]#D ")..name.." "..colorize("#f")..message)
    end

--	local json_msg = minetest.write_json({type = "chat", player = name, message = message})
  --      http_api.fetch({url = feed_url, timeout = receive_interval, post_data = json_msg}, fetch_callback)
	-- publisher.pub_message(name, message)
    return true
end)
