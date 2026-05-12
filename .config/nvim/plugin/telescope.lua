vim.pack.add {
  'https://github.com/nvim-telescope/telescope.nvim',
}

require('telescope').setup {
  -- You can put your default mappings / updates / etc. in here
  --  All the info you're looking for is in `:help telescope.setup()`
  defaults = {
    mappings = {
      i = {
        ['<C-k>'] = require('telescope.actions').move_selection_previous, -- move to prev result
        ['<C-j>'] = require('telescope.actions').move_selection_next, -- move to next result
        ['<C-l>'] = require('telescope.actions').select_default, -- open file
      },
    },
  },
  pickers = {
    find_files = {
      file_ignore_patterns = { 'node_modules', '.git', '.venv' },
      hidden = true,
      follow = true,
    },
    live_grep = {
      file_ignore_patterns = { 'node_modules', '.git', '.venv' },
      additional_args = { '--hidden', '--follow' },
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
    ['fzf'] = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  },
}

-- Enable Telescope extensions if they are installed
require('telescope').load_extension 'fzf'
require('telescope').load_extension 'ui-select'

local map = require('core.helpers').map

-- See `:help telescope.builtin`
local builtin = require 'telescope.builtin'
map('<leader>sh', builtin.help_tags, { desc = 'Telescope: [s]earch [h]elp', silent = false })
map('<leader>sk', builtin.keymaps, { desc = 'Telescope: [s]earch [k]eymaps', silent = false })
map('<leader>sf', builtin.find_files, { desc = 'Telescope: [s]earch [f]iles', silent = false })
map('<leader>sp', builtin.builtin, { desc = 'Telescope: [s]earch Telescope built-in [p]ickers', silent = false })
map('<leader>fw', builtin.grep_string, { desc = 'Telescope: [f]ind current [w]ord', silent = false })
map('<leader>lg', builtin.live_grep, { desc = 'Telescope: [l]ive [g]rep workspace files', silent = false })
map('<leader>sd', builtin.diagnostics, { desc = 'Telescope: [s]earch [d]iagnostics', silent = false })
map('<leader>rf', builtin.oldfiles, { desc = 'Telescope: [r]ecent [f]iles', silent = false })
map('<leader>sc', builtin.commands, { desc = 'Telescope: [s]earch [c]ommands', silent = false })
map('<leader>of', builtin.buffers, { desc = 'Telescope: list [o]pen [f]iles', silent = false })

-- This runs on LSP attach per buffer (see main LSP attach function in 'neovim/nvim-lspconfig' config for more info,
-- it is better explained there). This allows easily switching between pickers if you prefer using something else!
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
  callback = function(event)
    local buf = event.buf

    -- Find references for the word under your cursor.
    map('grr', builtin.lsp_references, { buffer = buf, desc = 'Telescope: [g]oto [r]eferences', silent = false })

    -- Jump to the implementation of the word under your cursor.
    -- Useful when your language has ways of declaring types without an actual implementation.
    map('gri', builtin.lsp_implementations, { buffer = buf, desc = 'Telescope: [g]oto [i]mplementation', silent = false })

    -- Jump to the definition of the word under your cursor.
    -- This is where a variable was first declared, or where a function is defined, etc.
    -- To jump back, press <C-t>.
    map('grd', builtin.lsp_definitions, { buffer = buf, desc = 'Telescope: [g]oto [d]efinition', silent = false })

    -- Fuzzy find all the symbols in your current document.
    -- Symbols are things like variables, functions, types, etc.
    map('gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Telescope: open Document Symbols', silent = false })

    -- Fuzzy find all the symbols in your current workspace.
    -- Similar to document symbols, except searches over your entire project.
    map('gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Telescope: open [w]orkspace Symbols', silent = false })

    -- Jump to the type of the word under your cursor.
    -- Useful when you're not sure what type a variable is and you want to see
    -- the definition of its *type*, not where it was *defined*.
    map('grt', builtin.lsp_type_definitions, { buffer = buf, desc = 'Telescope: [g]oto [t]ype Definition', silent = false })
  end,
})

-- Search through linux man pages
map('<leader>sm', function()
  builtin.man_pages {
    sections = { 'ALL' },
  }
end, { desc = 'Telescope: [s]earch [m]an pages', silent = false })

-- Slightly advanced example of overriding default behavior and theme
map('<leader>/', function()
  -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = 'Telescope: fuzzy find in current buffer', silent = false })

-- It's also possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
map(
  '<leader>go',
  function()
    builtin.live_grep {
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    }
  end,
  { desc = 'Telescope: [g]rep in [o]pen files', silent = false }
)

-- Shortcut for searching your Neovim configuration files
map('<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = 'Telescope: [s]earch [n]eovim files', silent = false })
