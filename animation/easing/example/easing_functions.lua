local M = {}

M[go.EASING_LINEAR] = { name = "EASING_LINEAR", value = go.EASING_LINEAR, description = "linear interpolation" }
M[go.EASING_INQUAD] = { name = "EASING_INQUAD", value = go.EASING_INQUAD, description = "in-quadratic" }
M[go.EASING_OUTQUAD] = { name = "EASING_OUTQUAD", value = go.EASING_OUTQUAD, description = "out-quadratic" }
M[go.EASING_INOUTQUAD] = { name = "EASING_INOUTQUAD", value = go.EASING_INOUTQUAD, description = "in-out-quadratic" }
M[go.EASING_OUTINQUAD] = { name = "EASING_OUTINQUAD", value = go.EASING_OUTINQUAD, description = "out-in-quadratic" }
M[go.EASING_INCUBIC] = { name = "EASING_INCUBIC", value = go.EASING_INCUBIC, description = "in-cubic" }
M[go.EASING_OUTCUBIC] = { name = "EASING_OUTCUBIC", value = go.EASING_OUTCUBIC, description = "out-cubic" }
M[go.EASING_INOUTCUBIC] = { name = "EASING_INOUTCUBIC", value = go.EASING_INOUTCUBIC, description = "in-out-cubic" }
M[go.EASING_OUTINCUBIC] = { name = "EASING_OUTINCUBIC", value = go.EASING_OUTINCUBIC, description = "out-in-cubic" }
M[go.EASING_INQUART] = { name = "EASING_INQUART", value = go.EASING_INQUART, description = "in-quartic" }
M[go.EASING_OUTQUART] = { name = "EASING_OUTQUART", value = go.EASING_OUTQUART, description = "out-quartic" }
M[go.EASING_INOUTQUART] = { name = "EASING_INOUTQUART", value = go.EASING_INOUTQUART, description = "in-out-quartic" }
M[go.EASING_OUTINQUART] = { name = "EASING_OUTINQUART", value = go.EASING_OUTINQUART, description = "out-in-quartic" }
M[go.EASING_INQUINT] = { name = "EASING_INQUINT", value = go.EASING_INQUINT, description = "in-quintic" }
M[go.EASING_OUTQUINT] = { name = "EASING_OUTQUINT", value = go.EASING_OUTQUINT, description = "out-quintic" }
M[go.EASING_INOUTQUINT] = { name = "EASING_INOUTQUINT", value = go.EASING_INOUTQUINT, description = "in-out-quintic" }
M[go.EASING_OUTINQUINT] = { name = "EASING_OUTINQUINT", value = go.EASING_OUTINQUINT, description = "out-in-quintic" }
M[go.EASING_INSINE] = { name = "EASING_INSINE", value = go.EASING_INSINE, description = "in-sine" }
M[go.EASING_OUTSINE] = { name = "EASING_OUTSINE", value = go.EASING_OUTSINE, description = "out-sine" }
M[go.EASING_INOUTSINE] = { name = "EASING_INOUTSINE", value = go.EASING_INOUTSINE, description = "in-out-sine" }
M[go.EASING_OUTINSINE] = { name = "EASING_OUTINSINE", value = go.EASING_OUTINSINE, description = "out-in-sine" }
M[go.EASING_INEXPO] = { name = "EASING_INEXPO", value = go.EASING_INEXPO, description = "in-exponential" }
M[go.EASING_OUTEXPO] = { name = "EASING_OUTEXPO", value = go.EASING_OUTEXPO, description = "out-exponential" }
M[go.EASING_INOUTEXPO] = { name = "EASING_INOUTEXPO", value = go.EASING_INOUTEXPO, description = "in-out-exponential" }
M[go.EASING_OUTINEXPO] = { name = "EASING_OUTINEXPO", value = go.EASING_OUTINEXPO, description = "out-in-exponential" }
M[go.EASING_INCIRC] = { name = "EASING_INCIRC", value = go.EASING_INCIRC, description = "in-circlic" }
M[go.EASING_OUTCIRC] = { name = "EASING_OUTCIRC", value = go.EASING_OUTCIRC, description = "out-circlic" }
M[go.EASING_INOUTCIRC] = { name = "EASING_INOUTCIRC", value = go.EASING_INOUTCIRC, description = "in-out-circlic" }
M[go.EASING_OUTINCIRC] = { name = "EASING_OUTINCIRC", value = go.EASING_OUTINCIRC, description = "out-in-circlic" }
M[go.EASING_INELASTIC] = { name = "EASING_INELASTIC", value = go.EASING_INELASTIC, description = "in-elastic" }
M[go.EASING_OUTELASTIC] = { name = "EASING_OUTELASTIC", value = go.EASING_OUTELASTIC, description = "out-elastic" }
M[go.EASING_INOUTELASTIC] = { name = "EASING_INOUTELASTIC", value = go.EASING_INOUTELASTIC, description = "in-out-elastic" }
M[go.EASING_OUTINELASTIC] = { name = "EASING_OUTINELASTIC", value = go.EASING_OUTINELASTIC, description = "out-in-elastic" }
M[go.EASING_INBACK] = { name = "EASING_INBACK", value = go.EASING_INBACK, description = "in-back" }
M[go.EASING_OUTBACK] = { name = "EASING_OUTBACK", value = go.EASING_OUTBACK, description = "out-back" }
M[go.EASING_INOUTBACK] = { name = "EASING_INOUTBACK", value = go.EASING_INOUTBACK, description = "in-out-back" }
M[go.EASING_OUTINBACK] = { name = "EASING_OUTINBACK", value = go.EASING_OUTINBACK, description = "out-in-back" }
M[go.EASING_INBOUNCE] = { name = "EASING_INBOUNCE", value = go.EASING_INBOUNCE, description = "in-bounce" }
M[go.EASING_OUTBOUNCE] = { name = "EASING_OUTBOUNCE", value = go.EASING_OUTBOUNCE, description = "out-bounce" }
M[go.EASING_INOUTBOUNCE] = { name = "EASING_INOUTBOUNCE", value = go.EASING_INOUTBOUNCE, description = "in-out-bounce" }
M[go.EASING_OUTINBOUNCE] = { name = "EASING_OUTINBOUNCE", value = go.EASING_OUTINBOUNCE, description = "out-in-bounce" }

function M.get_by_index(index)
	for i, v in ipairs(M) do
		if i == index then
			return v
		end
	end
	return nil
end

return M