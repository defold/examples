local function set_scores_state(self, score_state)
	gui.set_text(self.ui_elements.num_score, score_state.score)
	gui.set_text(self.ui_elements.num_best, score_state.best_score)
end

function init(self)
	self.current_score_state = {  --  < 1 >
		score = math.random(100, 500),
		best_score = math.random(501, 999)
	}

	self.ui_elements = {}  --  < 2 >
	self.ui_elements.num_score = gui.get_node("num_score")
	self.ui_elements.num_best = gui.get_node("num_best")

	set_scores_state(self, self.current_score_state) --  < 3 >
end

function on_message(self, message_id, message, sender)
	if message_id == hash("layout_changed") then --  < 4 >
		set_scores_state(self, self.current_score_state)
	elseif message_id == hash("update_score") then --  < 5 >
		self.current_score_state.score = self.current_score_state.score + message.score
		if self.current_score_state.score > self.current_score_state.best_score then
			self.current_score_state.best_score = self.current_score_state.score
		end
		set_scores_state(self, self.current_score_state)
	end
end

--[[
1.-It's important to store the state of the UI separately from the view.

2.-Having all the nodes for UI elements makes it easier to work with.

3.-This function updates the view with the current state.

4.-When the layout changes, all the nodes (view) reset to the corresponding layout setup. 
	At this point, we need to restore our state.

5.-External code updates the state, and we apply changes of the state to the view.
--]]
	