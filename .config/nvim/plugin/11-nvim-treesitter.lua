vim.pack.add {
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = '4916d6592ede8c07973490d9322f187e07dfefac',
  },
}

local parsers = {
  'lua',
  'python',
  'c',
  'make',
  'bash',
  'zsh',
  'tmux',
  'toml',
  'json',
  'gitignore',
  'dockerfile',
  'yaml',
  'toml',
  'vim',
  'vimdoc',
  'luadoc',
}

require('nvim-treesitter').install(parsers)

---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
  -- Check if a parser exists and load it
  if not vim.treesitter.language.add(language) then
    return
  end
  -- Enable syntax highlighting and other treesitter features
  vim.treesitter.start(buf, language)

  -- Enable treesitter based folds
  -- For more info on folds see `:help folds`
  vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.wo.foldmethod = 'expr'

  -- Check if treesitter indentation is available for this language, and if so enable it
  -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
  if vim.treesitter.query.get(language, 'indents') ~= nil then
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

local available_parsers = require('nvim-treesitter').get_available()

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf, filetype = args.buf, args.match

    local language = vim.treesitter.language.get_lang(filetype)
    if not language then
      return
    end

    local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

    if not vim.tbl_contains(installed_parsers, language) and vim.tbl_contains(available_parsers, language) then
      -- If a parser is available in `nvim-treesitter` but is not installed, auto-install it
      require('nvim-treesitter').install(language):wait()
    end
    treesitter_try_attach(buf, language)
  end,
})
