local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Fuzzy finder
  -- https://github.com/nvim-telescope/telescope.nvim
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.2',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  -- For more color repo options:
  -- https://github.com/topics/neovim-colorscheme
  use { "catppuccin/nvim", as = "catppuccin" }

  -- For syntax highlighting
  -- https://github.com/nvim-treesitter/nvim-treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
  }
  use 'nvim-treesitter/playground'

  -- https://github.com/VonHeikemen/lsp-zero.nvim
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' }, -- Required
      {                            -- Optional
        'williamboman/mason.nvim',
        run = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },                    -- Required
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-nvim-lsp' },                -- Required
      { 'hrsh7th/cmp-nvim-lsp-signature-help' }, -- Show signatures while typing
      { 'L3MON4D3/LuaSnip' },                    -- Required
    }
  }

  -- https://github.com/simrat39/rust-tools.nvim
  use 'simrat39/rust-tools.nvim'

  -- JSON/YAML schema support
  -- https://github.com/b0o/SchemaStore.nvim
  use 'b0o/schemastore.nvim'

  -- Status line at the bottom
  -- https://github.com/nvim-lualine/lualine.nvim
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  -- Shows a git gutter on the left for changes
  use 'lewis6991/gitsigns.nvim'

  -- File explorer/tree
  use 'nvim-tree/nvim-tree.lua'
  use 'nvim-tree/nvim-web-devicons'

  -- Highlight characters to jump to in line
  use 'unblevable/quick-scope'

  -- Copilot (personal) (DISABLED for now due to performance issues)
  --use 'github/copilot.vim'

  -- Debugger
  -- https://github.com/mfussenegger/nvim-dap
  use 'mfussenegger/nvim-dap'
  -- https://github.com/leoluz/nvim-dap-go
  use 'leoluz/nvim-dap-go'

  -- See where we are in code contexts
  -- https://github.com/SmiteshP/nvim-navic
  use 'SmiteshP/nvim-navic'

  -- Rainbow delimiters to more easily see matching brackets
  use 'HiPhish/rainbow-delimiters.nvim'

  -- See code symbols as a tree for easier navigation in larger files
  use 'simrat39/symbols-outline.nvim'

  -- Automatically set up configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
