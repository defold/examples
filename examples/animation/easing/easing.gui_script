local function update_index_text(index, total)
	local index_text = gui.get_node("index_text")
	gui.set_text(index_text, index .."/".. total)
end

local function update_easing_text(easing_name)
	local easing_text = gui.get_node("easing_text")
	gui.set_text(easing_text, "go.".. easing_name)
end

local function change_function_graph(easing_name)
	local node = gui.get_node("function_graph")
	gui.play_flipbook(node, string.lower(easing_name))
end

local function prev_button_clicked(self)
	msg.post("/demo#controller", "prev_easing_demo")
end

local function next_button_clicked(self)
	msg.post("/demo#controller", "next_easing_demo")
end

function init(self)
	msg.post(".", "acquire_input_focus")
end

function final(self)
	msg.post(".", "release_input_focus")
end

function on_message(self, message_id, message)
	if message_id == hash("demo_changed") then
		update_index_text(message.index, message.total)
		update_easing_text(message.easing_name)
		change_function_graph(message.easing_name)
	end
end

function on_input(self, action_id, action)
	if not action_id then return end -- ignore mouse/finger position

	if action_id == hash("touch") and action.pressed then
		local prev = gui.get_node("prev_button")
		local next = gui.get_node("next_button")
		if gui.pick_node(prev, action.x, action.y) then
			prev_button_clicked(self)
		elseif gui.pick_node(next, action.x, action.y) then
			next_button_clicked(self)
		end
	end
end
