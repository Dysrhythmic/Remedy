defmodule Remedy.MixProject do
  use Mix.Project

  def project do
    [
      app: :remedy,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {RemedySupervisor, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  def deps do
    [
      {:dotenv_parser, "~> 2.0", only: :dev},
      {:nostrum, "~> 0.5.1"}
    ]
  end
end
