vis.events.subscribe(vis.events.WIN_HIGHLIGHT, function(win)
	local content = win.file:content(0, win.file.size-1)

	-- search through whole file for trailing whitespace
	-- TODO: could optimize by only searching through viewed area of file
	local init = 0
	while true do
		-- search for trailing whitespace
		local start, finish = string.find(content, '[ \t]+\r?\n', init)

		-- stop searching if no more matches exist
		if finish == nil then
			break
		end

		-- mark
		win:style(win.STYLE_CURSOR, start-1, finish-2)

		-- start next search after the current match
		init = finish+1
	end
end)
