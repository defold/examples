function init(self)
    msg.post(".", "acquire_input_focus")

    -- animate the spaceship up and down "for dramatic effect"
    go.animate(".", "position.y", go.PLAYBACK_LOOP_PINGPONG, go.get_position().y + 20, go.EASING_INOUTQUAD, 1)

    -- play the engine sound
    sound.play("#enginesound")
end


function on_input(self, action_id, action)
    if action_id == hash("mouse_button_left") and action.pressed then
        -- a list of sounds to chose between
        local sounds = {
            "/sounds/spaceEngine_001.ogg",
            "/sounds/spaceEngine_002.ogg",
            "/sounds/spaceEngine_003.ogg",
        }
        -- pick one at random
        local random_sound = sounds[math.random(1, #sounds)]

        -- load the new sound
        -- stop the currently playing sound
        -- set the sound on the sound component
        -- play it again
        local engine3 = sys.load_resource(random_sound)
        sound.stop("#enginesound")
        resource.set_sound(go.get("#enginesound", "sound"), engine3)
        sound.play("#enginesound")
    end
end