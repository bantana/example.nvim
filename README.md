
# example.nvim

Plugin for neovim develop training.

### Install

Install using [`lazy.nvim`](https://github.com/folke/lazy.nvim):


```lua
{
    dir = '~/example.nvim',
    -- 'bantana/example.nvim',
    -- lazy = true,
    cmd = {
      'Google',
      'Github',
      'Gist',
      'PrintSelectedText',
    },
    opts = {
      default_name = 'world!',
    },
    keys = {
      { '<leader>gs', '<cmd>Google<cr>', desc = 'Google' },
      { '<leader>gr', '<cmd>Github<cr>', desc = 'Github' },
      { '<leader>gi', '<cmd>Gist<cr>', desc = 'Gist' },
      { '<leader>gv', '<cmd>PrintSelectedText<cr>', desc = 'PrintSelectedText' },
    },
  }
```
