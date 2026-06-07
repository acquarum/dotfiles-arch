--------------------------
----- GENERAL CONFIG -----
--------------------------

local general_config = vim.api.nvim_create_augroup('general_config', { clear = true })

-- Highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = general_config,
  callback = function() vim.hl.on_yank() end,
})

-- Restore last cursor position when opening file
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Restore last cursor position when reading buffer',
  group = general_config,
  callback = function()
    if vim.o.diff then
      return
    end

    local last_pos = vim.api.nvim_buf_get_mark(0, '"')
    local last_line = vim.api.nvim_buf_line_count(0)

    local row = last_pos[1]
    if row < 1 or row > last_line then
      return
    end

    pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
  end,
})

-------------------------
----- INSTALL HOOKS -----
-------------------------

-- Define install and update hooks
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('install_hooks', { clear = true }),
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then
      return
    end

    if name == 'nvim-treesitter' then
      if not ev.data.active then
        vim.cmd.packadd 'nvim-treesitter'
      end
      vim.cmd 'TSUpdate'
    end

    if name == 'telescope-fzf-native' then
      require('core.helpers').run_build(name, { 'make' }, ev.data.path)
    end
  end,
})
