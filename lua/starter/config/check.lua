local M = {}

--- validate given config
---@param config starter.internalconfig
---@return boolean
---@return string[]
function M.validate(config)
  local errors = {}

  --- small wrapper around vim.validate
  ---@param name string
  ---@param value any
  ---@param types any|any[]
  ---@param optional? boolean
  ---@return boolean
  local function validate(name, value, types, optional)
    local ok, err = pcall(vim.validate, name, value, types, optional)

    if not ok then
      table.insert(errors, err)
    end

    return ok
  end

  validate("starter.items", config.items, "function", true)
  validate("starter.options", config.options, "table", true)
  validate("starter.indicator", config.indicator, "string", true)
  validate("starter.keys", config.keys, "string", true)
  validate("starter.border", config.border, function(a)
    return a == nil or (type(a) == "table" and #a == 8)
  end, true)

  if validate("starter.highlights", config.highlights, "table", true) and config.highlights then
    validate("starter.highlights.Day", config.highlights.Day, "table", true)
    validate("starter.highlights.Selected", config.highlights.Selected, "table", true)
    validate("starter.highlights.Indicator", config.highlights.Indicator, "table", true)
    validate("starter.highlights.Match", config.highlights.Match, "table", true)
  end

  return #errors == 0, errors
end

return M
