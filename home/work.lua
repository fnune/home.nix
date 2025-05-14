local neotest = require("neotest")

neotest.setup_project(vim.loop.cwd(), {
  adapters = {
    require("neotest-golang")({
      env = {
        PULUMI_LOCAL_DB = "true",
        PULUMI_LOCAL_DATABASE_ENDPOINT = "127.0.0.1:3307",
        PULUMI_DATABASE_NAME = "pulumi",
        PULUMI_INSIGHTS_LOCAL_OBJECTS = "/tmp/pulumi-tests-insights-local-objects",
      },
    }),
  },
})
