# example.nvim

Plugin for neovim develop training.

### Install

Install using [`lazy.nvim`](https://github.com/folke/lazy.nvim):

```lua
{
  -- dir = '~/example.nvim',
  'bantana/example.nvim',
  cmd = {
    'Google',
    'Github',
    'Gist',
    'PrintSelectedText',
    'DeleteOtherBuffers',
    'BgDark',
    'BgTransparency',
  },
  opts = {
    default_name = 'world!',
  },
  keys = {
    { '<leader>gs', '<cmd>Google<cr>', desc = 'Google' },
    { '<leader>gr', '<cmd>Github<cr>', desc = 'Github' },
    { '<leader>gi', '<cmd>Gist<cr>', desc = 'Gist' },

    { '<leader>b', group = 'buffers' },
    { '<leader>bd', '<cmd>bd<CR>', desc = 'buffers delete current' },
    { '<leader>bo', '<cmd>DeleteOtherBuffers<CR>', desc = 'buffers delete Othere' },
    { '<leader>bn', '<cmd>bn<CR>', desc = 'buffers next' },
    { '<leader>bp', '<cmd>bp<CR>', desc = 'buffers previous' },
    { '<leader>-', '<cmd>resize +20<cr>', desc = 'horizontal +20' },
    { '<leader>_', '<cmd>resize -20<cr>', desc = 'horizontal -20' },
    { '<leader>=', '<cmd>vertical resize +50<cr>', desc = 'vertical +50' },
    { '<leader>+', '<cmd>vertical resize -50<cr>', desc = 'vertical -50' },
    { '<leader>tt', '<cmd>lua vim.fn.system("tmux set status")<cr>', desc = 'toggle tmux status' },
  },
},

```
