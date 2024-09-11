---@class starter.item
---@field text string
---@field action function

---@class starter.config
---@field items fun(): starter.item[]
---@field options table

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
}

---@type starter.config | (fun(): starter.config) | nil
vim.g.starter = vim.g.starter

---@type starter.config
local opts = type(vim.g.starter) == "function" and vim.g.starter() or vim.g.starter or {}

---@type starter.internalconfig
local StarterConfig = vim.tbl_deep_extend("force", {}, StarterDefaultConfig, opts)

local check = require "starter.config.check"
local ok, err = check.validate(StarterConfig)
if not ok then
  vim.notify("starter: " .. err, vim.log.levels.ERROR)
end

return StarterConfig
