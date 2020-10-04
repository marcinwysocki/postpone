defmodule Postpone.MixProject do
  use Mix.Project

  def project do
    [
      app: :postpone,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      package: package(),
      description: description(),
      deps: deps(),

      # Docs
      name: "Postpone",
      source_url: "https://github.com/marcinwysocki/postpone",
      homepage_url: "https://hexdocs.pm/postpone",
      docs: [
        main: "Postpone",
        extras: ["README.md"],
        authors: ["Marcin Wysocki"]
      ],
      licenses: ["MIT"]
    ]
  end

  defp description() do
    "A set of helpers for testing `timer`-based code, inspired by Jest."
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/marcinwysocki/postpone"},
      maintainers: ["Marcin Wysocki"]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Postpone.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mock, "~> 0.3.5", only: :test},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false}
    ]
  end
end
