return {
  {
    'TheNiteCoder/mountaineer.vim',
    name = 'mountainer',
  },

  {
    'miikanissi/modus-themes.nvim',
    name = 'modus-themes',
  },

  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
  },

  {
    'e-q/okcolors.nvim',
    name = 'okolors',
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'okcolors-sharp'

      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
