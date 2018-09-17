# Datex

Human readable simple date and time library.

  It works with standard date and time as well as elixir date, time formats.

  You can get a specific day, date, add days to date and get results which are friendly and easy to understand.

  Compare dates and time, obtain results in formats you want to use. Convert any date, time formats to elixir formats and vice-versa.

  Get current date, yesterday, tommmorow with or without time zones(utc by default).

## Installation

Add Datex as a dependency to an Elixir project by adding it to your mix.exs file:

```elixir
defp deps do
  [
    {:datex, "~> 1.0.0"}
  ]
end
```

## Types
Datex has two types for now. Support for DateTime and NaiveDateTime will be added Soon.
* Datex.Date - A simple date with or without time_zone
* Datex.Time - A simple Time with or without time_zone

## Date Examples
Date provides simple date formats to work with and manipulate any date formats to either elixir or any nicer looking dates and vice-versa.

```

# Get today's Date
> Datex.Date.today()
"17 September, 2018"

# Get tomorrow's with a time zone.
> Datex.Date.tomorrow("Asia/Calcutta")
"18 September, 2018"

# Get day's short name from a date in any format
> Datex.Date.day_short("15th Aug, 2019")
"Thu"

# Get month name from a date(elixir or any standard date format).
> Datex.Date.month("25/7/2018")
"July"

# Add days to date and get return date in a nicer foramt.
> Datex.Date.add(~D[2018-09-10], 15, :nice_short_date)
"25 Sept, 2018"

# Get difference between 2 dates as integer where dates are specified in any format.
> Datex.Date.difference("25 march 2019", ~D[2018-10-24])
152

# Get array of dates in any standard date formats from a date range.
> range = Datex.Date.range("10 sept, 2018", "15 sept, 2018")
> iex()> Datex.Date.date_list(range, "DD.MM.YYYY")
["10.09.2018", "11.09.2018", "12.09.2018", "13.09.2018", "14.09.2018",
 "15.09.2018"] 
 
```

## Time Examples

Simple Time which can be used in different formats including elixir format.

It includes different functions to compare time and provide relative time in friendly formats and functions which can format time in multiple ways user needs.

```

# Get Current Time
> Datex.Time.now("Asia/Calcutta")
"06:10 PM"

# Add time in any unit and any standard fromat including elixir time format to get updated time.
> Datex.Time.add("12:45 pm", 5, :minute, :hour_12)
"12:50 PM"

# Compare 2 times and get result in friendly format.
> Datex.Time.compare("12:45 am", "00:00:00") 
"45 minutes later"

# Format time in desired format.
> Datex.Time.format("00:00:00", "12 HOUR FORMAT")
"12:00 AM"

```




Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/datex](https://hexdocs.pm/datex).

