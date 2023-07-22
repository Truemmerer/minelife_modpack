-- If you dont want the pink color, comment Line 2 And uncomment Line 3:
textColor = minetest.get_color_escape_sequence("#9022A7")
-- If you want only use one language, then use the second language (ads_table_2) This is the default one
local FIRST_LANGAUGE = "de"
local SECOND_LANGUAGE = "en"
local INTERVAL = 600 -- In Seconds

-- Here you can define your ads. Of course you can define more as three messages. Just duplicat the second line ;)

local ads_table_1 = {"Befehl nicht gefunden oder Fragen ueber verschiedene Funktionen des Servers? -> /wiki hilft weiter!",
  "Dir gefällt der Server? Empfehle ihn doch gerne weiter!",
  "Was würdest du dir wünschen? Schreibe doch ein /ticket Danke!",
  "Fehler/Bug gefunden oder Du hast einen Vorschlag? -> Schreibe doch ein /ticket!",
  "Um Geld fuer zum Beispiel deine eigene Stadt zu verdienen, solltest Du einen Job annehmen, um Items im Adminshop verkaufen zu koennen. Fange noch heute an! -> /job",
  "Besuche gerne unseren Discord-Server und bleibe mit uns in Kontakt -> https://discord.minelife-minetest.de",
  "Fertige Grundstuecke koennen ab einer Abwesenheit von 3 Monaten vom Server enteignet werden. Sichtlich  unfertige/haessliche Grundstuecke koennen schon nach zwei Wochen Abwesenheit enteignet werden",
  "Was gefaellt Dir denn an dem Server nicht so gut? Was ist deiner Meinung nach unnötig? Schreibe einfach mal ein /ticket - Danke",
  "Du willst dich auf das Geld verdienen fokussieren? Sieh im /wiki nach, wie man am besten Geld verdient und wie die Wirtschaft hier funktioniert!",
  "Schön dass Du da bist!",
  "Jeden Monat hat der Adminshop ein Item, was Du für hoehere Preise verkaufen kannst ;)",
  "Mögliche Bugs sind umgehend ueber /ticket dem Team zu melden. Das ausnutzen von Bugs ist nicht gestattet.",
  "Du vermisst etwas im Adminshop? Suche doch die Shops der anderen Spieler im Erdgeschloss des Adminshops auf oder frage sie direkt nach einem Handel!",
  "Schon gewusst? mit /transactions <Zahl> kannst Du deine letzten Einnahmen und Ausgaben sehen.",
  "Mehrere Accounts pro Spieler sind nicht erlaubt. Willst Du eine dafuer eine spezielle Ausnahme erhalten, melde Dich beim Team -> /ticket.",
  "Mit /trains bekommst Du eine Übersicht über alle Zuglinien!",
  "Gestorben? -> /kit hilft Dir!",
  "Unwissenheit schützt nicht vor Strafe! Deshalb lese bitte die Regeln im /wiki nach. Vielen Dank!",
  "Besuche auch unsere Homepage: https://www.minelife-minetest.de/"}

local ads_table_2 = {"Command not found or a question about a feature from the server? -> /wiki will help you",
  "Do you like the server? Recommend the server to your friends!",
  "Any wishes? Just write a /ticket! Thanks!",
  "Found a bug or got an idea/suggestion -> write a /ticket Thanks!",
  "To earn money for e.g. to found your own city, acquire a job for selling the items at the adminshop. Start today! -> /job",
  "Visit our discord-server and stay in touch! -> https://discord.minelife-minetest.de",
  "Finished properties can be expropriated by the server after an absence of 3 months. Visible unfinished/ugly properties can be expropriated after two weeks of absence.",
  "Don't you like a feature or what will be unnessesery to you? Write us a /ticket - Thanks!",
  "Want to focus on earning money? Look at /wiki for how to make the most money and how the economy works on this server!",
  "Nice that you are here!",
  "Every Month the Adminshop has another item which you could sell for a higher price!",
  "Possible bugs has to be reported with /ticket to the team immediately. The exploitation of bugs is not permitted.",
  "Are you missing something in the adminshop? Search the usershops in the groundfloor of the adminshop, or ask the players directly!",
  "Did you already know? With /transactions you can see your last earnings and spendings.",
  "Multiple accounts per player are not allowed. Do you want a special exception, contact the team -> /ticket.",
  "Type /trains to get an overview of all train lines on the server",
  "Died? Type /kit to get basic items!",
  "Ignorance does not protect against punishment, so please read the rules in /wiki. Thanks!",
  "Visit our Homepage: https://www.minelife-minetest.de/"}

local counter = 0
local delta = 0

--[[ Old Configuration with Player Meta Data

-- define language command Command
minetest.register_chatcommand("ads_language", {
    func = function(name, param)
      local player = minetest.get_player_by_name(name)
      local meta = player:get_meta()
      -- Change here the languages of the messages!
      if param == FIRST_LANGAUGE then
        meta:set_string("ads_language", param)
        minetest.chat_send_player(name, "Sprache wurde erfolgreich gesetzt. Nicht alle Inhalte sind aber leider in deutsch!")
      elseif param == SECOND_LANGUAGE then
        meta:set_string("ads_language", param)
        minetest.chat_send_player(name, "Language successfully defined")
      else
        -- Here you can change the "not found" message:
        minetest.chat_send_player(name, "Language not found! Available Languages: de, en")
      end
    end
})

minetest.register_globalstep(function(dtime)
  if delta > INTERVAL then
    counter = counter + 1
    if counter > tablelength(ads_table_2) then
      counter = 1
    end
    -- minetest.chat_send_player("MineBank", counter)
    for _, player in pairs(minetest.get_connected_players()) do
      pmeta = player:get_meta()
      if pmeta:get_string("ads_language") == FIRST_LANGAUGE then
        minetest.chat_send_player(player:get_player_name(), textColor .. ads_table_1[counter])
      else
        minetest.chat_send_player(player:get_player_name(), textColor .. ads_table_2[counter])
      end
    end
    delta = 0
  else
    delta = delta + dtime
  end
end)
--]]

minetest.register_globalstep(function(dtime)
  if delta > INTERVAL then
    counter = counter + 1
    if counter > tablelength(ads_table_2) then
      counter = 1
    end
    -- minetest.chat_send_player("MineBank", counter)
    for _, player in pairs(minetest.get_connected_players()) do
     if licenses_check_player_by_licese(player:get_player_name(), "language-de")  then
        minetest.chat_send_player(player:get_player_name(), textColor .. ads_table_1[counter])
      else
        minetest.chat_send_player(player:get_player_name(), textColor .. ads_table_2[counter])
      end
    end
    delta = 0
  else
    delta = delta + dtime
  end
end)

-- Helper:
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
