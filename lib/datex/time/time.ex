defmodule Datex.Time do
	@moduledoc """
  Simple Time which can be used in different formats including elixir format `~T[15:45:56]`. 

  It includes different functions to compare time and provide relative time in friendly formats and 
  functions which can format time in multiple ways user needs.
  """

  @doc """
  Get current time with or without timezone.

  It takes 1 optional argument i.e `time_zone name`.
  It returns `utc time` by default when no arguments is passed and time_zone specific time when time_zone is provided as `String`.  

  ## Examples

      iex()> Datex.Time.now()
      "04:21 AM"
      
      iex()> Datex.Time.now("Pacific/Fakaofo")
      "06:24 PM"

  """
  def now(zone_name \\ :utc) do
    utc_time = Time.utc_now()
    case zone_name do
      :utc -> format_hour(utc_time)
      _ -> 
        seconds = Datex.Timezones.get_seconds_from_timezone(zone_name)
        utc_time
        |> Time.add(seconds)
        |> format_hour
    end
  end

  @doc """
  It adds `time` to a given specific time. 

  It takes 4 arguments.
  Last 2 arguments are optional  i.e `unit` and `format`. 
  To use a specific `format`, you need to apply `unit` as well.
  
  Unit defaults to `:second` and format to `:hour_12`.

  Arguments are

  1. `time` as `elixir time` or standard time formats in `String` 

  2. `time to add` as `Integer` 

  3. `unit` as `atom` from `:hour`, `:minute`, `:second`, `:millisecond` 

  4.  `format` as `atom` from `:hour_12`, `:hour_24` and `:elixir`


  ## Examples
      
      iex()> Datex.Time.add(~T[16:56:56], 5)
      "04:57 PM"
      
      iex()> Datex.Time.add("4:56 PM", 5, :hour)
      "09:56 PM"

      iex()> Datex.Time.add("4:56:56", 5, :hour, :elixir)
      ~T[09:56:56.000000]

      iex()> Datex.Time.add("4:56:56", 5, :minute, :hour_12)
      "05:01 AM"

  """

  def add(time, added, unit \\ :second, format \\ :hour_12) do
    elixir_time = check_time(time)
    time = 
      case unit do
        :hour -> Time.add(elixir_time, added * 3600)
        :minute -> Time.add(elixir_time, added * 60)
        :second -> Time.add(elixir_time, added)
        :millisecond -> Time.add(elixir_time, added, :millisecond)
        _ -> "Invalid Unit"
      end
    format_hour(time, format)
  end

  @doc """
  It provides difference between 2 times in multiple `units`. It returns difference as `Integer`

  It takes 3 arguments.
  Last 2 arguments are optional  i.e `time2` and `format`. 
  To use a specific `format`, you need to apply `time2` as well or default it to current time in utc i.e Datex.Time.now() function.
  
  Unit defaults to `:second` and time2 to `current time in utc`.

  Argumets are

  1, 2. `time` as `elixir time` or standard time formats in `String` 

  3. `unit` as `atom` from `:hour`, `:minute`, `:second`, `:millisecond` 



  ## Examples

      iex()> Datex.Time.difference("10:30 am")
      3480
      
      iex()> Datex.Time.difference("11:10 am", Datex.Time.now())
      20040
      
      iex()> Datex.Time.difference("11:10 am", "10:10:10", :minute)
      59
      
  """

  def difference(time1, time2 \\ now(), unit \\ :second) do
    time1 = check_time(time1)
    time2 = check_time(time2)
    diff = Time.diff(time1, time2)
    case unit do
      :second -> diff
      :millisecond -> diff * 1000
      :micro -> diff * 1000000
      :minute -> div(diff, 60)
      :hour -> div(diff, 3600)
    end
  end

  @doc """
  It compares two times and provides human friendly results.

  It takes 2 arguments. Both are time as `elixir time` or standard time formats in `String`. 
  Second argument is optional as it provides `current time in utc` by default. 




  ## Examples

      
      
      iex()> Datex.Time.compare("10:30 am")
      "55 minutes later"
      
      iex()> Datex.Time.compare("10:30 am", "15:34:25")
      "5 hours and 4 minutes later"

      iex()> Datex.Time.compare(~T[23:16:45], "15:34:25")
      "7 hours and 42 minutes later"
      
  """

  def compare(time1, time2 \\ now()) do
    diff = difference(time1, time2)
    cond do
      diff >= 0 ->
        cond do
          diff < 60 -> "Just now"
          diff > 60 && diff < 120 -> "a minute later"
          diff >= 120 && diff < 3600 -> "#{div(diff, 60)} minutes later"
          diff >= 3600 && diff < 7200 -> 
            min = rem(diff, 3600) |> div(60)
            "an hour and #{min} minutes later"
          diff >= 7200 ->
            min = rem(diff, 3600) |> div(60) 
            "#{div(diff, 3600)} hours and #{min} minutes later" 
        end
      diff < 0 ->
        diff = abs(diff)
        cond do
          diff < 60 -> "Just now"
          diff > 60 && diff < 120 -> "a minute ago"
          diff >= 120 && diff < 3600 -> "#{div(diff, 60)} minutes ago"
          diff >= 3600 && diff < 7200 -> 
            min = rem(diff, 3600) |> div(60)
            "an hour and #{min} minutes ago"
          diff >= 7200 -> 
            min = rem(diff, 3600) |> div(60) 
            "#{div(diff, 3600)} hours and #{min} minutes later"  
        end
    end
  end

  @doc """
  It converts time in given format. 

  It takes 2 arguments. First is time as `elixir time` or standard time formats in `String`. 
  Second argument is format which could be `HH:MM`, `HH:MM:SS`, `HH:MM:SS:uS`, `12 HOUR FORMAT` or `elixir` as `String`.




  ## Examples

      
      
      iex()> Datex.Time.format_time(~T[23:16:45], "HH:MM:SS")
      "23:16:45"
      
      iex(6)> Datex.Time.format_time("9 pm", "HH:MM:SS")
      "21:00:00""

      iex(7)> Datex.Time.format_time("23:12:34", "12 HOUR FORMAT")
      "11:12 PM"

      iex(1)> Datex.Time.format_time("23:12:34", "elixir")
      ~T[23:12:34.000000]
      
  """

  def format_time(time, format) do
    elixir_time = check_time(time)
    {hrs, min, sec, micro} = {elixir_time.hour, elixir_time.minute, elixir_time.second, elixir_time.microsecond}

    case format do
      "HH:MM" -> "#{left_pad(hrs)}:#{left_pad(min)}"
      "HH:MM:SS" -> "#{left_pad(hrs)}:#{left_pad(min)}:#{left_pad(sec)}"
      "HH:MM:SS:uS" -> "#{left_pad(hrs)}:#{left_pad(min)}:#{left_pad(sec)}:#{micro}"
      "12 HOUR FORMAT" -> format_hour(elixir_time, :hour_12)
      "elixir" -> elixir_time
      _ -> "Invalid Time Format"
    end

  end

  defp convert_to_elixir_time(time) do
    cond do

      String.match?(time, ~r/AM/i) ->

        [hrs | rest] = get_time_array(time)
        hours = 
          cond do
            hrs == 12 -> 00
            true -> hrs
          end
        parse_time([hours | rest])

      String.match?(time, ~r/PM/i) ->
        [hrs | rest] = get_time_array(time)
        hours = 
          cond do
            hrs == 12 -> hrs
            true -> hrs + 12
          end
        parse_time([hours | rest])

      true ->
        list = String.trim(time) |> String.split([":", ": ", " : ", " "]) |> Enum.map(&String.to_integer/1)
        cond do
          Enum.count(list) > 1 -> parse_time(list)
          true -> "Invalid Time Format"
        end
        
    end
  end

  defp format_hour(time, format \\ :hour_12) do
    {hrs, min, sec} = {time.hour, time.minute, time.second}
    case format do
      :hour_12 -> 
        cond do
          hrs == 0 -> "12:#{left_pad(min)} AM"
          hrs == 12 -> "12:#{left_pad(min)} PM"
          hrs > 12 -> "#{left_pad(hrs - 12)}:#{left_pad(min)} PM"
          true -> "#{left_pad(hrs)}:#{left_pad(min)} AM"
        end
      :hour_24 ->
        "#{left_pad(hrs)}:#{left_pad(min)}:#{left_pad(sec)}"

      :elixir -> time

      _ -> "Invalid time format"
    end
  end

  defp check_time(time) do
    cond do
      String.valid?(time) == false && time.hour >= 0 ->
        time

      String.valid?(time) && String.match?(time, ~r/:/) || String.match?(time, ~r/ /) ->
        convert_to_elixir_time(time)
      
      true ->
        "Invalid Time format"
    end
  end

  defp parse_time(time) do
    case time do
      [hrs, min, sec, micro] when hrs in 0..23 and min in 0..60 and sec in 0..60 -> new_time(hrs, min, sec, micro)
      [hrs, min, sec] when hrs in 0..23 and min in 0..60 and sec in 0..60 -> new_time(hrs, min, sec)
      [hrs, min] when hrs in 0..23 and min in 0..60 -> new_time(hrs, min)
      [hrs] when hrs in 0..23 -> new_time(hrs)

    end
  end

  defp new_time(hrs, min \\ 0, sec \\ 0, micro \\ 0) do
    {:ok, time} = Time.new(hrs, min, sec, micro)
    time
  end

  defp get_time_array(time) do
    time_array = String.trim(time) |> String.split([":", ": ", " : ", " "])
    last = List.last(time_array)
    time_array -- [last] |> Enum.map(&String.to_integer/1)
  end

  defp left_pad(number) do
    cond do
      number < 10 -> "0#{number}"
      true -> number
    end
  end
	
end