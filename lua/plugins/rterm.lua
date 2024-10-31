return {
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' }),
  vim.keymap.set('n', '<C-t>', function()
    vim.api.nvim_open_win(0, true, {
      split = 'below',
      win = 0,
      height = 14,
    })
    vim.cmd 'term'
    vim.cmd 'startinsert'
  end, { desc = 'Splits horizontally and creates a terminal buffer' }),
}
