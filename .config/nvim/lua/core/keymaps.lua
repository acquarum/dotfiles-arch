-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local map = require('core.helpers').map

-- Disable the spacebar key's default behavior in Normal and Visual modes
map('<Space>', '<Nop>', { mode = { 'n', 'v' } })

-- Visual
map('<Esc>', '<cmd>nohlsearch<CR>', 'Clear search highlights')
map('<leader>lw', '<cmd>set wrap!<CR>', 'Toggle [l]ine [w]rapping')
map('<C-d>', '<C-d>zz', 'Scroll downwards by half a screen')
map('<C-u>', '<C-u>zz', 'Scroll upwards by half a screen')
map('n', 'nzzzv', 'Go to next search match')
map('N', 'Nzzzv', 'Go to previous search match')

-- Text editing
map('<CR>', 'o<Esc>', 'Add new line below without leaving normal mode')
map('<S-CR>', 'O<Esc>', 'Add new line above without leaving normal mode')
map('J', 'mzJ`z', 'Join lines without moving cursor')
map('U', '<C-r>', 'Redo (undo undo)')
map(
  '>',
  '>gv',
  { desc = 'Increase indentation of selected text without leaving visual mode', mode = 'v' }
)
map(
  '<',
  '<gv',
  { desc = 'Decrease indentation of selected text without leaving visual mode', mode = 'v' }
)
map('<A-j>', '<cmd>m+<CR>==', 'Move line down')
map('<A-k>', '<cmd>m-2<CR>==', 'Move line up')
map('<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down', mode = 'v' })
map('<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up', mode = 'v' })
map('x', '"_x', 'Delete single character without copying into register')
map('p', '"_dP', { desc = 'Paste without replacing yanked text', mode = 'v' })
map('<leader>p', 'p', { desc = 'Paste and repace yanked text', mode = 'v' })

-- Buffers
map('<Tab>', '<cmd>bn<CR>', 'Swich to next open buffer')
map('<S-Tab>', '<cmd>bp<CR>', 'Swich to previous open buffer')
map('<leader>bd', '<cmd>bd<CR>', 'Delete current buffer and close window')
map('<leader>nb', '<cmd>enew<CR>', 'Create new buffer')

-- Window management and navigation
map('<leader>\\', '<C-w>v', 'Split window vertically')
map('<leader>-', '<C-w>s', 'Split window horizontally')
map('<leader>=', '<C-w>=', 'Resize split windows to be of equal width and height')
map('<leader>wq', '<cmd>close<CR>', 'Close the current window')
map('<leader>to', '<cmd>tab split<CR>', 'Open new tabpage on current buffer')
map('<leader>tq', '<cmd>tabc<CR>', 'Close current tabpage')
map('<leader>tn', '<cmd>tabn<CR>', 'Go to next tabpage')
map('<leader>tp', '<cmd>tabp<CR>', 'Go to previous tabpage')
map('<C-A-k>', '<cmd>resize -2<CR>')
map('<C-A-j>', '<cmd>resize +2<CR>')
map('<C-A-h>', '<cmd>vertical resize -2<CR>')
map('<C-A-l>', '<cmd>vertical resize +2<CR>')
map('<C-k>', '<C-w>k', 'Navigate to split window above')
map('<C-j>', '<C-w>j', 'Navigate to split window below')
map('<C-h>', '<C-w>h', 'Navigate to split window to the left')
map('<C-l>', '<C-w>l', 'Navigate to split window to the right')
map(
  '<C-k>',
  [[<C-\><C-N><C-w>k]],
  { desc = 'Insert/terminal mode: navigate to split window above', mode = { 'i', 't' } }
)
map(
  '<C-j>',
  [[<C-\><C-N><C-w>j]],
  { desc = 'Insert/terminal mode: navigate to split window below', mode = { 'i', 't' } }
)
map(
  '<C-h>',
  [[<C-\><C-N><C-w>h]],
  { desc = 'Insert/terminal mode: navigate to split window to the left', mode = { 'i', 't' } }
)
map(
  '<C-l>',
  [[<C-\><C-N><C-w>l]],
  { desc = 'Insert/terminal mode: navigate to split window to the right', mode = { 'i', 't' } }
)
map('<ESC>', [[<C-\><C-n>]], { desc = 'Terminal mode: return to normal mode', mode = 't' })
map('<leader>ts', '<cmd>wincmd s | terminal<CR>', 'Open terminal in split window')
map('<leader>tw', '<cmd>terminal<CR>', 'Open terminal in current window')

-- Diagnostic keymaps
map('<leader>d', vim.diagnostic.open_float, 'Open floating [D]iagnostics')
map('<leader>q', vim.diagnostic.setloclist, 'Diagnostic [Q]uickfix list')

-- Undotree
map('<leader>u', '<cmd>Undotree<CR>', 'Open or close Undotree')

-- External plugins

map(
  '<leader>vps',
  function() vim.pack.update(nil, { offline = true }) end,
  'Inspect installed packages and pending updates'
)
map('<leader>vpu', vim.pack.update, 'Update all packages')
