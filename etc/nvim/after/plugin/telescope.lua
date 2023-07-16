local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>gG', builtin.find_files, {})
vim.keymap.set('n', '<leader>gg', builtin.git_files, {})

vim.keymap.set('n', '<leader>gs', function()
  builtin.grep_string({ search = vim.fn.input("ag > ") });
end)
