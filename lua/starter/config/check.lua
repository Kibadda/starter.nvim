local M = {}

--- small wrapper around vim.validate
---@param path string
---@param tbl table
---@return boolean
---@return string?
local function validate(path, tbl)
  local prefix = "invalid config: "
  local ok, err = pcall(vim.validate, tbl)
  return ok or false, prefix .. (err and path .. "." .. err or path)
end

--- validate given config
---@param config starter.internalconfig
---@return boolean
---@return string?
function M.validate(config)
  local ok, err

  ok, err = validate("starter", {
    items = { config.items, "function", true },
    options = { config.options, "table", true },
    indicator = { config.indicator, "string", true },
    keys = { config.keys, "string", true },
    highlights = { config.highlights, "table", true },
    border = {
      config.border,
      function(a)
        return a == nil or (type(a) == "table" and #a == 8)
      end,
    },
  })
  if not ok then
    return false, err
  end

  ok, err = validate("starter.highlights", {
    Day = { config.highlights.Day, "table", true },
    Selected = { config.highlights.Selected, "table", true },
    Indicator = { config.highlights.Indicator, "table", true },
    Match = { config.highlights.Match, "table", true },
  })
  if not ok then
    return false, err
  end

  return true
end

return M
