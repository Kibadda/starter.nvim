if vim.fn.argc() > 0 or vim.g.loaded_starter then
  return
end

vim.g.loaded_starter = 1

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("StarterNvim", { clear = true }),
  callback = function()
    require("starter").open(vim.api.nvim_get_current_buf())
  end,
})
