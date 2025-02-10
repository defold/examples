-- < 1 >
local min_size = 48
local max_size = 235 - min_size

-- < 2 >
local function set_healthbar(healthbar_node_name, health_percentage)
	local healthbar_node = gui.get_node(healthbar_node_name)	-- < 3 >
	local healthbar_size = gui.get_size(healthbar_node)			-- < 4 >
	healthbar_size.x = health_percentage * max_size + min_size	-- < 5 >
	gui.set_size(healthbar_node, healthbar_size)				-- < 6 >
end

function init(self)
	-- < 7 >
	set_healthbar("left_health", 1.0)
	set_healthbar("right_health", 1.0)
	set_healthbar("center_health", 1.0)
end

function on_message(self, message_id, message, sender)
	-- < 8 >
	if message_id == hash("update_health") then
		set_healthbar(message.health_name, message.health_percentage)
	end
end

--[[
1. Define minimum and maximum size of GUI healthbar (only width is changed).
2. Define a local helper function to update healthbar.
3. Get node of given name passed as "healthbar_node_name" and store it in local variable "healthbar_node".
4. Get size of this node and store it in local variable "healthbar_size".
5. Change size along X axis (width) of the node to given "health_percentage" scaled times "max_size" and added to "min_size", so that it can be no smaller than it.
6. Set the newly updated size of the node.
7. In init function, for each of three defined nodes set initial health_percentage to 1.0 (100%).
8. In on_message function, if the GUI component receives message "update_health" call helper function to update given health bar.
]]