licenses_add("beginnerguide")
licenses_add("firstplot")

minetest.register_on_newplayer(function(player)
    local playername = player:get_player_name()
    jeans_economy_book("!SERVER!", playername, 500, "Welcome to Mine Life!")
    minetest.chat_send_player(playername, colorize("#3 Welcome to Mine Life! You have just been given 500 Minegeld."))
end)

minetest.register_on_newplayer(function(player)
local playername = player:get_player_name()
licenses.assign(playername, "firstplot")
end)

minetest.register_on_newplayer(function(player)
   local playername = player:get_player_name()
   licenses.assign(playername, "news")
   licenses.assign(playername, "beginnerguide")
end)
