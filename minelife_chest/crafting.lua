if minelife_chest.chest_craft == true then
	minetest.register_craft({
		output = "minelife_chests:chest",
		recipe = {
			{"group:wood", "group:wood", "group:wood"},
			{"group:wood", "", "group:wood"},
			{"group:wood", "group:wood", "group:wood"},
		}
	})
end

if minelife_chest.enderchest_craft == true then
	
	minetest.register_craft({
		output = "minelife_chests:enderchest",
		recipe = {
			{"default:obsidian", "default:obsidian", "default:obsidian"},
			{"default:obsidian", "minelife_chests:chest", "default:obsidian"},
			{"default:obsidian", "default:obsidian", "default:obsidian"}
		}
	})
end