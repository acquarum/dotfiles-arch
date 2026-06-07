local tbl = {}

---@class keymap_options
---@field desc? string Description of the keymap
---@field silent? boolean Suppress output
---@field remap? boolean Allow recursive keymaps
---@field mode? string | string[] Modes where keymap should be active ('n', 'v' or 'i')
---@field buffer? integer Buffer where the keymap should be active

-- Helper function to add keymaps
---@param keymap string
---@param action string | function
---@param options? string | keymap_options
function tbl.map(keymap, action, options)
  local opts = { remap = false, silent = true }
  ---@type string | string[]
  local mode = 'n'

  if options ~= nil then
    if type(options) == 'string' then
      opts.desc = options
    else
      mode = options.mode or mode

      if options.desc ~= nil then
        opts.desc = options.desc
      end

      if options.silent ~= nil then
        opts.silent = options.silent
      end

      if options.remap ~= nil then
        opts.remap = options.remap
      end

      if options.buffer ~= nil then
        opts.buffer = options.buffer
      end
    end
  end

  vim.keymap.set(mode, keymap, action, opts)
end


---@param name string
---@param command string | table
---@param path string
function tbl.run_build(name, command, path)
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


return tbl
