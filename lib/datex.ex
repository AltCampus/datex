defmodule Datex do
  alias Datex.Date
  alias Datex.Time

  
  @moduledoc """
  Human readable simple date and time library.

  It works with standard date and time as well as elixir date, time formats.

  You can get a specific day, date, add days to date and get results which are friendly and easy to understand.

  Compare dates and time, obtain results in formats you want to use. Convert any date, time formats to elixir formats and vice-versa.

  Get current date, yesterday, tommmorow with or without time zones(utc by default).

  """

  @doc """
  Get yesterday's date

  ## Examples

      iex> Datex.Date.yesterday()
      "16 September, 2018"

  """

  def yesterday do
    Date.yesterday()
  end

  @doc """
  Format time in the way you specify and vice-versa.

  ## Examples

      iex> Datex.Time.format_time("12:45 pm", "elixir")
      ~T[12:45:00.000000]

  """

  def format_time(time, format) do
    Time.format_time(time, format)
  end

  @doc """
  Compare dates in two different formats including elixir format and get results in human readable and friendly way.

  ## Examples

      iex> Datex.Date.compare("18 Sept, 2018", "15/08/2018")
      "a month and 4 days later"

  """

  def compare_date(date1, date2) do
    Date.compare(date1, date2)
  end


end
