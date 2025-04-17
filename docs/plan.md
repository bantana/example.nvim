# Plan

- 实现一个function hello(),

```lua
local M = {}

function M.welcome()
	print("Welcome! the first neovim plugin!")
end

function M.setup(opts)

	vim.api.nvim_create_user_command("Welcome", function()
		M.welcome()
	end, { nargs = 0, desc = "Welcome command on example.nvim plugin" })

end

return M
```
