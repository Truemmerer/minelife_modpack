local money_hud = {}

minetest.register_on_joinplayer(function(player)
    money_hud[player] = player:hud_add({
        hud_elem_type = "text",
        name = "Money",
        number = 0xFFFFFF,
        position = {x=1, y=1},
        offset = {x=-15, y=-40},
        text = "Bank account: ",
        scale = {x=200, y=60},
        alignment = {x=-1, y=-1},
    })

    local player_name = player:get_player_name()
    local money = "Bank account: "..jeans_economy.get_account(player_name) .." MG"    
    player:hud_change(money_hud[player] , "text", money)

end)

minetest.register_on_leaveplayer(function(player)
    money_hud[player:get_player_name()] = nil
end)

function minelife_server_tools.hud_money_update(player, money)

    if money_hud[player] == nil or money == nil then
        return false
    end
    local money_text = "Bank account: "..money.." MG"
    player:hud_change(money_hud[player] , "text", money_text)

end