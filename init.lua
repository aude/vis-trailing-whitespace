function mark_trailing_whitespace(win)
	-- search through visible area for trailing whitespace
	local content = win.file:content(win.viewport)
	local offset = win.viewport.start
	local search_from = 0
	while true do
		-- search for trailing whitespace
		-- note: string.find() returns 1-based index, not 0-based
		local from, to = string.find(content, '%s+%f[\n]', search_from)

		-- stop searching if no more matches found
		if from == nil then
			break
		end

		-- mark
		-- convert from 1-based index to 0-based
		-- also add the offset
		local mark_from = from - 1 + offset
		local mark_to = to - 1 + offset
		win:style(win.STYLE_CURSOR, mark_from, mark_to)

		-- start next search after the current match
		search_from = to+1
	end
end

vis.events.subscribe(vis.events.WIN_HIGHLIGHT, mark_trailing_whitespace)
