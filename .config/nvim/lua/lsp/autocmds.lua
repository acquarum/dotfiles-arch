vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('on-lsp-attach', { clear = true }),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

    local map = require('core.helpers').map

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    if client:supports_method('textDocument/rename', ev.buf) then
      map('grn', vim.lsp.buf.rename, { desc = 'LSP: [r]e[n]ame', silent = false })
    end

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    if client:supports_method('textDocument/codeAction', ev.buf) then
      map(
        'gra',
        vim.lsp.buf.code_action,
        { desc = 'LSP: code [a]ction', mode = { 'n', 'x' }, silent = false }
      )
    end

    --- Run the code lens under your cursor
    if client:supports_method('textDocument/codeLens', ev.buf) then
      map('grx', vim.lsp.codelens.run, { desc = 'LSP: run code lens', mode = 'n', silent = false })
    end

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    if client:supports_method('textDocument/declaration', ev.buf) then
      map('grD', vim.lsp.buf.declaration, { desc = 'LSP: [g]oto [D]eclaration', silent = false })
    end

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    if client:supports_method('textDocument/documentHighlight', ev.buf) then
      local highlight_group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = ev.buf,
        group = highlight_group,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = ev.buf,
        group = highlight_group,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('on-lsp-detach', { clear = true }),
        callback = function(event)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event.buf }
        end,
      })
    end

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    if client:supports_method('textDocument/inlayHint', ev.buf) then
      map(
        '<leader>th',
        function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = ev.buf }) end,
        'LSP: [t]oggle Inlay [h]ints'
      )
    end
  end,
})
