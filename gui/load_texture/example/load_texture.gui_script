local function set_message(text)
	gui.set_text(gui.get_node("message"), text) -- <11>
end

local function set_image(self, texture_id, image_data)
	if self.texture_id then -- <8>
		gui.delete_texture(self.texture_id) 
		self.texture_id = nil
	end

	local img = image.load(image_data) -- <9>
	if not img then 
		set_message("Unable to load image")
		return
	end
	
	if gui.new_texture(texture_id, img.width, img.height, img.type, img.buffer) then -- <10>
		self.texture_id = texture_id -- <11>
		gui.set_texture(gui.get_node("img"), texture_id) -- <12>
		set_message("Set new texture")
	else
		set_message("Unable to create texture")
	end
end


local load_image
load_image = function(url)
	http.request(url, "GET", function(self, id, res)  -- <6>
		-- redirect?
		if res.status == 302 or res.status == 301 then -- <7>
			set_message("Redirect: " .. res.headers.location)
			load_image(res.headers.location)
		-- ok or cached?
		elseif res.status == 200 or res.status == 304 then -- <7>
			set_image(self, url, res.response)
		-- error
		else
			set_message("Unable to get image: " .. res.response)
		end
	end)
end

local function load_random(self)
	local url = "https://picsum.photos/id/"..math.random(1, 10).."/200/300.jpg" -- <3>
	set_message("Loading...") -- <4>
	load_image(url) -- <5>
end

function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
	load_random(self)	-- <2>
end

function on_input(self, action_id, action)
	if action_id == hash("touch") and action.pressed then
		if gui.pick_node(gui.get_node("button"), action.x, action.y) then -- <13>
			load_random(self) -- <2>
		end
	end
end

--[[
1. Tell the engine that this game object wants to receive input.
2. Start loading random image
3. Generate a URL to a random image
4. Change the label text.
5. Call function load image from URL
6. Make an HTTP request and handle redirects
7. Check server response
8. Remove previous texture if any
9. Create an image resource from loaded image data
10. Create a new texture using image resource
11. Save the texture id 
12. Set new texture as node texture
13. Check if the click position (`action.x` and `action.y`) is within the boundaries of 
   the button node.
--]]
