# starter.nvim

## Configuration
To change the default configuration, set `vim.g.starter`.

Default config:
```lua
vim.g.starter = {
  items = function()
    return {}
  end,
  options = {
    timeoutlen = 1,
    listchars = "",
    cursorline = false,
    statuscolumn = "",
    signcolumn = "no",
    number = false,
    relativenumber = false,
    winbar = "",
  },
  indicator = ">",
  highlights = {
    Day = { fg = "#EA6962" },
    Selected = { fg = "#7DAEA3" },
    Indicator = { fg = "#7DAEA3" },
    Match = { underline = true },
  },
}
```
