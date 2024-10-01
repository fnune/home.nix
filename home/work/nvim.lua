local neotest = require("neotest")

neotest.setup_project(vim.loop.cwd(), {
  adapters = {
    require("neotest-jest")({ jestCommand = "yarn workspace @memfault/app-frontend test:jest" }),
    require("neotest-python")({ args = { "-W", "ignore", "-vv" } }),
    require("neotest-vitest")({ vitestCommand = "yarn vitest" }),
  },
})

vim.o.makeprg = "./.git/hooks/pre-commit"

vim.g.dbs = {
  { name = "memfault-pg-local", url = "postgresql://memfault:memfault@localhost:5432/memfault_db" },
}

vim.o.shadafile = ".vim/memfault.shada"
