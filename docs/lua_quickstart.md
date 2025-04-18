# Lua Quick Start

这个文档不是 `lua` 完整的教程, 我只是用于简单的 neovim lua 管理.

这篇文档只涉及到一些关键的概念和编程模式.

## Easy

- 数据类型
- 函数
- 表
- 简单对象

### 数据类型

八种类型:

1.  number (double)
2.  string
3.  boolean (`true | false`)
4.  function 基本的Lua对象, 不同于C语言的函数或函数指针, lua的关键概念之一
5.  table (一种异构的hash table, 另一个关键概念)
6.  userdata (C语言用户定义的数据结构, 用于扩展lua语言, 本文不会涉及)
7.  thread coroutine
8.  nil 表示null, 但实际含义要深很多.

### 函数

```lua
function foo(a, b, c)
   local sum = a + b
   return sum, c -- function can return multi values
end

r1, r2 = foo(1, '123', 'hello') -- 平行赋值
print(r1, r2) -- 124	hello,
```

> [!NOTE]
>
> 如果你有类型系统的基础, 下面的结果肯定很反感.
> 你甚至不知道 `124` 是 `number` 还是 `string`

1 + '123' => 124

不过我们先回到 `function` 最基本的概念来.

```lua
-- keyword
-- 1. function
-- 2. func_name
-- 3. args
-- 4. return
-- 5. end
function func_name(args)
   -- computing
   return ...
end
```

还有我们最喜欢的 `lambda`:

```lua
local add = function(a, b)
   return a + b
end
print(add(3,'4')) -- 7
```

在 `lua` 中, 没有使用 `local` keyword 定义都是全局变量.

```lua
local firstName = "abby"  -- 局部变量, `local` 小写变量名
print(firstName)

Name = "Global Abby" -- 全局变量, 首字母大写变量名
print(Name)
```

### 表

1. 定义一个空表

```lua
local M = {}
print(M) -- table: 0x60000255c840 -- table 类型和内存地址

M.name = "module name"
print(M.name) -- module name

M.age = 18
print(M.age) -- 18

local N = { n = 1, str = "abc", 100, "hello" }
print(N.n, N.str, N[1], N[2]) -- 1       abc     100     hello

-- 如果要访问 `n = 1`: 有2种方式.
N.n , N["n"]
-- ❌ N[n], 因为N[n] 中数组下标是值不是符号.

for key, value in pairs(N) do
   print(key, value)
end
-- 因为hash是无序的, 所以结果的顺序是不确定的.
-- 1       100
-- 2       hello
-- str     abc
-- n       1
for key, _ in pairs(N) do
   print(key, N[key])
end

-- 删除一个key
N.n = nil
N[1] = nil

-- 这也意味者访问一个不存在的 key, 结果是 nil
local notfound = N[1000]
print(notfound) -- nil

if notfound == nil then
   print("found nil") -- found nil
end
```

### 简单对象

```lua
function CreateFoo(name)
   local obj = { name = name }
   function obj:SetName(myname)
      self.name = myname
   end
   function obj:GetName()
      return self.name
   end
   return obj
end

local o = CreateFoo("Sam")
print("name", o:GetName()) -- name	Sam
o.SetName(o, "Luck")
print("name", o:GetName()) -- name	Luck
```

```lua
local M = { obj = {} }
function M.setName(name)
   M.obj.name = name
end
function M.getName()
   return M.obj.name
end

-- print(M.getName())
M.setName("Sam")
print("name", M.getName())
M.setName("Lucky")
print("name", M.getName())
```

```lua
-- 使用模块前缀
local M = { obj = {} }
function M:setName(name)
   M.obj.name = name
end
function M:getName()
   return M.obj.name
end

-- print(M.getName())
M:setName("Sam")
print("name", M:getName())
M:setName("Lucky")
print("name", M:getName())
```

```lua
local A = { 7, 6, 5 }
for key, _ in pairs(A) do
   print(A[key])
end
for _, value in pairs(A) do
   print(value)
end
for index, value in ipairs(A) do
   print(index, value)
end
```

- Coroutine

```lua
local function producer()
   return coroutine.create(function(salt)
      local t = { 1, 2, 3 }
      for i = 1, #t do
	 salt = coroutine.yield(t[i] + salt)
      end
   end)
end
local function consumer(prod)
   local salt = 0
   while true do
      local running, product = coroutine.resume(prod, salt)
      salt = salt * salt
      if running then
	 print(product or "END!")
      else
	 break
      end
   end
end

consumer(producer())

-- 1
-- 2
-- 3
-- END!
```

### Coroutine

- coroutine table

```lua
(global) coroutine: coroutinelib {
   close: function,
      create: function,
      isyieldable: function,
      resume: function,
      running: function,
      status: function,
      wrap: function,
      yield: function,
}
```

---

[View documents](http://www.lua.org/manual/5.1/manual.html#pdf-coroutine)

```lua
function coroutine.create(f: fun(...any):...unknown)
-> thread
```

---

Creates a new coroutine, with body `f`. `f` must be a function. Returns this new coroutine, an object with type `"thread"`.

[View documents](http://www.lua.org/manual/5.1/manual.html#pdf-coroutine.create)

```lua
function coroutine.status(co: thread)
-> "dead"|"normal"|"running"|"suspended"
```

---

Returns the status of coroutine `co`.

[View documents](http://www.lua.org/manual/5.1/manual.html#pdf-coroutine.status)

```lua
return #1:
   | "running" -- Is running.
   | "suspended" -- Is suspended or not started.
   | "normal" -- Is active but not running.
   | "dead" -- Has finished or stopped with an error.
```

```lua
function coroutine.resume(co: thread, val1?: any, ...any)
-> success: boolean
2. ...any
```

---

Starts or continues the execution of coroutine `co`.

[View documents](http://www.lua.org/manual/5.1/manual.html#pdf-coroutine.resume)

- coroutine method

  - create(f)
  - status(co)
  - resume(co)
  - yield()

- status(co)

  - suspended
  - running
  - dead

```lua

local function instream()
   return coroutine.wrap(function()
      while true do
	 local line = io.read("*l")
	 if line then
	    coroutine.yield(line)
	 else
	    break
	 end
      end
   end)
end
local function filter(ins)
   return coroutine.wrap(function()
      while true do
	 local line = ins()
	 if line then
	    line = "** " .. line .. " **"
	    coroutine.yield(line)
	 else
	    break
	 end
      end
   end)
end
local function outstream(ins)
   while true do
      local line = ins()
      if line then
	 print(line)
      else
	 break
      end
   end
end
outstream(filter(instream()))

```

```bash
❯ lua demo.lua
123
** 123 **
abc
** abc **
^D

```

## Middle

## Advance
