local function note_id(title)
  local suffix = "untitled"
  if title ~= nil then
    suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
  end
  return tostring(os.date("%Y-%m-%d")) .. "-" .. suffix
end

return {
  {
    "epwalsh/obsidian.nvim",
    lazy = true,
    ft = "markdown",
    cmd = {
      "ObsidianNew",
      "ObsidianQuickSwitch",
      "ObsidianSearch",
      "ObsidianTags",
      "ObsidianToday",
      "ObsidianTomorrow",
      "ObsidianYesterday",
    },
    enabled = false,
    version = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      note_id_func = note_id,
      daily_notes = { folder = "Daily" },
      attachments = { img_folder = "Pictures" },
      workspaces = { { name = "Main", path = "~/Storage/Vault" } },
    },
    init = function()
      vim.opt.conceallevel = 2

      local m = require("mapx")
      m.nname("<leader>o", "Obsidian")

      m.nmap("<leader>ot", ":vsplit | enew | ObsidianToday<CR>", { silent = true }, "Open today's note")
      m.nmap("<leader>oT", ":vsplit | enew | ObsidianTomorrow<CR>", { silent = true }, "Open tomorrow's note")
      m.nmap("<leader>oy", ":vsplit | enew | ObsidianYesterday<CR>", { silent = true }, "Open yesterday's note")
      m.nmap("<leader>on", ":vsplit | enew | ObsidianNew<CR>", { silent = true }, "Create a new document")

      m.nmap("<leader>of", ":ObsidianQuickSwitch<CR>", { silent = true }, "Find documents")
      m.nmap("<leader>os", ":ObsidianSearch<CR>", { silent = true }, "Search documents")

      m.nmap("<leader>oo", ":ObsidianOpen<CR>", { silent = true }, "Open in Obsidian")
      m.nmap("<leader>op", ":ObsidianPasteImg<CR>", { silent = true }, "Paste image")
      m.nmap("<leader>or", ":ObsidianRename<CR>", { silent = true }, "Rename current document")
    end,
  },
}
