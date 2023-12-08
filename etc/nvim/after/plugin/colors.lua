-- Customize catppuccin
require("catppuccin").setup({
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  background = {     -- :h background
    light = "latte",
    dark = "mocha",
  },
  transparent_background = true, -- disables setting the background color.
  show_end_of_buffer = false,    -- shows the '~' characters after the end of buffers
  styles = {                     -- Handles the styles of general hi groups (see `:h highlight-args`):
    comments = { "italic" },     -- Change the style of comments
    conditionals = { "italic" },
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  color_overrides = {},
  custom_highlights = function(colors)
    -- Show up on a dark wallpaper better
    -- https://github.com/catppuccin/nvim/blob/main/lua/catppuccin/groups/editor.lua
    return {
      Comment = { fg = colors.peach },
      LineNr = { fg = colors.sky },
    }
  end,
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    telescope = true,
    notify = false,
    mini = false,
    rainbow_delimiters = true,
    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  },
})

-- actually pick the color scheme
vim.cmd.colorscheme "catppuccin"
