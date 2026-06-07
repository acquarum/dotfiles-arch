vim.loader.enable()

require 'core.options'
require 'core.keymaps'
require 'core.autocmds'
require 'core.diagnostics'
require 'lsp.autocmds'
require 'lsp.servers'
require('vim._core.ui2').enable()

-- Built-in plugins
vim.cmd.packadd 'nvim.undotree'
