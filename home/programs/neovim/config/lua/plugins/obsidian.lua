return {
  "obsidian-nvim/obsidian.nvim",
  lazy = false,
  dependencies = { "nvim-lua/plenary.nvim" },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown" },
      callback = function()
        vim.opt_local.conceallevel = 2
      end,
    })
  end,
  opts = {
    ui = {
      enable = false, -- Using render-markdown.nvim
    },
    completion = {
      nvim_cmp = false,
      blink = true,
    },
    workspaces = {
      {
        name = "main",
        path = "~/Dropbox/Vault",
      },
    },
    disable_frontmatter = true,
    preferred_link_style = "markdown",
    picker = {
      name = "snacks.pick",
    },
    checkbox = {
      order = { " ", "x" },
    },
    note_id_func = function(title)
      return title
    end,
    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      default_tags = { "daily" },
    },
    attachments = {
      img_folder = "./",
    },
  },
  keys = {
    {
      "<leader>on",
      function()
        vim.cmd("Obsidian today")
      end,
      desc = "Open today's note",
    },
    {
      "<leader>of",
      function()
        vim.cmd("Obsidian quick_switch")
      end,
      desc = "Find notes",
    },
    {
      "<leader>oF",
      function()
        vim.cmd("Obsidian search")
      end,
      desc = "Search within notes",
    },
  },
}
