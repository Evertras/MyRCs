local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(_, bufnr)
  lsp.default_keymaps({buffer = bufnr})

  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>h', vim.lsp.buf.signature_help, opts)
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()
