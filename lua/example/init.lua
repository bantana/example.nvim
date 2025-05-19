local M = {}

-- a simple function: welcome()
function M.welcome()
	print("Welcome! the first neovim plugin!")
end

-- a simple function with an argument
function M.greeting(input)
	print("Hello, " .. input .. "!")
end

-- Function to get the word under the cursor
function M.get_cursor_word()
	-- Get the current cursor position (row and col are 1-based)
	local _, col = unpack(vim.api.nvim_win_get_cursor(0))

	-- Get the line content at the current row (row is 1-based, so we subtract 1 for 0-based indexing)
	local line = vim.api.nvim_get_current_line()

	-- Check if the line is empty
	if line == "" then
		return nil
	end

	-- Find the start and end of the word at the cursor position
	local word_start = col
	local word_end = col

	-- Expand the start position to the left
	while word_start > 0 and line:sub(word_start, word_start):match("[%w_]") do
		word_start = word_start - 1
	end

	-- Expand the end position to the right
	while word_end < #line and line:sub(word_end + 1, word_end + 1):match("[%w_]") do
		word_end = word_end + 1
	end

	-- Extract the word
	local word = line:sub(word_start + 1, word_end) -- Lua strings are 1-based

	return word
end

function M.google_search(query)
	local google_url = "https://www.google.com/search?q=" .. query:gsub(" ", "+")
	local open_cmd

	-- Determine the OS and set the appropriate command to open URLs
	if vim.fn.has("mac") == 1 then
		open_cmd = "open " .. google_url -- macOS
	elseif vim.fn.has("unix") == 1 then
		open_cmd = "xdg-open " .. google_url -- Linux
	elseif vim.fn.has("win32") == 1 then
		open_cmd = "start " .. google_url -- Windows
	else
		print("Unsupported OS")
		return
	end

	-- Execute the command
	os.execute(open_cmd)
end

-- github repository search
function M.github_search(query)
	-- https://github.com/search?q=language%3ARust+axum&type=repositories
	local github_url = "https://github.com/search?q=" .. query:gsub(" ", "+") .. "&type=repositores"
	local open_cmd

	-- Determine the OS and set the appropriate command to open URLs
	if vim.fn.has("mac") == 1 then
		open_cmd = "open " .. github_url -- macOS
	elseif vim.fn.has("unix") == 1 then
		open_cmd = "xdg-open " .. github_url -- Linux
	elseif vim.fn.has("win32") == 1 then
		open_cmd = "start " .. github_url -- Windows
	else
		print("Unsupported OS")
		return
	end

	-- Execute the command
	os.execute(open_cmd)
end

-- github repository search
function M.gist_search(query)
	-- https://gist.github.com/search?q=Axum+router+example
	-- https://gist.github.com/search?q=axum+router&ref=simplesearch
	local gist_url = "https://gist.github.com/search?q=" .. query:gsub(" ", "+") .. "&ref=simplesearch&s=updated"
	local open_cmd

	-- Determine the OS and set the appropriate command to open URLs
	if vim.fn.has("mac") == 1 then
		open_cmd = "open " .. gist_url -- macOS
	elseif vim.fn.has("unix") == 1 then
		open_cmd = "xdg-open " .. gist_url -- Linux
	elseif vim.fn.has("win32") == 1 then
		open_cmd = "start " .. gist_url -- Windows
	else
		print("Unsupported OS")
		return
	end

	-- Execute the command
	os.execute(open_cmd)
end

-- Function to get the selected text in visual mode
function M.get_visual_selection()
	-- Get the start and end positions of the visual selection
	local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
	local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))

	-- Adjust indices to Neovim's 0-based indexing
	start_row = start_row - 1
	start_col = start_col - 1
	end_row = end_row - 1

	-- Get the lines in the selection range
	local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)

	-- Handle single-line and multi-line selections
	if #lines == 0 then
		return nil
	elseif #lines == 1 then
		-- Single-line selection: Ensure the range is within bounds
		return string.sub(lines[1], start_col + 1, end_col)
	else
		-- Multi-line selection: Trim the first and last lines
		lines[1] = string.sub(lines[1], start_col + 1)
		lines[#lines] = string.sub(lines[#lines], 1, end_col)
		return table.concat(lines, "\n")
	end
end

function M.setup(opts)
	vim.api.nvim_create_user_command("Welcome", function()
		M.welcome()
	end, { nargs = 0, desc = "Welcome command on example.nvim plugin" })

	-- Set up the user command using the opts.default_name
	vim.api.nvim_create_user_command("Greeting", function()
		vim.ui.input({ prompt = "Enter your name (default: " .. opts.default_name .. "): " }, function(input)
			-- Use input if provided, otherwise fallback to opts.default_name
			if not input or input == "" then
				input = opts.default_name
			end
			M.greeting(input)
		end)
	end, { nargs = 0, desc = "Greeting command on example.nvim plugin" })

	-- Command to print the word under the cursor
	vim.api.nvim_create_user_command("PrintCursorWord", function()
		local word = M.get_cursor_word()
		if word then
			print("Word under cursor: " .. word)
		else
			print("No word under cursor")
		end
	end, { desc = "Print the word under the cursor" })

	vim.api.nvim_create_user_command("MyHello", function(cmd_opts)
		local input = cmd_opts.args
		M.greeting(input)
	end, { nargs = 1, desc = "MyHello command on example.nvim plugin" })

	-- Create a user command for Google search
	vim.api.nvim_create_user_command("Google", function()
		vim.ui.input({ prompt = "Enter Google Search keyword: " }, function(input)
			-- Use input if provided, otherwise fallback to opts.default_name
			if not input or input == "" then
				print("no search keyword, cancel")
				return
			end
			M.google_search(input)
		end)
	end, { nargs = 0, desc = "Google Search on example.nvim plugin" })

	-- Create a user command for Github search
	vim.api.nvim_create_user_command("Github", function()
		vim.ui.input({ prompt = "Enter Github Repository Search keyword: " }, function(input)
			-- Use input if provided, otherwise fallback to opts.default_name
			if not input or input == "" then
				print("no search keyword, cancel")
				return
			end
			M.github_search(input)
		end)
	end, { nargs = 0, desc = "Github Search on example.nvim plugin" })

	-- Create a user command for Gist search
	vim.api.nvim_create_user_command("Gist", function()
		vim.ui.input({ prompt = "Enter Github Gist Search keyword: " }, function(input)
			-- Use input if provided, otherwise fallback to opts.default_name
			if not input or input == "" then
				print("no search keyword, cancel")
				return
			end
			M.gist_search(input)
		end)
	end, { nargs = 0, desc = "Github Gist Search on example.nvim plugin" })

	-- Optional: Map a keybinding to quickly search
	-- vim.keymap.set("n", "<leader>gs", "<cmd>Google<CR>", { noremap = true, silent = false })
	-- vim.keymap.set("n", "<leader>gr", "<cmd>Github<CR>", { noremap = true, silent = false })
	-- vim.keymap.set("n", "<leader>gi", "<cmd>Gist<CR>", { noremap = true, silent = false })
	-- Create a keybinding to invoke the command in visual mode
	-- Command to print the selected text
	vim.api.nvim_create_user_command("PrintSelectedText", function()
		local selected_text = M.get_visual_selection()
		if selected_text then
			print("Selected text:")
			print(selected_text)
		else
			print("No text selected")
		end
	end, { desc = "Print the selected text in visual mode" })

	-- Key mapping for visual mode
	-- vim.keymap.set("v", "<leader>gv", "<cmd>PrintSelectedText<CR>", { desc = "Print selected text", silent = true })
end

-- Function to delete all buffers except the current one
local function delete_other_buffers()
	-- Get the current buffer number
	local current_buf = vim.api.nvim_get_current_buf()

	-- Get a list of all buffers
	local buffers = vim.api.nvim_list_bufs()

	-- Iterate through the list of buffers
	for _, buf in ipairs(buffers) do
		-- Only delete the buffer if it is not the current one and it is listed
		if buf ~= current_buf and vim.api.nvim_get_option_value("buflisted", { buf = buf }) then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end
end

-- Create a command to call the function
vim.api.nvim_create_user_command("DeleteOtherBuffers", delete_other_buffers, {})

function M.bg_dark()
	vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
end

vim.api.nvim_create_user_command("BgDark", M.bg_dark, {})

function M.bg_transparency()
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
end

vim.api.nvim_create_user_command("BgTransparency", M.bg_transparency, {})

-- 替换中文标点为英文半角标点+空格
function M.replace_chinese_punctuations_line(line)
	local map = {
		["，"] = ", ",
		["。"] = ". ",
		["！"] = "! ",
		["？"] = "? ",
		["："] = ": ",
		["；"] = "; ",
		["“"] = '"',
		["”"] = '"',
		["‘"] = "'",
		["’"] = "'",
		["《"] = "<",
		["》"] = ">",
		["（"] = "(",
		["）"] = ")",
		["【"] = "[",
		["】"] = "]",
		["、"] = ", ",
		["——"] = "--",
		["……"] = "...",
		["·"] = ".",
		["「"] = '"',
		["」"] = '"',
		["『"] = '"',
		["』"] = '"',
	}
	local res = line
	for zh, en in pairs(map) do
		res = res:gsub(zh, en)
	end
	return res
end

-- 当前 buffer 全部替换
function M.replace_chinese_punctuations_buffer()
	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	for i, line in ipairs(lines) do
		lines[i] = M.replace_chinese_punctuations_line(line)
	end
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

-- 可视区域替换（支持 <,'> 选区）
function M.replace_chinese_punctuations_range(opts)
	local bufnr = vim.api.nvim_get_current_buf()
	local start_line = opts.line1 - 1
	local end_line = opts.line2
	local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)
	for i, line in ipairs(lines) do
		lines[i] = M.replace_chinese_punctuations_line(line)
	end
	vim.api.nvim_buf_set_lines(bufnr, start_line, end_line, false, lines)
end

-- 普通命令（处理全文件）
vim.api.nvim_create_user_command("ReplaceChinesePunctuations", function()
	M.replace_chinese_punctuations_buffer()
end, { desc = "将全文件中文标点替换为英文半角标点+空格" })

-- 可视区域命令
vim.api.nvim_create_user_command("ReplaceChinesePunctuationsRange", function(opts)
	M.replace_chinese_punctuations_range(opts)
end, { range = true, desc = "将选区中文标点替换为英文半角标点+空格" })

return M
