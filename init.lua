function mark_trailing_whitespace(win)
	-- don't mark trailing whitespace in insert mode
	-- it would be annoying while typing
	if vis.mode == vis.modes.INSERT then
		return
	end

	-- search through visible area for trailing whitespace
	local content = win.file:content(win.viewport)

	-- remember position in file
	local offset = win.viewport.start

	for line in string.gmatch(content, "([^\n]*)") do
		-- search for trailing whitespace
		-- note: string.find() returns 1-based index, not 0-based
		local from, to = string.find(line, '%s+$')

		-- if match found
		if from ~= nil then
			-- mark
			-- convert from 1-based index to 0-based
			-- also add the offset
			local mark_from = from - 1 + offset
			local mark_to = to - 1 + offset
			win:style(win.STYLE_CURSOR, mark_from, mark_to)
		end

		-- +1 to count the '\n'
		offset = offset + string.len(line)+1
	end
end

vis.events.subscribe(vis.events.WIN_HIGHLIGHT, mark_trailing_whitespace)
