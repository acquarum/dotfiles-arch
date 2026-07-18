vim.pack.add {
  'https://github.com/lervag/vimtex',
}

vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_compiler_latexmk = {
  aux_dir = './build',
}
