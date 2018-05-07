go.property("gain", 1) -- <1>

local TIME = 2 -- <2>
local DELAY = 1 -- <3>

function init(self)
    msg.post("#music", "play_sound") -- <4>
end

local function fade_in(self) -- <5>
    self.in_fade_now = true
    go.animate("#", "gain", go.PLAYBACK_ONCE_FORWARD, 1, go.EASING_LINEAR, TIME, DELAY, 
    function() 
        self.in_fade_now = false 
    end)
end

local function fade_out(self) -- <6>
    self.in_fade_now = true
    go.animate("#", "gain", go.PLAYBACK_ONCE_FORWARD, 0, go.EASING_LINEAR, TIME, DELAY,
    function() 
        self.in_fade_now = false 
    end)
end

function update(self, dt)
    if self.in_fade_now then -- <7>
        msg.post("#music", "set_gain", {gain = self.gain}) -- <8>
    else
        if self.gain == 0 then
            fade_in(self) -- <9>
        elseif self.gain == 1 then
            fade_out(self) -- <10>
        end
    end
end

--[[
1. Create "gain" property that can be animated using go.animate().
2. Create TIME constant - duration of the fade-in and fade-out effect.
3. Create DELAY constant - pause before the start of the fade-in and fade-out effect.
4. Send message to component "#music" telling it to start playing its sound.
5. Create fade_in() method where we animate our "gain" property to 1.
6. Create fade_out() method where we animate our "gain" property to 0.
7. Check flag self.in_fade_now and send message only if this flag is true.
8. Send message "set_gain" with the "gain" property value to the sound component.
9. Start fade_in if gain property is equal to 0
10. Start fade_out if gain property is equal to 1
--]]