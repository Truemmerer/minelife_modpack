function minelife_server_tools.check_language(name)

    if licenses.check(name, "language-de") then
        return "de"
    elseif licenses.check (name, "language-en") then
        return "en"
    else
        return "unkown"
    end    
end

function minelife_server_tools.check_max_areas_of_player(player)

    local pmeta = player:get_meta()
    local max_player_areas = pmeta:get_int("max_player_areas")

    if max_player_areas == "" or max_player_areas == nil or max_player_areas < 5 then
        max_player_areas = minelife_server_tools.default_min_areas 
    end

    return max_player_areas
    
end

function minelife_server_tools.add_max_area_of_player(player, anzahl)

    if anzahl == nil and anzahl == "" then
        return false
    end

    local pmeta = player:get_meta()
    local max_player_areas = minelife_server_tools.check_max_areas_of_player(player)

    local new_max_areas = max_player_areas + anzahl
    pmeta:set_int("max_player_areas", new_max_areas)
    
    return true
end

function minelife_server_tools.set_max_area_of_player(player, anzahl)
    if anzahl == nil and anzahl == "" then
        return false
    end
    local pmeta = player:get_meta()

    pmeta:set_int("max_player_areas", anzahl)
    
    return true
end