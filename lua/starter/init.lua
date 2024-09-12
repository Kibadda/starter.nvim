local M = {}

function M.open(buf)
  local Starter = require "starter.class"

  Starter.new({
    buf = buf,
  }):display()
end

return M
