local neotest = require("neotest")

local tags = "-tags=integration"

neotest.setup_project(vim.loop.cwd(), {
  adapters = {
    require("neotest-golang")({
      go_test_args = { "-v", "-race", "-count=1", tags },
      go_list_args = { tags },
      dap_go_opts = { delve = { build_flags = { tags } } },
    }),
  },
})
