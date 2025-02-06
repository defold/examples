function init(self)
	msg.post(".", "acquire_input_focus")
	
	-- list of boxes to drag
	self.boxes = {
		gui.get_node("box1"),
		gui.get_node("box2"),
		gui.get_node("box3"),
	}

	-- variable where the currently dragged box is stored
	self.dragged_box = nil
end

function on_input(self, action_id, action)
	if action_id == hash("touch") then
		-- update the position of the currently dragged box
		if self.dragged_box then
			local mouse_position = vmath.vector3(action.x, action.y, 0)
			gui.set_position(self.dragged_box, mouse_position)
		end

		-- check if the mouse button was pressed
		if action.pressed then
			-- iterate the list of boxes and check if the mouse was
			-- clicked on a box
			for i=1,#self.boxes do
				local box = self.boxes[i]
				-- this will return true if the x and y is within the
				-- bounds of the box
				if gui.pick_node(box, action.x, action.y) then
					-- keep track of the box as being dragged
					self.dragged_box = box
					break
				end
			end
		-- check if the mouse button was released
		-- clear the variable which keeps track of which box is dragged
		elseif action.released then
			self.dragged_box = nil
		end
	end
end
