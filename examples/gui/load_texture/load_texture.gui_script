local function on_finish_loading(self, msg)
	print(msg)
	gui.set_text(self.text, "LOAD RANDOM") -- <11>
end

local function on_load_finish(self, id, res)
	if res.status ~= 200 and res.status ~= 304 then -- <7>
		on_finish_loading(self, "Unable to get image\n".. res.response)
		return
	end
		
	local img = image.load(res.response) -- <8>
	if not img then 
		on_finish_loading(self, "Unable to load image")
		return
	end
	
	if gui.new_texture(self.texture_url, img.width, img.height, img.type, img.buffer) then -- <9>
		gui.set_texture(self.img, self.texture_url) -- <10>
		on_finish_loading(self, "LOADED: "..self.texture_url)
	else
		on_finish_loading(self, "Unable to create texture")
	end
end

local function start_load_random(self)
	if self.texture_url then -- <4>
		gui.delete_texture(self.texture_url) 
	end
	self.texture_url = "https://storage.googleapis.com/defold-examples/random_images/"..math.random(1, 10)..".png"
	http.request(self.texture_url, "GET", on_load_finish) -- <5>
	gui.set_text(self.text, "Loading...") -- <6>
end

function init(self)
	msg.post(".", "acquire_input_focus") -- <1>
	self.button = gui.get_node("button") -- <2>
	self.img = gui.get_node("img")	
	self.text = gui.get_node("text")
	start_load_random(self)	-- <3>
end

function on_input(self, action_id, action)
	if action_id == hash("touch") and action.pressed then
		if gui.pick_node(self.button, action.x, action.y) then -- <12>
			start_load_random(self) -- <3>
		end
	end
end

--[[
1. Tell the engine that this game object wants to receive input.
2. Get nodes and save them in self table
3. Start loading random image
4. Remove prev. created texture
5. Make an HTTP request, and set on_load_finish method for request
6. Change the label text.
7. Check server responce
8. Check is request an image, then create an image resource
9. Create a new texture using img resource
10. Set new texture as node texture
11. Change the label text.
12. Check if the click position (`action.x` and `action.y`) is within the boundaries of 
   the button node.
--]]
