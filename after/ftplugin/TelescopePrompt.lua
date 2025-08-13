vim.o.autocomplete = false
local id
id = vim.api.nvim_create_autocmd("BufLeave", {
  callback = function()
    vim.o.autocomplete = true
    vim.schedule(vim.fn['lightline#update'])
    vim.api.nvim_del_autocmd(id)
  end,
})
