---@class starter.class.options
---@field buf number

---@class starter.class
---@field new fun(opts: starter.class.options): starter.class
---@field items starter.item[]
---@field mapping { [string]: number }
---@field matches string[]
---@field selected number
---@field prompt string
---@field win number
---@field buf number
---@field ns number
---@field group number
---@field day string[]
---@field _saved_options table
---@field _offsets { width: number, left: number, top: number }?
local M = {}
M.__index = M

local char_width = #"│"

function M:setup()
  if not self.buf or not vim.api.nvim_buf_is_valid(self.buf) then
    return
  end

  local config = require "starter.config"

  for option, value in pairs(config.options) do
    self._saved_options[option] = vim.o[option]
    vim.o[option] = value
  end

  vim.api.nvim_win_set_hl_ns(self.win, self.ns)

  for name, val in pairs(config.highlights) do
    vim.api.nvim_set_hl(self.ns, name, val)
  end

  vim.api.nvim_create_autocmd("BufLeave", {
    group = self.group,
    buffer = self.buf,
    callback = function()
      self:teardown()
    end,
  })

  vim.api.nvim_create_autocmd("WinResized", {
    group = self.group,
    callback = function()
      self._offsets = self:calculate_offsets()
      self:display()
    end,
  })

  local function map(lhs, rhs)
    vim.keymap.set("n", lhs, rhs, { buffer = self.buf })
  end

  for key in config.keys:gmatch "." do
    map(key, function()
      self.prompt = self.prompt .. key
      self:display()
    end)
    map(key:upper(), function()
      self.prompt = self.prompt .. key:upper()
      self:display()
    end)
  end

  map("<BS>", function()
    self.prompt = self.prompt:sub(1, -2)
    self:display()
  end)
  map("<C-w>", function()
    local split = vim.split(self.prompt, " ", { trimempty = true })
    self.prompt = table.concat(split, " ", 1, #split - 1)
    self:display()
  end)
  map("<Esc>", function()
    self.prompt = ""
    self:display()
  end)

  map("<C-j>", function()
    if self.selected >= #self.matches then
      self.selected = 1
    else
      self.selected = self.selected + 1
    end
    self:display()
  end)
  map("<C-k>", function()
    if self.selected == 1 then
      self.selected = #self.matches
    else
      self.selected = self.selected - 1
    end
    self:display()
  end)

  map("<CR>", function()
    local match = self.matches[self.selected]
    local item = self.items[self.mapping[match]]
    self:teardown()
    item.action()
  end)
end

function M:calculate_offsets()
  local width = vim.fn.strdisplaywidth(self.day[1])
  return {
    width = width,
    left = math.max(0, math.floor((vim.o.columns - width) / 2)),
    top = math.max(0, math.floor((vim.o.lines - #self.day - #self.items - 9) / 2)),
  }
end

function M:display()
  if not self._offsets then
    self._offsets = self:calculate_offsets()
  end

  local lines = {}
  local extmarks = {}

  table.insert(lines, "┌" .. ("─"):rep(self._offsets.width + 4) .. "┐")
  table.insert(lines, "│" .. (" "):rep(self._offsets.width + 4) .. "│")
  for _, line in ipairs(self.day) do
    table.insert(lines, "│  " .. line .. "  │")
    table.insert(extmarks, { line = #lines - 1, col = char_width, end_col = char_width + #line, hl = "Day" })
  end
  local date = os.date "%d.%m.%Y"
  local date_offset = (self._offsets.width - #date) / 2
  table.insert(
    lines,
    "│  " .. (" "):rep(math.floor(date_offset)) .. date .. (" "):rep(math.ceil(date_offset)) .. "  │"
  )
  local v = vim.version()
  local version = ("NVIM v%d.%d.%d-%s"):format(v.major, v.minor, v.patch, v.prerelease)
  local version_offset = (self._offsets.width - #version) / 2
  table.insert(
    lines,
    "│  " .. (" "):rep(math.floor(version_offset)) .. version .. (" "):rep(math.ceil(version_offset)) .. "  │"
  )
  table.insert(lines, "│" .. (" "):rep(self._offsets.width + 4) .. "│")
  table.insert(lines, "├" .. ("─"):rep(self._offsets.width + 4) .. "┤")
  table.insert(lines, "│  " .. self.prompt .. (" "):rep(self._offsets.width - #self.prompt) .. "  │")
  table.insert(lines, "├" .. ("─"):rep(self._offsets.width + 4) .. "┤")

  self.matches = vim.tbl_map(function(item)
    return item.text
  end, self.items)
  local matches = { self.matches }
  if #self.prompt > 0 then
    matches = vim.fn.matchfuzzypos(self.matches, self.prompt)
    self.matches = matches[1]
  end

  if self.selected > #self.matches then
    self.selected = math.max(#self.matches, 1)
  end

  for i = 1, #matches[1] do
    local indicator = "  "
    if i == self.selected then
      indicator = "> "
      table.insert(extmarks, { line = #lines, col = char_width, end_col = char_width + 2, hl = "Indicator" })
      table.insert(
        extmarks,
        { line = #lines, col = char_width + 2, end_col = char_width + #matches[1][i] + 2, hl = "Selected" }
      )
    end
    if matches[2] then
      for _, pos in ipairs(matches[2][i]) do
        table.insert(
          extmarks,
          { line = #lines, col = char_width + pos + 2, end_col = char_width + pos + 3, hl = "Match" }
        )
      end
    end
    table.insert(
      lines,
      "│" .. indicator .. matches[1][i] .. (" "):rep(self._offsets.width - #matches[1][i]) .. "  │"
    )
  end

  table.insert(lines, "└" .. ("─"):rep(self._offsets.width + 4) .. "┘")

  for i = 1, #lines do
    lines[i] = (" "):rep(self._offsets.left) .. lines[i]
  end

  for _ = 1, self._offsets.top do
    table.insert(lines, 1, "")
  end

  vim.bo[self.buf].modifiable = true
  vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)
  vim.bo[self.buf].modifiable = false
  vim.bo[self.buf].modified = false
  vim.api.nvim_win_set_cursor(0, {
    self._offsets.top + #self.day + 7,
    self._offsets.left + #self.prompt + char_width + 2,
  })

  for _, extmark in ipairs(extmarks) do
    vim.api.nvim_buf_set_extmark(
      self.buf,
      self.ns,
      self._offsets.top + extmark.line,
      self._offsets.left + extmark.col,
      {
        end_line = self._offsets.top + extmark.line,
        end_col = self._offsets.left + extmark.end_col,
        hl_group = extmark.hl,
      }
    )
  end
end

function M:teardown()
  for option, value in pairs(self._saved_options) do
    vim.o[option] = value
  end

  vim.api.nvim_clear_autocmds { group = self.group }
  vim.api.nvim_win_set_hl_ns(self.win, 0)
end

function M.new(opts)
  local items = require("starter.config").items()

  local mapping = {}
  for i, item in ipairs(items) do
    mapping[item.text] = i
  end

  local starter = setmetatable({
    items = items,
    mapping = mapping,
    matches = {},
    selected = 1,
    prompt = "",
    buf = opts.buf,
    win = vim.api.nvim_get_current_win(),
    ns = vim.api.nvim_create_namespace "StarterNvim",
    group = vim.api.nvim_create_augroup("StarterNvim" .. opts.buf, { clear = true }),
    day = require("starter.days").get(),
    _saved_options = {},
  }, M) --[[@as starter.class]]

  starter:setup()

  return starter
end

return M
