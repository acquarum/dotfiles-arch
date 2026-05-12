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

return tbl
