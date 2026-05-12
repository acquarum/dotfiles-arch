vim.pack.add {
  { src = 'https://github.com/saghen/blink.cmp', version = 'v1.10.2' },
}

-- Plugin configuration
require('blink.cmp').setup {
  keymap = {
    preset = 'none',
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-e>'] = { 'hide', 'fallback' },
    ['<C-y>'] = { 'select_and_accept', 'fallback' },

    ['<C-k>'] = { 'select_prev', 'fallback_to_mappings' },
    ['<C-j>'] = { 'select_next', 'fallback_to_mappings' },

    ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

    ['<Tab>'] = { 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

    ['<C-n>'] = { 'show_signature', 'hide_signature', 'fallback' },
  },

  appearance = {
    nerd_font_variant = 'mono',
  },

  completion = {
    menu = { auto_show = true },
    documentation = { auto_show = false },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },

  signature = { enabled = true },

  fuzzy = {
    implementation = 'prefer_rust_with_warning',
    prebuilt_binaries = { download = true },
  },
}
