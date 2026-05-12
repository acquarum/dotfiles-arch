local general_config = vim.api.nvim_create_augroup('general_config', { clear = true })

---@param name string
---@param command string | table
---@param path string
local function run_build(name, command, path)
  local cmd
  if type(command) == 'string' then
    cmd = { command }
  else
    cmd = command
  end

  local result = vim.system(cmd, { cwd = path }):wait()
  if result.code ~= 0 then
    local stderr = result.stderr or ''
    local stdout = result.stdout or ''
    local output = stderr ~= '' and stderr or stdout
    if output == '' then
      output = 'No output from build command.'
    end
    vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
  end
end

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

local install_hooks = vim.api.nvim_create_augroup('install_hooks', { clear = true })

-- Define install and update hooks
vim.api.nvim_create_autocmd('PackChanged', {
  group = install_hooks,
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then
      return
    end

    if name == 'nvim-treesitter' then
      if not ev.data.active then
        vim.cmd.packadd 'nvim-treesitter'
      end
      vim.cmd('TSUpdate')
    end

    if name == 'telescope-fzf-native' then
      run_build(name, { 'make' }, ev.data.path)
    end
  end,
})
