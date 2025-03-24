return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "stevanmilic/neotest-scala", -- Ajout de l'adaptateur Scala
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-scala")({
            runner = "sbt", -- ou "bloop" selon votre setup
            -- framework = "munit", -- ou "utest", "munit"
            -- args = {}, -- Options supplémentaires pour sbt
          }),
        },
      })
    end,
  },
}
