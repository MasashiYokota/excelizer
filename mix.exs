defmodule Excelizer.MixProject do
  use Mix.Project

  @description """
    Excel reader and writer library powered by Excelize (https://github.com/360EntSecGroup-Skylar/excelize) via NIF.
  """

  def project do
    [
      app: :excelizer,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: @description,
      make_executable: "make",
      package: package(),
      compilers: [:elixir_make] ++ Mix.compilers(),
      docs: [
        main: "Excelizer",
        extras: ["README.md"]
      ]
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
      maintainers: ["Masashi Yokota"],
      files: ["lib", "LICENSE", "mix.exs", "README.md", "cgo_src", "Makefile"],
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/MasashiYokota/excelizer"
      }
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elixir_make, "~> 0.4", runtime: false},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:poison, "~> 4.0"}
    ]
  end
end
