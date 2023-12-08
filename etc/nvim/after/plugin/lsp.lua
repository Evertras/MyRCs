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

-- Add Terraform LSP
-- https://github.com/hashicorp/terraform-ls/blob/main/docs/installation.md
require('lspconfig.configs').terraform = {
  default_config = {
    name = 'terraform',
    cmd = { 'terraform-ls' },
    filetypes = { 'tf' },
  }
}

-- Add JSON/YAML schemas
require('lspconfig').jsonls.setup {
  settings = {
    json = {
      schemas = {
        {
          description = 'Prettier config',
          fileMatch = { '.prettierrc', '.prettierrc.json', 'prettier.config.json' },
          url = 'http://json.schemastore.org/prettierrc'
        },
      }
    },
  }
}

require('lspconfig').yamlls.setup {
  settings = {
    yaml = {
      schemaStore = {
        enable = false,
        url = "",
      },
      schemas = require('schemastore').yaml.schemas(),
      --['http://json.schemastore.org/github-workflow'] = '.github/workflows/*.{yml,yaml}',
      --['https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json'] = 'specs/*.{yml,yaml}',
    }
  }
}

-- Tweak cmp
local cmp = require('cmp')

cmp.setup({
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'buffer',                 keyword_length = 3 },
  },
  mapping = {
    ['C-e'] = cmp.mapping.complete(),
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

-- Add navic
-- https://github.com/SmiteshP/nvim-navic#%EF%B8%8F-setup

local navic = require('nvim-navic')

navic.setup({
  lsp = {
    auto_attach = true,
  },
})
