defmodule Datex.Date do

  alias Datex.Timezones

  @months_short_name %{1 => "Jan", 2 => "Feb", 3 => "Mar", 4 => "Apr", 5 => "May", 6 => "June", 7 => "July", 8 => "Aug", 9 => "Sept", 10 => "Oct", 11 => "Nov", 12 => "Dec"}

  @months %{1 => "January", 2 => "February", 3 => "March", 4 => "April", 5 => "May", 6 => "June", 7 => "July", 8 => "August", 9 => "September", 10 => "October", 11 => "November", 12 => "December"}

  @months_number %{"Jan" => 1, "jan" => 1, "January" => 1, "january" => 1, "Feb" => 2, "feb" => 2, "february" => 2, "February" => 2, "Mar" => 3, "mar" => 3, "March" => 3, "march" => 3, "Apr" => 4, "apr" => 4, "april" => 4, "April" => 4, "may" => 5, "May" => 5, "June" => 6, "june" => 6, "jun" => 6, "Jun" => 6, "Jul" => 7, "jul" => 7, "july" => 7, "July" => 7, "Aug" => 8, "aug" => 8, "August" => 8, "august" => 8, "Sep" => 9, "sep" => 9, "Sept" => 9, "sept" => 9, "September" => 9, "september" => 9, "Oct" => 10, "oct" => 10, "October" => 10, "october" => 10, "Nov" => 11, "nov" => 11, "November" => 11, "november" => 11, "Dec" => 12, "dec" => 12, "December" => 12, "december" => 12}

  @days %{1 => "Monday", 2 => "Tuesday", 3 => "Wednesday", 4 => "Thursday", 5 => "Friday", 6 => "Saturday", 7 => "Sunday"}

  @days_short_name %{1 => "Mon", 2 => "Tue", 3 => "Wed", 4 => "Thu", 5 => "Fri", 6 => "Sat", 7 => "Sun"}

	
	@moduledoc """
  Date provides simple date formats to work with and manipulate any date formats to either elixir or any nicer looking dates.
  """

  @doc """
  Get current date with or without time zone. 

  It takes 2 optional parameters i.e, `time_zone` as first params and `format` as second.
  Without any params ie today/0 will return utc_date in a nicer format.

  today/1 will need a time_zone which is specified in timezones.

  For a different format other than `:nice_date` like `:elixir` or `:nice_short_date`, 
  You need to specify first argument along with format as second argument. Pass `:utc` as first argument for default.

  ## Examples

      iex()> Datex.Date.today()
      "15 September, 2018"

      iex()> Datex.Date.today("Pacific/Samoa")
      "15 September, 2018"

      iex()> Datex.Date.today("Pacific/Samoa", :elixir)
      ~D[2018-09-15]

      iex()> Datex.Date.today(:utc, :nice_short_date)
      "15 Sept, 2018"

  """

  def today(time_zone \\ :utc, format \\ :nice_date) do
    utc_date = Date.utc_today()

    case time_zone do
      :utc -> utc_date |> show_date(format)
      _ -> 
        naive_to_date(time_zone)
        |> show_date(format)
    end
  end

  @doc """
  Get tomorrow's date with or without time zone in similar syntax as today. 

  ## Examples

      iex()> Datex.Date.tomorrow()
      "16 September, 2018"
      
      iex()> Datex.Date.tomorrow("Asia/Calcutta", :elixir)
      ~D[2018-09-16]

  """

  def tomorrow(time_zone \\ :utc, format \\ :nice_date) do
    case time_zone do
      :utc -> 
        Date.utc_today()
        |> Date.add(1)
        |> show_date(format)
      _ -> 
        naive_to_date(time_zone)
        |> Date.add(1)
        |> show_date(format)
    end
  end

  @doc """
  Get yesterday's date with or without time zone in similar syntax as today/tomorrow. 

  ## Examples

      iex()> Datex.Date.yesterday()
      "14 September, 2018"
      
      iex(4)> Datex.Date.yesterday("Asia/Calcutta", :nice_short_date)
      "14 Sept, 2018"

  """

  def yesterday(time_zone \\ :utc, format \\ :nice_date) do
    case time_zone do
      :utc -> 
        Date.utc_today()
        |> Date.add(-1)
        |> show_date(format)
      _ -> 
        naive_to_date(time_zone)
        |> Date.add(-1)
        |> show_date(format)
    end
  end

  @doc """
  Get day as `String` for a particular date in any format. 

  For example date formats like `DD-MM-YYYY`, `10th Oct, 2019`, `YYYY-MM-DD`, 
  `DD/MM/YYYY`, `DD.MM.YYYY` or even elixir dates. 

  ## Examples

      iex()> Datex.Date.day("12 Sept, 2017")
      "Tuesday"
      
      iex()> Datex.Date.day("12/7/2018")
      "Thursday"

      iex()> Datex.Date.day(~D[1997-02-23])
      "Sunday"

  """

  def day(date) do
    @days[day_of_week(date)]
  end

  @doc """
  Returns shory name of day as `String` for a particular date in any format. 

  For example date formats like `DD-MM-YYYY`, `10th Oct, 2019`, `YYYY-MM-DD`, 
  `DD/MM/YYYY`, `DD.MM.YYYY` or even elixir dates. 

  ## Examples

      iex()> Datex.Date.day_short("12 Sept, 2017")
      "Tue"

  """

  def day_short(date) do
    @days_short_name[day_of_week(date)]
  end

  @doc """
  Get day of week as `Integer` for a particular date in any format. `Monday` is `1` and `Sunday` as `7`. 

  ## Examples

      iex()> Datex.Date.day_of_week("15th Sept 2018")
      6

  """

  def day_of_week(date) do
    date = check_date(date)
    Date.day_of_week(date)
  end

  @doc """
  Get number of days in a month as `Integer` for a particular date in any format. 

  ## Examples

      iex()> Datex.Date.days_in_month("2018/09/25")
      30

  """

  def days_in_month(date) do
    date = check_date(date)
    Date.days_in_month(date)
  end

  @doc """
  Get month name as `String` for a particular date in any format. 

  ## Examples

      iex()> Datex.Date.month("2018-9-25")
      "September"

  """

  def month(date) do
    date = check_date(date)
    month_name(date.month)
  end

  @doc """
  Get year as `Integer` for a particular date in any format. 

  ## Examples

      iex()> Datex.Date.year("5th Jan, 2030")
      2030

  """

  def year(date) do
    date = check_date(date)
    date.year
  end

  @doc """
  Add days to date. 

  It takes 2 arguments and an optional 3rd argument. First argument is `Date` in elixir date format or standard date as `String`, second is `number of days`.
  Third argument is format like `:nice_date`, `:elixir`, `:nice_short_date`. 

  It returns date in formats specified in `today()` function. 

  ## Examples

      iex()> Datex.Date.add("15 Oct, 2018", 10)
      "25 October, 2018"

      iex()> Datex.Date.add("20/10/2018", 13, :elixir)
      ~D[2018-11-02]

      iex()> Datex.Date.add("15 Oct, 2018", 10, :nice_short_date)
      "25 Oct, 2018"

  """

  def add(date, days, format \\ :nice_date) do
    date
    |> check_date
    |> Date.add(days)
    |> show_date(format)
  end

  @doc """
  Get difference between two dates as `Integer`. 

  It takes 2 different dates as arguments. You can specify 2 dates in different format as well. 
  Other than `elixir_date` format remaining formats should be `string`.   

  ## Examples

      iex(1)> Datex.Date.difference("25 oct 2018", "10/10/2018")
      15

      iex(2)> Datex.Date.difference(~D[2018-11-25], "10-10-2018")
      46
      
  """

  def difference(date1, date2) do
    dat1 = check_date(date1)
    dat2 = check_date(date2)
    Date.diff(dat1, dat2)
  end

  @doc """
  Get the range between two dates as `DateRange`. 

  It takes 2 different dates as arguments. You can specify 2 dates in different format as well. 
  Other than `elixir_date` format remaining formats should be `string`.   

  ## Examples

      iex(1)> Datex.Date.range("12-12-2018", "12 Dec 2019")
      #DateRange<~D[2018-12-12], ~D[2019-12-12]>

      iex(2)> Datex.Date.range(~D[2018-10-17], "12 Dec 2019")
      #DateRange<~D[2018-10-17], ~D[2019-12-12]>
      
  """

  def range(date1, date2) do
    dat1 = check_date(date1)
    dat2 = check_date(date2)
    Date.range(dat1, dat2)
  end

  @doc """
  It checks whether a particular `date` falls inside a `DateRange`. 

  It takes 2 arguments. First is a `DateRange` and second is `date`.  
  It returns boolean either `true` or `false`. You can iterate over `DateRange` for other date functionalities. 

  ## Examples

      iex()> range = Datex.Date.range(~D[2018-10-17], "12 Dec 2019")
      #DateRange<~D[2018-10-17], ~D[2019-12-12]>
      iex()> Datex.Date.date_in_range(range, "12/03/2019")
      true

      iex()> Datex.Date.date_in_range(range, "12/03/2021")
      false

      iex()> for date <- range, do: date
      [~D[2018-10-17], ~D[2018-10-18], ~D[2018-10-19], ~D[2018-10-20], ~D[2018-10-21],
       ~D[2018-10-22], ~D[2018-10-23], ~D[2018-10-24], ~D[2018-10-25], ~D[2018-10-26],
       ~D[2018-10-27], ~D[2018-10-28], ~D[2018-10-29], ~D[2018-10-30], ~D[2018-10-31],
       ...]
      
  """

  def date_in_range(range, date) do
    date = check_date(date)
    Enum.member?(range, date)
  end

  @doc """
  It produces an array of dates in formats you want. 

  It takes 2 arguments. First is a `DateRange` and second is `format` which is optional and gives elixir date by default.
  Formats are specified in `format_date()`  
  It returns an array of dates in the given format.

  ## Examples
      
      range = Datex.Date.range("10 sept, 2018", "20 sept, 2018")
      iex()> Datex.Date.date_list(range, "DD-MM-YYYY")
      ["10-09-2018", "11-09-2018", "12-09-2018", "13-09-2018", "14-09-2018",
      "15-09-2018", "16-09-2018", "17-09-2018", "18-09-2018", "19-09-2018",
      "20-09-2018"]

      iex()> Datex.Date.date_list(range, "DAY_SHORT, DATE MONTH_NAME_SHORT")      
      ["Mon, 10 Sept", "Tue, 11 Sept", "Wed, 12 Sept", "Thu, 13 Sept",
      "Fri, 14 Sept", "Sat, 15 Sept", "Sun, 16 Sept", "Mon, 17 Sept",
      "Tue, 18 Sept", "Wed, 19 Sept", "Thu, 20 Sept"]

      iex()> Datex.Date.date_list(range)
      [~D[2018-09-10], ~D[2018-09-11], ~D[2018-09-12], ~D[2018-09-13],
      ~D[2018-09-14], ~D[2018-09-15]]
      
  """  

  def date_list(range, format \\ "elixir") do
    for date <- range do
      format_date(date, format)
    end
  end

  @doc """
  Change given `date` to a specific date format.

  It takes 2 arguments. First is a `Date` and second is `format` as `String` you want to convert to. 
  It returns `date` in required format.

  Valid formats are: 

  `DD-MM-YYYY`
  
  `YYYY-MM-DD`

  `DD-MM-YY`

  `DD/MM/YYYY`

  `YYYY/MM/DD`

  `DD/MM/YY`

  `DD.MM.YYYY`

  `YYYY.MM.DD`

  `DD.MM.YY`

  `DATE MONTH_NAME_FULL YYYY`

  `DATE MONTH_NAME_SHORT YYYY`

  `DATE MONTH_NAME_SHORT YY`

  `MONTH_NAME_FULL DATE YYYY`

  `MONTH_NAME_SHORT DATE YYYY`

  `DAY_FULL, DATE MONTH_NAME_FULL YYYY`

  `DAY_SHORT, DATE MONTH_NAME_SHORT YYYY`

  `DAY, DATE MONTH_NAME_FULL`

  `DAY_SHORT, DATE MONTH_NAME_SHORT`






  ## Examples

      iex()> Datex.Date.format_date("10 Feb, 2017", "YYYY/MM/DD")
      "2017/02/10"

      iex()> Datex.Date.format_date("10 feb, 2017", "MONTH_NAME_FULL DATE YYYY")
      "February 10, 2017"

      iex()> Datex.Date.format_date("10 feb, 2017", "DAY_FULL, DATE MONTH_NAME_FULL YYYY")
      "Friday, 10 February 2017"

      iex()> Datex.Date.format_date(~D[2019-02-10], "DAY_SHORT, DATE MONTH_NAME_SHORT")
      "Sun, 10 Feb"
      
  """

  def format_date(date, format) do

    elixir_date = check_date(date)
    day = day(date)
    day_short = day_short(date)
    {dat, month, year} = {elixir_date.day, elixir_date.month, elixir_date.year}
    [_, _ | last_two] = Integer.digits(year)
    
    case format do

      "DD-MM-YYYY" -> 
        "#{dat}-#{format_month(month)}-#{year}"

      "YYYY-MM-DD" -> 
        "#{year}-#{format_month(month)}-#{dat}"

      "DD-MM-YY" -> 
        "#{dat}-#{format_month(month)}-#{Integer.undigits(last_two)}"

      "DD/MM/YYYY" -> 
        "#{dat}/#{format_month(month)}/#{year}"

      "YYYY/MM/DD" -> 
        "#{year}/#{format_month(month)}/#{dat}"

      "DD/MM/YY" -> 
        "#{dat}/#{format_month(month)}/#{Integer.undigits(last_two)}"

      "DD.MM.YYYY" -> 
        "#{dat}.#{format_month(month)}.#{year}"

      "YYYY.MM.DD" -> 
        "#{year}.#{format_month(month)}.#{dat}"

      "DD.MM.YY" -> 
        "#{dat}.#{format_month(month)}.#{Integer.undigits(last_two)}"

      "DATE MONTH_NAME_FULL YYYY" ->
        "#{dat} #{@months[month]}, #{year}"

      "DATE MONTH_NAME_SHORT YYYY" ->
        "#{dat} #{@months_short_name[month]}, #{year}"

      "DATE MONTH_NAME_SHORT YY" ->
        "#{dat} #{@months_short_name[month]}, #{Integer.undigits(last_two)}"

      "MONTH_NAME_FULL DATE YYYY" ->
        "#{@months[month]} #{dat}, #{year}"

      "MONTH_NAME_SHORT DATE YYYY" ->
        "#{@months_short_name[month]} #{dat}, #{year}"

      "DAY_FULL, DATE MONTH_NAME_FULL YYYY" ->
        "#{day}, #{dat} #{@months[month]} #{year}"

      "DAY_SHORT, DATE MONTH_NAME_SHORT YYYY" ->
        "#{day_short}, #{dat} #{@months_short_name[month]} #{Integer.undigits(last_two)}"

      "DAY, DATE MONTH_NAME_FULL" ->
        "#{day}, #{dat} #{@months[month]}"

      "DAY_SHORT, DATE MONTH_NAME_SHORT" ->
        "#{day_short}, #{dat} #{@months_short_name[month]}"

      "elixir" -> elixir_date

      _ -> "Unspecified Format"

    end
  end

  @doc """
  It compares 2 `dates` and provides us human friendly results like `2 days later` or `6 months ago`. 

  It takes 2 arguments. First is a `date` and second is also a `date` defaulted to `today`. 
  It returns friendly result as `string` 
  
  `compare/1` will compare the given `date` from today itself. You can even pass second argument as `date` to compare with. 

  ## Examples

      iex()> Datex.Date.compare("15 aug 2018")
      "a month and 1 day ago"

      iex()> Datex.Date.compare("15 aug 2018", "20/05/2017")
      "a year and 2 months later"

      iex()> Datex.Date.compare("15-08-2018", "20/05/2010")
      "8 years later"

      iex(10)> Datex.Date.compare("15 aug 2018", ~D[2018-08-06])
      "a week and 2 days later"
      
  """

  def compare(date1, date2 \\ today()) do
    diff = difference(date1, date2)
    cond do
      diff >= 0 -> 
        cond do
          diff == 0 -> "Same Day"
          diff == 1 -> "1 Day later"
          diff < 7 -> "#{diff} days later"
          diff == 7 -> "1 week later"
          diff > 7 && diff < 30 ->
            week = div(diff, 7)
            days = rem(diff,  7)
            cond do
              days == 1 && week == 1 ->  
                "a week and #{days} day later"
              days > 0 and week == 1 ->
                "a week and #{days} days later"
              week >= 2 ->
                "#{week} weeks later"
            end
          diff > 30 && diff < 60 ->
            days = rem(diff, 30)
            cond do
              days == 0 -> "a month later"
              days == 1 -> "a month and 1 day later"
              days > 1 -> "a month and #{days} days later"
            end
          diff >=60 && diff < 365 ->
            months = div(diff, 30)
            "#{months} months later"
          diff > 365 && diff < 730 -> 
            months = rem(diff, 365) |> div(30)
            cond do
              months == 0 -> "a year later"
              months == 1 -> "a year and a month later"
              months > 1 -> "a year and #{months} months later"
            end
          diff >= 730 -> 
            year = div(diff, 365)
            "#{year} years later"
        end
      diff < 0 ->
        diff = abs(diff)
        cond do
          diff == 1 -> "1 Day ago"
          diff < 7 -> "#{diff} days ago"
          diff == 7 -> "1 week ago"
          diff > 7 && diff < 30 ->
            week = div(diff, 7)
            days = rem(diff,  7)
            cond do
              days == 1 && week == 1 ->  
                "a week and #{days} day ago"
              days > 0 and week == 1 ->
                "a week and #{days} days ago"
              week >= 2 ->
                "#{week} weeks ago"
            end
          diff > 30 && diff < 60 ->
            days = rem(diff, 30)
            cond do
              days == 0 -> "a month ago"
              days == 1 -> "a month and 1 day ago"
              days > 1 -> "a month and #{days} days ago"
            end
          diff >=60 && diff < 365 ->
            months = div(diff, 30)
            "#{months} months ago"
          diff > 365 && diff < 730 -> 
            months = rem(diff, 365) |> div(30)
            cond do
              months == 0 -> "a year later"
              months == 1 -> "a year and a month ago"
              months > 1 -> "a year and #{months} months ago"
            end
          diff >= 730 -> 
            year = div(diff, 365)
            "#{year} years ago"
        end
    end
  end

  defp check_date(date) do
    cond do
      String.valid?(date) ->
        convert_to_elixir_date(date)
      String.valid?(date) == false && date.year >= 0 ->
        date
      true ->
        "Invalid Date format"
    end
  end


  defp convert_to_elixir_date(date) do

    cond do
      String.match?(date, ~r/-/) ->
        parse_slaced_date(date)

      String.match?(date, ~r/\//) ->
        parse_forward_slaced_date(date)

      String.match?(date, ~r/\./) ->
        parse_dotted_date(date)

      true ->
        parse_string_date(date)
    end
  end

  defp parse_slaced_date(date) do
    date = String.trim(date) |> String.split("-") |> Enum.map(&String.to_integer/1)
    parse_date(date)
  end

  defp parse_forward_slaced_date(date) do
    date = String.trim(date) |> String.split("/") |> Enum.map(&String.to_integer/1)
    parse_date(date)
  end

  defp parse_dotted_date(date) do
    date = String.trim(date) |> String.split(".") |> Enum.map(&String.to_integer/1)
    parse_date(date)
  end

  defp parse_string_date(date) do

    case String.trim(date) |> String.split([" ", ", ", ","]) do
      [one, two, three] ->

        cond do
          parse_day(one) in 1..31 && month_number(two) && String.length(three) === 4 && parse_day(three) ->
            new_date(parse_day(three), month_number(two), parse_day(one))

          parse_day(two) in 1..31 && month_number(one) && String.length(three) === 4 && parse_day(three) ->
            new_date(parse_day(three), month_number(one), parse_day(two))

          parse_day(two) in 1..31 && month_number(three) && String.length(one) === 4 && parse_day(one) ->
            new_date(parse_day(one), month_number(three), parse_day(two))

          parse_day(three) in 1..31 && month_number(two) && String.length(one) === 4 && parse_day(one) ->
            new_date(parse_day(one), month_number(two), parse_day(three))

          true -> 
            "Invalid Date Format"
        end
      _ -> "Invalid Date Format"
    end
  end

  defp parse_date(date) do

    case date do
      [day, month, year] when year > 0 and day in 1..31 and month in 1..12 ->
        new_date(year, month, day)

      [year, month, day] when year > 0 and day in 1..31 and month in 1..12 ->
        new_date(year, month, day)

      [month, day, year] when year > 0 and day in 1..31 and month in 1..12 ->
        new_date(year, month, day)
        
      _ ->
        "Invalid Date Format"
    end
  end

  defp new_date(year, month, day) do
    case Date.new(year, month, day) do
      {:ok, date} -> date
      {:error, _} -> "Invalid date"
    end
  end

  defp parse_day(day) do
    case Integer.parse(day) do
      {day, _} -> day
      :error -> nil
    end
  end

  defp format_month(number) when number in 1..12 do
    cond do
      number < 10 ->
        "0#{number}"
      true -> 
        number
    end
  end

  defp seconds_from_offset(timezone_name) do
    Timezones.get_seconds_from_timezone(timezone_name)
  end

  defp naive_to_date(time_zone) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(seconds_from_offset(time_zone))
    |> NaiveDateTime.to_date()
  end

  defp month_name(number) do
    @months[number]
  end

  defp month_number(name) do
    @months_number[name]
  end

  defp month_short_name(number) do
    @months_short_name[number]
  end

  defp show_date(date, format \\ :nice_date) do
    case format do
      :elixir -> date
      :nice_date -> date |> nice_date
      :nice_short_date -> date |> nice_short_date
      _ -> "Invalid format"
    end
  end

  defp nice_date(date) do
    {day, month, year} = {date.day, date.month, date.year}
    "#{day} #{month_name(month)}, #{year}"
  end

  defp nice_short_date(date) do
    {day, month, year} = {date.day, date.month, date.year}
    "#{day} #{month_short_name(month)}, #{year}"
  end

end