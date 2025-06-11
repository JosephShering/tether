defmodule Tether.MixProject do
  use Mix.Project

  @version "0.1.1"

  def project do
    [
      app: :tether,
      version: @version,
      elixir: "~> 1.12",
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Tether.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:jason, "~> 1.2"},
      {:httpoison, "~> 1.8"},
      {:inflex, "~> 2.1"}
    ]
  end

  defp package() do
    [
      organization: "smartrent",
      files: ~w(lib mix.exs README*),
      links: %{"GitHub" => "https://github.com/smartrent/tether"}
    ]
  end
end
