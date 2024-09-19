return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = function()
      local comment_ts = require("ts_context_commentstring")
      comment_ts.setup({ enable_autocmd = false })

      local comment = require("Comment")
      local comment_ts_integration = require("ts_context_commentstring.integrations.comment_nvim")
      comment.setup({ pre_hook = comment_ts_integration.create_pre_hook() })
    end,
  },
}
