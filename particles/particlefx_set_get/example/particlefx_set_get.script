-- Properties - 2 atlases:
go.property("particles_atlas", resource.atlas("/assets/particles.atlas"))
go.property("sprites_atlas", resource.atlas("/assets/sprites.atlas"))

-- Properties - 2 materials:
go.property("default_material", resource.material("/builtins/materials/particlefx.material"))
go.property("glow_material", resource.material("/example/particlefx_glow.material"))

-- Address of the particlefx component:
local PARTICLEFX = "#particles"

-- The example only switches between two simple atlas setups,
-- so each atlas gets one animation per emitter.
local ANIMATIONS = {
	["particles_atlas"] = { hash("coin"), hash("smoke") },
	["sprites_atlas"] = { hash("ship_red"), hash("ship_dark") }
}

-- Read the current emitter properties back from the particlefx component
-- and show them in the on-screen labels.
local function get_emitter_properties(emitter, url)
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
	particlefx.stop(PARTICLEFX)

	local core_animation = ANIMATIONS["particles_atlas"][1]
	local spark_animation = ANIMATIONS["particles_atlas"][2]

	if self.atlas == self.particles_atlas then
		self.atlas = self.sprites_atlas
		self.material = self.default_material
		core_animation = ANIMATIONS["sprites_atlas"][1]
		spark_animation = ANIMATIONS["sprites_atlas"][2]
	else
		self.atlas = self.particles_atlas
		self.material = self.glow_material
	end

	pprint(core_animation, spark_animation, self.atlas, self.material)

	-- Both emitters use the same atlas/material for a given setup,
	-- but each emitter gets its own animation.
	set_emitter_properties("emitter_top", self.atlas, core_animation, self.material)
	set_emitter_properties("emitter_bottom", self.atlas, spark_animation, self.material)

	get_emitter_properties("emitter_top", "#label_core")
	get_emitter_properties("emitter_bottom", "#label_spark")

	particlefx.play(PARTICLEFX)
end

function init(self)
	msg.post(".", "acquire_input_focus")

	-- Start with sprites/default so the first click flips to particles/glow.
	self.atlas = self.sprites_atlas
	self.material = self.default_material

	change_particlefx_properties(self)
end

function on_input(self, action_id, action)
	-- Toggle the setup on touch release.
	if action_id == hash("touch") and action.released then
		change_particlefx_properties(self)
	end
end
