%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "test/", "priv/", "config/"],
        excluded: [~r"/_build/", ~r"/deps/"]
      },
      checks: [
        {Credo.Check.Readability.ModuleDoc, false},

        {Credo.Check.Refactor.FunctionArity, false},
      ]
    }
  ]
}
