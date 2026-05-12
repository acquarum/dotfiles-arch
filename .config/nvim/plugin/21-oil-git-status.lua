vim.pack.add {
  {
    src = 'https://github.com/refractalize/oil-git-status.nvim',
    name = 'oil-git-status',
  },
}

require('oil-git-status').setup {
  show_ignored = false, -- show files that match gitignore with !!
  symbols = { -- customize the symbols that appear in the git status columns
    index = {
      ['!'] = '!',
      ['?'] = '?',
      ['A'] = 'A',
      ['C'] = 'C',
      ['D'] = 'D',
      ['M'] = 'M',
      ['R'] = 'R',
      ['T'] = 'T',
      ['U'] = 'U',
      [' '] = ' ',
    },
    working_tree = {
      ['!'] = '!',
      ['?'] = '?',
      ['A'] = 'A',
      ['C'] = 'C',
      ['D'] = 'D',
      ['M'] = 'M',
      ['R'] = 'R',
      ['T'] = 'T',
      ['U'] = 'U',
      [' '] = ' ',
    },
  },
}

require('core.helpers').map( '<leader>or', function() require('oil-git-status').refresh_buffer(vim.api.nvim_get_current_buf()) end, 'Oil-git-status: refresh oil buffer')
