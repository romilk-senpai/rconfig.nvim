return {
  {
    'miikanissi/modus-themes.nvim',
    name = 'modus-themes',
  },
  {
    'romilk-senpai/okcolors.nvim',
    name = 'okolors',
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'okcolors-sharp'

      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
