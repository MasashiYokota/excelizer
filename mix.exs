defmodule Excelizer.MixProject do
  use Mix.Project

  def project do
    [
      app: :excelizer,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      make_executable: "make",
      package: package(),
      compilers: [:elixir_make] ++ Mix.compilers()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      files: ["lib", "LICENSE", "mix.exs", "README.md", "go_src/*.go", "Makefile"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elixir_make, "~> 0.4", runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:poison, "~> 4.0"}
    ]
  end
end
