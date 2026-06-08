if vim.g.loaded_mdread then return end
vim.g.loaded_mdread = true

local SUBS = { "toggle", "enter", "exit" }

vim.api.nvim_create_user_command("Mdread", function(opts)
  local sub = (opts.fargs[1] or "toggle"):lower()
  local mdread = require("mdread")
  if sub == "toggle" then
    mdread.toggle()
  elseif sub == "enter" then
    mdread.enter()
  elseif sub == "exit" then
    mdread.exit()
  else
    vim.notify("Mdread: unknown subcommand '" .. sub .. "' (expected " .. table.concat(SUBS, "|") .. ")",
      vim.log.levels.WARN)
  end
end, {
  nargs = "?",
  complete = function(arglead)
    local out = {}
    for _, s in ipairs(SUBS) do
      if vim.startswith(s, arglead) then table.insert(out, s) end
    end
    return out
  end,
  desc = "mdread: markdown reading mode (outline + md-render preview)",
})
