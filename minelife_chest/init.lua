-- Prefix für Funktionen
minelife_chest = {}
minelife_chest.minelife_chests_current_position = {}

-- Lade Einstellungen
dofile(minetest.get_modpath("minelife_chests").."/settings.lua") -- Beinhaltet Einstellungen

-------------------------------------------------------------------------------------------
-- Generiere Farben: werden zur Chatausgabe verwendet
-------------------------------------------------------------------------------------------
colors = {
    ["0"] = "#ff0000", -- red
    ["1"] = "#ff5500", -- orange
    ["2"] = "#0000ff", -- blue
    ["3"] = "#00ff00", -- green
    ["4"] = "#ffff00", -- yellow 
}

function get_escape(color)
  return minetest.get_color_escape_sequence(colors[string.upper(color)] or "#FFFFFF")
end

function colorize(text)
  return string.gsub(text,"#([01234])",get_escape)
end

-------------------------------------------------------------------------------------------
-- Prüfe auf optionale Abhängigkeiten
-------------------------------------------------------------------------------------------
-- Prüfe ob der Areas Mod aktiv ist:
minelife_chest.areas_activated = false

if minetest.get_modpath("areas") and minelife_chest.area_protect == true then
   minelife_chest.areas_activated = true
   minetest.log("info", "[minelife_chest]: loaded with Area Mod functions")
else
   minetest.log("info", "[minelife_chest]: loaded without Area Mod functions")
end

-- Prüfe ob Jeans Economy aktiv ist:
minelife_chest.jeans_economy = false
if minetest.get_modpath("jeans_economy") then
  minelife_chest.jeans_economy = true
  minetest.log("info", "[minelife_chest]: loaded with jeans_economy functions")
else
  minetest.log("info", "[minelife_chest]: loaded without jeans_economy functions")
end

-- Prüfe ob Pipeworks aktiv ist

minelife_chest.Pipeworks = false

if minetest.get_modpath("pipeworks") then
  minelife_chest.Pipeworks = true
  minetest.log("info", "[minelife_chest]: loaded with pipeworks functions")

else
  minetest.log("info", "[minelife_chest]: loaded without pipeworks functions")
end

-------------------------------------------------------------------------------------------
-- Registriere Privilegien
-------------------------------------------------------------------------------------------
-- minelife_chest_admin
minetest.register_privilege("minelife_chest_admin", {
  description ="Access to all Chests",
  give_to_singleplayer = false,
})

-------------------------------------------------------------------------------------------
-- Lade Mod-Lua Files
-------------------------------------------------------------------------------------------
dofile(minetest.get_modpath("minelife_chests").."/formspec.lua") -- Enthält die Grafische Oberfläche
dofile(minetest.get_modpath("minelife_chests").."/formspec_upgrade.lua") -- Upgrade Gui
dofile(minetest.get_modpath("minelife_chests").."/formspec_pipeworks.lua") -- Pipeworks Gui
dofile(minetest.get_modpath("minelife_chests").."/chest.lua") -- Registriert die Chest Node
dofile(minetest.get_modpath("minelife_chests").."/chest_pipeworks.lua") -- Registriert die Pipeworks Chest Node
dofile(minetest.get_modpath("minelife_chests").."/enderchest.lua") -- Registriert die Enderchest Node
dofile(minetest.get_modpath("minelife_chests").."/formspec_enderchest.lua") -- Registriert die Enderchest Gui
dofile(minetest.get_modpath("minelife_chests").."/crafting.lua") -- Registriert Crafting Rezepte
dofile(minetest.get_modpath("minelife_chests").."/functions.lua") -- Beinhaltet alle Funktionen
dofile(minetest.get_modpath("minelife_chests").."/clearchest.lua") -- Tool um Kisten zu leeren und zu entfernen
dofile(minetest.get_modpath("minelife_chests").."/formspec_change_owner.lua") -- GUI um einen Owner zu ändern.

