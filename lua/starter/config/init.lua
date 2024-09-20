---@class starter.item
---@field text string
---@field action function

---@class starter.config.highlights
---@field Day? vim.api.keyset.highlight
---@field Selected? vim.api.keyset.highlight
---@field Indicator? vim.api.keyset.highlight
---@field Match? vim.api.keyset.highlight

---@class starter.config
---@field items? fun(): starter.item[]
---@field options? table
---@field highlights? starter.config.highlights
---@field indicator? string
---@field keys? string

---@class starter.internalconfig
local StarterDefaultConfig = {
  ---@return starter.item[]
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
  keys = "abcdefghijklmnopqrstuvwxyz ",
  highlights = {
    Day = { fg = "#EA6962" },
    Selected = { fg = "#7DAEA3" },
    Indicator = { fg = "#7DAEA3" },
    Match = { underline = true },
  },
  border = { "┌", "┐", "└", "┘", "─", "│", "├", "┤" },
}

---@type starter.config | (fun(): starter.config) | nil
vim.g.starter = vim.g.starter

---@type starter.config
local opts = type(vim.g.starter) == "function" and vim.g.starter() or vim.g.starter or {}

---@type starter.internalconfig
local StarterConfig = vim.tbl_deep_extend("force", {}, StarterDefaultConfig, opts)

-- FIX: highlights should overwrite defaults
for name, val in pairs(opts.highlights or {}) do
  StarterConfig.highlights[name] = val
end

local check = require "starter.config.check"
local ok, err = check.validate(StarterConfig)
if not ok then
  vim.notify("starter: " .. err, vim.log.levels.ERROR)
end

return StarterConfig
