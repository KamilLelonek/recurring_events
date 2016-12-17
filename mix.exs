defmodule RecurringEvents.Mixfile do
  use Mix.Project

  def project do
    [
      app:             :recurring_events,
      build_embedded:  Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      elixir:          "~> 1.3",
      version:         "0.1.0",
      deps:            deps(),
      aliases:         aliases(),
      elixirc_paths:   elixirc_paths(Mix.env),
    ]
  end

  def application do
    [
      mod:          {RecurringEvents, []},
      applications: apps(),
    ]
  end

  defp deps() do
    [
      {:ecto,        "~> 2.1"},
      {:postgrex,    "~> 0.13"},
      {:exnumerator, "~> 1.2"},
      {:ex_machina,  "~> 1.0", only: :test},
      {:credo,       "~> 0.5", only: [:dev, :test]},
    ]
  end

  defp apps() do
    ~w(
      logger
      ecto
      postgrex
      exnumerator
    )a
  end

  defp aliases() do
    [
      "ecto.reset": ["ecto.drop", "ecto.create", "ecto.migrate"],
      "test":       ["ecto.reset", "test"],
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]
end
