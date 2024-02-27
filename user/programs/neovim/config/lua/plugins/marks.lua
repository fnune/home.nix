return {
  "chentoast/marks.nvim",
  config = function()
    vim.cmd([[highlight link MarkSignHL @comment.note]])

    local marks = require("marks")
    marks.setup({ default_mappings = true, force_write_shada = true })

    -- Disable lowercase marks: I don't use them, and I want to
    -- use the m[a-z] mapping space for other mappings set below.
    for char = string.byte("a"), string.byte("z") do
      vim.api.nvim_set_keymap("n", "m" .. string.char(char), "<Nop>", { noremap = true })
    end

    local m = require("mapx")
    m.nname("m", "Marks")
    m.nmap("ma", ":MarksListAll<cr>", { silent = true }, "Show all marks")

    m.nmap("mx", function()
      if vim.fn.confirm("Clear all marks?", "&Yes\n&No", 2) == 1 then
        vim.cmd([[delmarks a-zA-Z0-9]])
      end
    end, "Clear all marks")
  end,
}
