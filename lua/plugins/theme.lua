return {
  {
    'TheNiteCoder/mountaineer.vim',
    name = 'mountainer'
  },

  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'github_dark_default'

      vim.cmd.hi 'Comment gui=none'
    end,
  },
}
