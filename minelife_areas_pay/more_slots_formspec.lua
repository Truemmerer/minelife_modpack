function minelife_areas_pay.areas_pay_more_slots(player)

    local anzahl_slots_now = minelife_server_tools.check_max_areas_of_player(player)
    local player_name = player:get_player_name()

    local price_for_one = minelife_areas_pay.price_for_one_slot
    local price_for_five = minelife_areas_pay.price_for_one_slot * 5
    local price_for_ten = minelife_areas_pay.price_for_one_slot * 10

    minetest.show_formspec(player_name , "more_area_slots", "size[8,1.7]"..
    "label[0,0;Welcome, "..player_name ..", you can buy more Slots for more Plots if you want]" ..
    "label[0,0.5;You currently have "..anzahl_slots_now.." slots for plots]"..
    "button_exit[7.5,0;0.5,0.5;exit;X]"..
    "button[0,1;2.5,1;buy_one_slot;Buy 1 | Price: "..price_for_one.."]"..
    "button[2.75,1;2.5,1;buy_five_slots;Buy 5 | Price: "..price_for_five.."]"..
    "button[5.5,1;2.5,1;buy_ten_slots;Buy 10 | Price: "..price_for_ten.."]")

end