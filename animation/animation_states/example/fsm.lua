---@alias FsmStateName string
---@alias FsmStateData table<string, any>
---@alias FsmStateMap table<FsmStateName, FsmStateData>
---@alias FsmTransitionMap table<FsmStateName, FsmStateName[]>

---@class FsmDefinition
---@field states FsmStateMap
---@field transitions FsmTransitionMap|nil
---@field initial_state FsmStateName|nil

---@class FsmMachine
---@field states FsmStateMap
---@field transitions FsmTransitionMap
---@field state FsmStateName|nil

local M = {}

-- <1>
---@param definition FsmDefinition
---@return FsmMachine
function M.new(definition)
	return {
		states = definition.states,
		transitions = definition.transitions or {},
		state = definition.initial_state
	}
end

-- <2>
---@param machine FsmMachine
---@return FsmStateName|nil
function M.get_state_name(machine)
	return machine.state
end

-- <3>
---@param machine FsmMachine
---@return FsmStateData|nil
function M.get_state(machine)
	if not machine.state then
		return nil
	end

	return machine.states[machine.state]
end

-- <4>
---@param machine FsmMachine
---@param next_state FsmStateName
---@return boolean
function M.can_transition(machine, next_state)
	-- <5>
	if machine.states[next_state] == nil then
		return false
	end

	-- <6>
	if machine.state == nil or machine.state == next_state then
		return true
	end

	-- <7>
	for _, candidate in ipairs(machine.transitions[machine.state] or {}) do
		if candidate == next_state then
			return true
		end
	end

	return false
end

-- <8>
---@param machine FsmMachine
---@param next_state FsmStateName
---@return boolean
function M.set_state(machine, next_state)
	if not M.can_transition(machine, next_state) then
		return false
	end

	-- <9>
	machine.state = next_state
	return true
end

-- <10>
---@param machine FsmMachine
---@param target_state FsmStateName
---@return FsmStateName[]|nil
function M.find_path(machine, target_state)
	-- <11>
	if machine.states[target_state] == nil then
		return nil
	end

	-- <12>
	if machine.state == nil then
		return { target_state }
	end

	-- <13>
	if machine.state == target_state then
		return {}
	end

	-- <14>
	local queue = { machine.state }
	local head = 1
	---@type table<FsmStateName, FsmStateName|false>
	local previous = { [machine.state] = false }

	while head <= #queue do
		local current_state = queue[head]
		head = head + 1

		-- <15>
		for _, next_state in ipairs(machine.transitions[current_state] or {}) do
			if previous[next_state] == nil then
				previous[next_state] = current_state

				-- <16>
				if next_state == target_state then
					local path = { target_state }
					local cursor = current_state

					-- <17>
					while cursor ~= machine.state do
						table.insert(path, 1, cursor)
						cursor = previous[cursor] --[[@as FsmStateName]]
					end

					return path
				end

				-- <18>
				queue[#queue + 1] = next_state
			end
		end
	end

	return nil
end

return M

--[[
1. `new()` creates one machine instance from a definition table. The module is reusable because each caller can build its own machine from different state data.
2. `get_state_name()` returns the current state id, such as `"run"` or `"standing_idle"`.
3. `get_state()` returns the current state's data table. This is useful when state data stores things like animation ids or loop flags.
4. `can_transition()` checks whether one direct step is legal in the transition graph.
5. The first guard makes sure the target state actually exists in the machine definition.
6. A machine with no active state yet may enter any defined state, and re-entering the same state is also allowed.
7. If the machine is already in some other state, the function looks through the transition list for the current state.
8. `set_state()` performs one direct transition and returns `true` only when that move is legal.
9. The module changes the active state by simply replacing `machine.state`. The module does not run callbacks automatically, so the caller stays in control of side effects.
10. `find_path()` solves a different problem from `set_state()`: instead of checking one direct move, it searches for a legal multi-step route.
11. If the requested target state is not defined, there is no valid path.
12. If the machine has no active state yet, the shortest path is just a one-step path containing the requested state.
13. If the machine is already in the requested state, the path is empty because no transition is needed.
14. The search uses a queue and a `previous` table. This is a breadth-first search, which finds the shortest path in number of transitions.
15. Each loop step explores all outgoing transitions from the current state.
16. As soon as the search reaches the requested state, the function can rebuild the path and return it.
17. The path is rebuilt by walking backward through the `previous` table, then inserting those states at the front of the result.
18. If a state has not been visited before, it is queued so the search can continue from there later.
--]]
