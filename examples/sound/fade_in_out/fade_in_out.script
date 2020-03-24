local TIME = 2 -- <1>
local DELAY = 1 -- <2>

function init(self)
    sound.play("#music", { gain = 1.0 }) -- <3>
    msg.post("#", "fade_in_out") -- <4>
end

function on_message(self, message_id, message, sender)
    if message_id == hash("fade_in_out") then
        go.animate("#music", "gain", go.PLAYBACK_LOOP_PINGPONG, 0, go.EASING_LINEAR, TIME, DELAY) -- <5>
    end
end


--[[
1. Create TIME constant - duration of the fade-in and fade-out effect.
2. Create DELAY constant - pause before the start of the fade-in and fade-out effect.
3. Tell the component "#music" to start playing its sound with a gain of 1.0
4. Send a "fade_in_out" message to the script telling it to start fading the music in and out
5. Animate the "gain" property of the sound component back and forth between 0 and the current value (1.0)
--]]