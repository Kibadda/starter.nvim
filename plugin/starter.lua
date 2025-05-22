if vim.g.loaded_starter then
  return
end

vim.g.loaded_starter = 1

vim.api.nvim_create_user_command("Starter", function()
  require("starter").open()
end, {
  bang = false,
})

if vim.fn.argc() == 0 then
  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("StarterNvim", { clear = true }),
    callback = function()
      vim.cmd.Starter()
    end,
  })
end
