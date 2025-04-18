# README

- `example.nvim` 是一个 neovim lua 插件演示

## Initialize a plugin directory

Initialize the local nvim plug-in directory

```lua
-- lazy.nvim
{
   dir = '~/example.nvim', -- 使用 `dir` 启动本地开发目录
}
```

## Plugin structure

现在插件已设置并安装. 让我们了解一下它的文件夹结构.

在插件的根目录中, 创建如下结构（将 `example` 替换为您的插件名称）:

```bash
example.nvim/
├── README.md
├── lua
│   └── example
│       └── init.lua
└── plugin
    └── example.lua

4 directories, 3 files
```

### `plugin/`

Neovim 启动时将执行 plugin/ 文件夹中的文件. 尝试将以下行添加到 example.lua 中:

```lua plugin/example.lua
print("plugin/example.lua is executed!")
```

之后打开一个新的 Neovim 实例, 您将看到打印的字符串

      plugin/example.lua is excuted!

我们可以在这个文件中加入启动时期望它自动初始化的代码.

### `lua/`

`lua/` 这个目录相当于 `library`, 主要使用 `lua module` 的方式来组织代码.
大多数时候, 您不希望插件在启动时执行所有操作.
您希望它在事件发生、命令调用等时运行一些函数, 并以结构化的方式组织代码. 这就是 Lua 模块发挥作用的地方.

```lua lua/example/init.lua
local M = {} -- M stands for module, a naming convention

function M.setup()
   print("hello")
end

return M
```

然后你就可以使用 `require("example").setup()` 来加载这个模块并运行模块函数 `M.setup()`, 它会打印 `hello`

```lua
-- require 模块和lua文件对应关系. init.lua 可以省略
lua require("example.init").setup() -- lua/example/init.lua
lua require("example").setup() -- 文件名是 init.lua 的时候可以省略
```

以下是需要 `require` 查找文件时的规则:

- 搜索时, 模块名称中的任何 `.` 都将被视为目录分隔符.
- 当未搜索到带有模块名称的文件时, 它会在带有模块名称的文件夹中搜索 `init.lua`.
- 您不需要输入 `.lua` 扩展名.

Example: For a module `foo.bar`, each directory inside `'runtimepath'` is searched for `lua/foo/bar.lua`, then `lua/foo/bar/init.lua`.

So if you put the code above into `lua/example/init.lua`, you can run `:lua require("example").setup()` to print hello. That is because the plugin manager added the folder of the plugins into `'runtimepath'` for you. Therefore the require can find this file.

### `vim.keymap.set`

After understanding the structure of Neovim plugin, let’s finish the example.nvim! This plugin does 2 simple things:

- It maps the `<Leader>h` to print hello to the user.
- If user specify their name when setting up plugins, it prints `hello, {user_name}` instead.

Here’s the `lua/example/init.lua`:

```lua
local M = {}

function M.setup(opts)
   opts = opts or {}

   vim.keymap.set("n", "<leader>h", function()
      if opts.name then
         print("hello, " .. opts.name)
      else
         print("hello")
      end
   end)
end

return M
```

上面的代码定义了一个lambda函数:

```lua
local M = {}            -- 1. 定义一个 `module`

function M.setup(opts)  -- 2. M 有一个 `setup` 函数, 并且接受一个 `opts` 的参数.
   opts = opts or {}    -- 3. `or` 是逻辑语法, 表示有值就用传入的opts, 如果是`null` | `undefined` 就用 `{}` 初始化它.

   vim.keymap.set("n", "<leader>h", function() -- 4. `vim.keymap.set` 是一个函数, 接收3个参数, 第一个是 `normal mode` 的缩写, 第二个是绑定的快捷键, 第3个是一个lambda function.
      if opts.name then                -- 5. 使用外部的 `opts` `lua table`.
         print("hello, " .. opts.name)
      else
         print("hello")
      end
   end)
end

return M  -- 6. 返回这个 `module`
```

You need to call `setup` after installing plugin:

```lua
require("example").setup()
```

Or if you are using lazy.nvim:

```lua
{
   "bnse/example.nvim",
   opts = {}
}
```

Notice that we use `vim.keymap.set` which is only available after Neovim 0.7.0. We need to add a version checker and it should be executed automatically at startup, so it should be put inside `plugin/` folder.

Here’s the `plugin/example.lua`:

```lua
if vim.fn.has("nvim-0.7.0") ~= 1 then
   vim.api.nvim_err_writeln("Example.nvim requires at least nvim-0.7.0.")
end

```

After that this simple plugin is finished. Now try pressing `<Leader>h` and the greeting message should be printed! You can also set your name inside `setup` function so that it prints greeting message with name:

```lua
require("example").setup({
   name = "Max",
})
```

Or if you are using lazy.nvim:

```lua
{
   "bnse/example.nvim",
   opts = {
      name = "Max",
   }
}
```

## The complete source code

```lua
-- ~/example.nvim/plugin/example.lua
print("plugin/example.lua is executed!")
```

```lua
-- ~/example.nvim/lua/example/init.lua
local M = {}

function M.setup(opts)
 opts = opts or {}
 vim.api.nvim_create_user_command("MyHello", function()
  M.hello(opts)
 end, { desc = "MyHello command on example.nvim plugin" })
 --
 -- vim.keymap.set("n", "<leader>l", "<cmd>MyHello<cr>")
 -- Use `which-key` binding instead keymap
 -- l = { '<cmd>MyHello<CR>', ' '}
end

function M.hello(opts)
 if opts.name then
  print("hello, " .. opts.name)
 else
  print("hello")
 end
end

return M
```

```lua
-- lazy.nvim
{
   dir = '~/example.nvim',
   opts = {
      name = 'max',
   },
   config = function(_, opts)
      require('example').setup(opts)
      local wk = require 'which-key'
      wk.register({
         l = { '<cmd>MyHello<CR>', 'MyHello' },
      }, { prefix = '<leader>' })
   end,
},
```

## publish the plugin

### Create a repo with local source

```bash
cd ~/example.nvim/
gh repo create example.nvim --public --source=. --remote=origin
git pb
```

### Change the Plugin from local directory to GitHub

```lua
-- lazy.nvim
{
   -- dir = '~/example.nvim',
   "bnse/example.nvim" -- replace this with your {user_name}/{repo_name}
}
```

## Final Words

Getting started is the hardest part when developing a Neovim plugin first time. I hope this tutorial helps you out.

## Referrence

- `lua table`

> ![NOTE]:
>
> `table` 是 `lua` 语言中的一种数据类型.

A Lua module is a `regular Lua table` that is used to contain functions and data. The `table` is declared local not to pollute the global scope. For example:

Lua 模块是一个 `常规 Lua 表`, 用于包含函数和数据. `table` 被声明为本地的, 以免污染全局范围. 例如:
