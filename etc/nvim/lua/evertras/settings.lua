vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.termguicolors = true

vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'

vim.opt.incsearch = true

vim.opt.mouse = ''

vim.opt.splitright = true
vim.opt.splitbelow = true

-- Don't automatically create comment leads on new lines after a comment
vim.cmd("autocmd BufEnter * set formatoptions-=cro")

-- .nomad files are HCL
vim.cmd("autocmd BufEnter *.nomad set filetype=hcl")

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Start unfolded
vim.cmd("autocmd BufEnter,Syntax * normal zz")

-- Autoreload kitty config
vim.cmd("autocmd bufwritepost ~/.config/kitty/* :silent !kill -SIGUSR1 $(pgrep kitty)")
