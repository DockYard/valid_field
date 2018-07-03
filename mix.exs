defmodule ValidField.Mixfile do
  use Mix.Project
  @version "0.6.0"

  def project do
    [
      app: :valid_field,
      version: @version,
      elixir: "~> 1.3",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Hex
      description: description(),
      package: package(),

      # Docs
      name: "ValidField",
      docs: [
        source_ref: "v#{@version}",
        main: "ValidField",
        source_url: "https://github.com/DockYard/valid_field"
      ]
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp description do
    """
    ValidField aids unit testing a changeset for valid (and invalid) fields
    """
  end

  defp package do
    [
      maintainers: ["Brian Cardarella"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/DockYard/valid_field"},
      files: ~w(mix.exs README.md lib test) ++ ~w(test)
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:ecto, "~> 2.2.0", only: [:dev, :test]},
      {:ex_doc, "~> 0.18.3", only: :dev},
      {:inch_ex, ">= 0.0.0", only: :dev}
    ]
  end
end
