local function is_in_selections(win, range)
	for _, selection in ipairs(win.selections) do
		if selection.pos >= range.start and selection.pos <= range.finish+1 then
			return true
		end
	end
	return false
end

local function highlight(win, ranges)
	for _, range in ipairs(ranges) do
		-- don't update current lines while in insert mode
		-- it would be annoying while typing
		if not (vis.mode == vis.modes.INSERT and is_in_selections(win, range)) then
			-- note: Window:style() uses 0-based index, not 1-based
			win:style(win.STYLE_CURSOR, range.start, range.finish)
		end
	end
end

local function find_trailing_whitespace(win)
	local ranges = {}

	-- search through visible area for trailing whitespace
	local content = win.file:content(win.viewport)

	-- remember position in file
	local offset = win.viewport.start

	for line in string.gmatch(content, "([^\n]*)") do
		-- search for trailing whitespace
		local from, to = string.find(line, '%s+$')

		-- if match found
		if from ~= nil then
			-- highlight
			-- add the offset
			-- convert from 1-based index to 0-based
			pos_from = from + offset - 1
			pos_to = to + offset - 1
			table.insert(ranges, {start=pos_from, finish=pos_to})
		end

		-- +1 to count the '\n'
		offset = offset + string.len(line)+1
	end

	return ranges
end

vis.events.subscribe(vis.events.WIN_HIGHLIGHT, function(win)
	local ranges = find_trailing_whitespace(win)
	highlight(win, ranges)
end)
