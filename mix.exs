defmodule Datex.MixProject do
  use Mix.Project

  def project do
    [
      app: :datex,
      version: "1.0.0",
      elixir: "~> 1.7",
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

    Compare dates and time, obtain results in formats you want to use. Convert any date, time formats to elixir formats and vice-versa.

    Get current date, yesterday, tommmorow with or without time zones(utc by default).
    """
  end

  defp package do
    %{ licenses: ["MIT"],
       maintainers: ["Suraj Kumar"],
       links: %{ "GitHub" => "https://github.com/AltCampus/datex"},
       files: ~w(lib mix.exs README* LICENSE*)
     }
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.19.1"}
    ]
  end
end
