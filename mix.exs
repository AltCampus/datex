defmodule Datex.MixProject do
  use Mix.Project

  def project do
    [
      app: :datex,
      version: "2.0.0",
      elixir: ">= 1.14.0",
      start_permanent: Mix.env() == :prod,
      package: package(),
      description: description(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    Human readable date and time library with flexible parsing and formatting.

    Supports standard date/time formats and Elixir formats. Features include:
    business day calculations, weekday utilities, time ranges, timezone conversion,
    and friendly human-readable outputs.
    """
  end

  defp package do
    %{
      licenses: ["MIT"],
      maintainers: ["Suraj Kumar"],
      links: %{"GitHub" => "https://github.com/AltCampus/datex"},
      files: ~w(lib mix.exs README* LICENSE*)
    }
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.29", only: :dev}
    ]
  end
end
