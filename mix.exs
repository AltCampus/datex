defmodule Datex.MixProject do
  use Mix.Project

  def project do
    [
      app: :datex,
      version: "2.1.0",
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
    Human readable simple date and time library.

    It works with standard date and time as well as elixir date, time formats.

    You can get a specific day, date, add days to date and get results which are friendly and easy to understand.

    New features include:
    - Business day calculations
    - Weekday and month utilities (is_weekend?, is_leap_year?, beginning_of_month, end_of_month)
    - Next weekday and nth weekday of month functions
    - Time range generation and timezone conversion
    - Time validation and period detection
    - Quarter and week number calculations

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
