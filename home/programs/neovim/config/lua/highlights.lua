local M = {}

M.make_theme = function(opts)
  local enabled = os.getenv("COLORSCHEME") == opts.name
  return {
    opts.repo,
    name = opts.name,
    version = opts.version,
    branch = opts.branch,
    lazy = not enabled,
    priority = 1000,
    dev = opts.dev or false,
    dir = opts.dir,
    config = function(plugin)
      if opts.config then
        opts.config(plugin)
      end

      vim.g.ThemePalette = opts.palette or function()
        return {}
      end

      if enabled then
        vim.cmd.colorscheme(opts.colorscheme or opts.name)
      end

      vim.opt.termguicolors = true
    end,
  }
end

M.get_palette = function()
  return vim.g.ThemePalette()
end

return M
