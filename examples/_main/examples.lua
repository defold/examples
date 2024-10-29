local M = {}

local examples = {}

examples["basics"] = { "message_passing", "parent_child", "z_order" }
examples["factory"] = { "basic", "bullets", "dynamic" }
examples["movement"] = { "simple_move", "follow", "move_to", "move_forward", "movement_speed", "look_at", "look_rotation" }
examples["physics"] = { "dynamic", "kinematic", "raycast", "trigger", "hinge_joint", "pendulum", "knockback"}
examples["animation"] = { "euler_rotation", "spinner", "flipbook", "chained_tween", "basic_tween", "spine", "cursor", "easing" }
examples["gui"] = {
	"button", "stencil", "load_texture",
	"progress", "pointer_over", "color",
	"slice9", "drag", "layouts",
	"get_set_font", "get_set_texture", "get_set_material",
	"healthbar"
}
examples["input"] = { "move", "text", "down_duration", "mouse_and_touch" }
examples["material"] = { "vertexcolor", { name = "unlit", nobg = true }, "uvgradient", "noise", { name = "screenspace", nobg = true } }
examples["particles"] = { "confetti", "particlefx", "modifiers", "fire_and_smoke", "fireworks" }
examples["sound"] = { "music", "fade_in_out", "panning" }
examples["render"] = { "camera", { name = "orbit_camera", nobg = true }, "screen_to_world" }
examples["debug"] = { "physics", "profile" }
examples["collection"] = { "proxy", "splash", "timestep" }
examples["sprite"] = { "size", "tint", "flip", "bunnymark" }
examples["file"] = { "sys_save_load" }
examples["tilemap"] = { "collisions", "get_set_tile" }
examples["timer"] = { "repeating_timer", "trigger_timer", "cancel_timer" }
examples["resource"] = { "modify_atlas" }

local categories = {}
for category,_ in pairs(examples) do
	categories[#categories + 1] = category
end
table.sort(categories)

for category,examples_in_category in pairs(examples) do
	for id,example in pairs(examples_in_category) do
		if type(example) == "string" then
			examples_in_category[id] = { name = example, nobg = false }
		end
	end
end

local examples_lookup = {}
for category,examples_in_category in pairs(examples) do
	for id,example in pairs(examples_in_category) do
		examples_lookup[category .. "/" .. example.name] = example
	end
end

function M.categories()
	return categories
end

function M.category(category)
	return examples[category]
end

function M.example(example)
	return examples_lookup[example]
end



return M