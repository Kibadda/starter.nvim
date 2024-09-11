local M = {}

function M.open(buf)
  local Starter = require "starter.class"

  local items = require("starter.config").items()

  Starter.new({
    buf = buf,
    items = items,
  }):display()
end

return M
