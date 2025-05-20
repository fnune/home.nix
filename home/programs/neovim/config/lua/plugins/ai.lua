return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "stevearc/dressing.nvim",
  },

  config = function()
    require("avante").setup({
      provider = "gemini",
      gemini = { model = "gemini-2.5-flash-preview-04-17" },
      hints = { enabled = false },
      windows = { ask = { start_insert = false } },
      system_prompt = [[
        Important user preferences:
        - Never modify comments or add new comments. Instead, make
          your code self-explanatory using good variable names and semantics.
        - If the language allows it, make full use of static typing and
          inference.
        - If you need to provide a summary of what we've done, make it
          extremely concise regardless of what you've been asked to do before.
        - Never spend any words to say why your solution is good at the end of
          your response.
      ]],
      selector = { provider = "snacks" },
    })
  end,
}
