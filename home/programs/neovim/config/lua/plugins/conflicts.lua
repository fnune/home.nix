return {
  "akinsho/git-conflict.nvim",
  config = function()
    local git_conflict = require("git-conflict")

    git_conflict.setup({
      disable_diagnostics = true,
      default_mappings = {
        ours = "co",
        theirs = "ct",
        none = "c0",
        both = "cb",
        next = "<leader>j",
        prev = "<leader>k",
      },
    })
  end,
}
