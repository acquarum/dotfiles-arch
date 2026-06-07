vim.pack.add {
  'https://github.com/stevearc/conform.nvim',
}

require('conform').setup {
  notify_on_error = false,
  default_format_opts = {
    -- Use external formatters if configured below, otherwise use LSP formatting
    lsp_format = 'fallback',
  },
  formatters_by_ft = {
    lua = { 'stylua' },
    python = {
      -- To fix auto-fixable lint errors.
      'ruff_fix',
      -- To run the Ruff formatter.
      'ruff_format',
      -- To organize the imports.
      'ruff_organize_imports',
    },
  },
}

require('core.helpers').map(
  '<leader>fo',
  function() require('conform').format() end,
  'Conform: [fo]rmat current buffer'
)
