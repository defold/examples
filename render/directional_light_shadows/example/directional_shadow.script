-- Shadow-map dimensions. Choose a value appropriate for the target hardware.
go.property("resolution", 4096)

-- Fixed PCF kernel width - possible values:
--     1 = one hard depth comparison, no PCF filtering
--     3 = 3x3 PCF kernel, 9 depth comparisons
--     5 = 5x5 PCF kernel, 25 depth comparisons
go.property("pcf_kernel_size", 3)

-- Distance between neighboring PCF samples, measured in shadow-map texels.
-- This changes the filter footprint but not the number of samples.
go.property("pcf_sample_spacing", 1.0)

-- Caster-side polygon offset applied while writing the shadow depth map.
go.property("polygon_offset_factor", 2.0)
go.property("polygon_offset_units", 4.0)

-- Receiver-side depth comparison bias used by the fragment shader.
go.property("receiver_min_bias", 0.0002)
go.property("receiver_slope_bias", 0.0015)

function init(self)
	-- Send a message to the render socket to configure the parameters for shadows:
	msg.post("@render:", "set_directional_shadow", {
		camera = msg.url("#shadow_camera"),
		resolution = self.resolution,
		pcf_kernel_size = self.pcf_kernel_size,
		pcf_sample_spacing = self.pcf_sample_spacing,
		polygon_offset_factor = self.polygon_offset_factor,
		polygon_offset_units = self.polygon_offset_units,
		receiver_min_bias = self.receiver_min_bias,
		receiver_slope_bias = self.receiver_slope_bias,
	})
end
