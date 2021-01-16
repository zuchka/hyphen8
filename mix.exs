defmodule Hyphen8.MixProject do
  use Mix.Project

  def project do
    [
      app: :hyphen8,
      version: "0.1.7",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "hyphen8",
      description: description(),
      package: package(),
      source_url: "https://github.com/zuchka/hyphen8",
      docs: [main: "readme", # The main page in the docs
            extras: ["README.md"],
            api_reference: false]

    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Hyphen8.Application, []}

    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:poolboy, "~> 1.5.1"},
      {:benchee, "~> 1.0", only: :dev},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp description() do
    "A concurrent and pure-Elixir port of the Knuth-Liang Hyphenation Algorithm."
  end

  defp package() do
    [
      # These are the default files included in the package
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/zuchka/hyphen8"}
    ]
  end
end
