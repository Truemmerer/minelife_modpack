local cpl = 70
local cpl_wide = 105

local function make_node_boxes(sx, sy)

	return {
		type = "wallmounted",
		wall_side =   { -0.43 , -sy, -sx, -0.43, sy, sx },
		wall_top =    { -sx, 0.43, -sy, sx, 0.43, sy},
		wall_bottom = { -sx, -0.43, -sy, sx, -0.43, sy }
	}
end

signs_lib.register_sign("holograms:hologram", {
	description = "Hologram",
	tiles = {"holograms_hologram.png", "holograms_hologram.png"},
	inventory_image = "holograms_item.png",
	wield_image = "holograms_item.png",
	default_color = "f",
	use_texture_alpha = true,
	font_size = 32,
	locked = true,
	walkable = false,
	drawtype = "nodebox",
	node_box = make_node_boxes(1.41, 0.29),
	entity_info = {
		mesh = "holograms_entity.obj",
		yaw = signs_lib.wallmounted_yaw
	},
	chars_per_line = cpl,
	allow_widefont = true,
	allow_hanging = false,
	allow_onpole = false,
	allow_onpole_horizontal = false,
	allow_yard = false,
})
signs_lib.register_sign("holograms:hologram_wide", {
	description = "Hologram",
	tiles = {"holograms_hologram.png", "holograms_hologram.png"},
	inventory_image = "holograms_item_wide.png",
	wield_image = "holograms_item_wide.png",
	default_color = "f",
	use_texture_alpha = true,
	font_size = 32,
	locked = true,
	walkable = false,
	drawtype = "nodebox",
	node_box = make_node_boxes(2.41, 0.29),
	entity_info = {
		mesh = "holograms_entity_wide.obj",
		yaw = signs_lib.wallmounted_yaw
	},
	chars_per_line = cpl_wide,
	allow_widefont = true,
	allow_hanging = false,
	allow_onpole = false,
	allow_onpole_horizontal = false,
	allow_yard = false,
})