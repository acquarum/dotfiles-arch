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
  },
}

require('core.helpers').map( '<leader>fo', function() require('conform').format { lsp_format = 'fallback' } end, 'Conform: [fo]rmat current buffer' )
