local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(_, bufnr)
  lsp.default_keymaps({ buffer = bufnr })

  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>h', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>F', vim.cmd.LspZeroFormat, opts)
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

-- Tweak cmp
local cmp = require('cmp')

cmp.setup({
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'buffer',                 keyword_length = 3 },
  },
})

-- Enable quickfixes
local function quickfix()
  vim.lsp.buf.code_action({
    -- This is supposed to autoselect the desired fix, but this doesn't
    -- seem to work properly in Go for pulling in imports... leaving
    -- it here for reference to see if I can get it to work better in
    -- the future
    --filter = function(a) return a.isPreferred end,
    apply = true
  })
end

vim.keymap.set('n', '<leader>f', quickfix)

-- Autoformat on save
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
