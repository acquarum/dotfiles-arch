vim.pack.add {
  'https://github.com/lewis6991/gitsigns.nvim',
}

require('gitsigns').setup {
  signs = {
    add = { text = '┃' },
    change = { text = '┃' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
    untracked = { text = '┆' },
  },
  signs_staged = {
    add = { text = '┃' },
    change = { text = '┃' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
    untracked = { text = '┆' },
  },
  signs_staged_enable = true,
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true,
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
    use_focus = true,
  },
  current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1,
  },
  on_attach = function(bufnr)
    local gitsigns = require 'gitsigns'
    local map = require('core.helpers').map

    -- Navigation
    map(']h', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, { buffer = bufnr, desc = 'Gitsigns: goto next hunk' })

    map('[h', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, { buffer = bufnr, desc = 'Gitsigns: goto previous hunk' })

    -- Actions
    map('<leader>hs', gitsigns.stage_hunk, 'Gitsigns: stage hunk')
    map('<leader>hr', gitsigns.reset_hunk, 'Gitsigns: reset hunk')

    map('<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { mode = 'n', desc = 'Gitsigns: stage selected hunk' })
    map('<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { mode = 'n', desc = 'Gitsigns: reset selected hunk' })

    map('<leader>hS', gitsigns.stage_buffer, 'Gitsigns: stage buffer')
    map('<leader>hR', gitsigns.reset_buffer, 'Gitsigns: reset buffer')

    map('<leader>hp', gitsigns.preview_hunk, 'Gitsigns: preview hunk')
    map('<leader>hi', gitsigns.preview_hunk_inline, 'Gitsigns: preview hunk inline')

    map('<leader>hb', function() gitsigns.blame_line { full = true } end, 'Gitsigns: get blame for current line')

    map('<leader>hd', gitsigns.diffthis, 'Gitsigns: get diff for current hunk')
    map('<leader>hD', function() gitsigns.diffthis '~' end)

    map('<leader>hq', gitsigns.setqflist)
    map('<leader>hQ', function() gitsigns.setqflist 'all' end)

    -- Toggles
    map('<leader>tb', gitsigns.toggle_current_line_blame, 'Gitsigns: toggle blame for current line')
    map('<leader>tw', gitsigns.toggle_word_diff)

    -- Text object
    map('ih', gitsigns.select_hunk, { mode = { 'o', 'x' }, desc = 'Gitsigns: select hunk' })
  end,
}
