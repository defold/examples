-- Properties - 2 atlases:
go.property("particles_atlas", resource.atlas("/assets/particles.atlas"))
go.property("sprites_atlas", resource.atlas("/assets/sprites.atlas"))

-- Properties - 2 materials:
go.property("default_material", resource.material("/builtins/materials/particlefx.material"))
go.property("glow_material", resource.material("/example/particlefx_glow.material"))

-- Predefined table with animations for given atlases:
-- (One can get the animations from resource.get_atlas() too)
local ANIMATIONS = {
	["particles_atlas"] = { hash("coin"), hash("smoke") },
	["sprites_atlas"] = { hash("ship_red"), hash("ship_dark") }
}

-- Relative address of the particlefx component:
local PARTICLEFX = "#particles"

-- Read the current emitter properties back from the particlefx component
-- and show them in the on-screen labels.
local function get_and_print_emitter_properties(emitter, url)
	-- Get the properties of the emitter:
	local image = go.get(PARTICLEFX, "image", { keys = { emitter } })
	local animation = go.get(PARTICLEFX, "animation", { keys = { emitter } })
	local material = go.get(PARTICLEFX, "material", { keys = { emitter } })

	-- Show the properties in the label:
	label.set_text(url, emitter .. ":\nimage: " .. image
		.. "\nanimation: " .. animation .. "\nmaterial: " .. material )
end

-- Apply one full property set to a single emitter.
local function set_emitter_properties(emitter, image, animation, material)
	go.set(PARTICLEFX, "image", image, { keys = { emitter } })
	go.set(PARTICLEFX, "animation", animation, { keys = { emitter } })
	go.set(PARTICLEFX, "material", material, { keys = { emitter } })
end

-- Toggle between the two hardcoded setups:
-- particles atlas + glow material, or sprites atlas + default material.
local function change_particlefx_properties(self)
	-- Stop the particlefx before swapping atlas/material overrides.
	particlefx.stop(PARTICLEFX, { clear = true })

	-- Swap the atlas name and material:
	if self.atlas_name == "sprites_atlas" then
		self.atlas_name = "particles_atlas"
		self.material = self.glow_material
	else
		self.atlas_name = "sprites_atlas"
		self.material = self.default_material
	end

	-- Get current atlas resource and animations set for it:
	local atlas = self[self.atlas_name]
	local animations = ANIMATIONS[self.atlas_name]

	-- Set the atlas, animation and material for each emitter:
	set_emitter_properties("emitter_top", atlas, animations[1], self.material)
	set_emitter_properties("emitter_bottom", atlas, animations[2], self.material)

	-- Get the current properties and print them in the label for each emitter:
	get_and_print_emitter_properties("emitter_top", "#label_core")
	get_and_print_emitter_properties("emitter_bottom", "#label_spark")

	-- Play the particlefx again:
	particlefx.play(PARTICLEFX)
end

function init(self)
	-- Acquire input focus to react to the mouse click/touch:
	msg.post(".", "acquire_input_focus")

	-- Initialize the atlas name:
	self.atlas_name = "sprites_atlas"
	self.material = self.default_material

	-- Get the current properties and print them in the label for each emitter:
	get_and_print_emitter_properties("emitter_top", "#label_core")
	get_and_print_emitter_properties("emitter_bottom", "#label_spark")

	-- Start the ParticleFX:
	particlefx.play(PARTICLEFX)
end

function on_input(self, action_id, action)
	-- Toggle the setup on touch release:
	if action_id == hash("touch") and action.released then
		change_particlefx_properties(self)
	end
end
