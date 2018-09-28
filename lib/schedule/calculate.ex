defmodule Schedule.Calculate do
  alias Schedule.MonthServer
  alias Schedule.PeopleServer
  use Timex
  import IEx

  @moduledoc"""
  - first, setting up the month, done
  - setting up all the doctors(a string or a list, pipe into the map with id), done
  - setting the points for everyone, done
  - start calculating from the day1
    - holidays first for all people, done
    - if all holidays shared by all people then it is done;
      if there is an extra one//pick from r1/r2
    - calculate all the rest day
  - if hit an error, restart again; if restart 100 times, show it was wrong
  - if it all success, show success, and the result
  """

  #month setup
  def set_this_month(date, holidays \\ []) do
    GenServer.call(MonthServer, {:set_start, date, holidays})
  end

  def reset_month(default) do
    GenServer.cast(MonthServer, {:reset, default})
  end

  def get_current_month() do
    GenServer.call(MonthServer, {:get})
  end

  def update_month(date, new_data) do
    GenServer.cast(MonthServer, {:update, date, new_data})
  end

  def get_specific_date(date) do
    GenServer.call(MonthServer, {:get_day, date})
  end

  #people setup
  def get_current_people() do
    GenServer.call(PeopleServer, {:get})
  end

  def reset_people(default) do
    GenServer.cast(PeopleServer, {:reset, default})
  end

  def add_new_person(person_data) do
    {name, id, level, points, max_holidays} = person_data
    GenServer.cast(PeopleServer, {:add, name, id, level, points, max_holidays})
  end

  def set_reserve(id, weekdays \\ [], reserve_days \\ []) do
    GenServer.cast(PeopleServer, {:set_reserve, id, weekdays, reserve_days })
  end

  def update_person(id, new_data) do
    GenServer.cast(PeopleServer, {:update, id, new_data})
  end


  # calculte
  def get_result(0, _people, _month) do
    {:error, "there is no result"}
  end
  def get_result(n, default_people, default_month) do
    if ( get_current_month |> filter_no_person_day ) > 0 do
      reset_people(default_people)
      reset_month(default_month)
      set_the_holiday(n)
      set_the_ordinary(n)
      get_result(n - 1, default_people, default_month)
      IO.puts "#{n - 1} left"
    else
      {:ok, get_current_month}
    end
  end

  def set_the_holiday(n) do
    holidays = get_current_month
    |> filter_holidays
    Enum.each(holidays, fn(date) ->
      seize_holiday(n, date)
    end)
  end

  def set_the_ordinary(n) do
    get_current_month
    |> Stream.filter(fn {date, value} -> !value.is_holiday  end)
    |> Enum.each(fn(date) -> seize_the_day(n, date) end)
  end


  """
  random pick a person
  check the  reserve_day
  check the weekday_reserve
  check if it is qod?
  if ok ->
  - set the person's duty_day, and add up the current_point
  - set the day with this person
  not ok -> try to repeat 100 times, if still no ok, return with {:error}
  """
    defp seize_holiday(0, _date) do
      {:error, "it does not work"}
    end

    defp seize_holiday(n, date) do
      {pick_id, person_info} = get_current_people
      |> Enum.random()
      if can_be_reserved?(person_info, elem(date, 0)) do
        new_point = person_info.current_point + 2
        add_holiday = person_info.holidays_count + 1
        duty_days = [ elem(date,0) | person_info.duty_days]
        new_days = %{ elem(date, 1) | person: pick_id }
        update_person(pick_id, %{person_info | current_point: new_point, duty_days: duty_days, holidays_count: add_holiday })
        update_month(elem(date, 0), new_days)
      else
        seize_holiday(n - 1 , date)
      end
    end

    def seize_the_day(0, _date) do
      {:error, "it does not work"}
    end

    def seize_the_day(n, date) do
      {pick_id, person_info} = get_current_people
      |> Enum.random()
      if can_be_reserved_ordinary?(person_info, elem(date, 0)) do
        new_point = person_info.current_point + 1
        duty_days = [ elem(date,0) | person_info.duty_days]
        new_days = %{ elem(date, 1) | person: pick_id }
        update_person(pick_id, %{person_info | current_point: new_point, duty_days: duty_days})
        update_month(elem(date, 0), new_days)
      else
        IO.puts "#{n - 1} left"
        IO.puts "#{pick_id} does not fit #{elem(date, 0)}"
        seize_the_day(n - 1 , date)
      end
    end


    defp can_be_reserved?(person, date) do
      if Enum.member?(person.reserve_days, date)
      || Enum.member?(person.weekday_reserve, Timex.weekday(date))
      || less_than_two?(person.duty_days, date)
      || exceed_maximun?(person, date)
      || break_holiday_policy?(person)
        do
        false
      else
        true
      end
    end

    defp can_be_reserved_ordinary?(person, date) do
      if Enum.member?(person.reserve_days, date)
      || Enum.member?(person.weekday_reserve, Timex.weekday(date))
      || less_than_two?(person.duty_days, date)
      || exceed_maximun?(person, date)
        do
        false
        else
          true
      end
    end

    defp less_than_two?(days_list, date) do
      Enum.reduce(days_list, false, fn duty_day, acc ->
        days_interval = Interval.new(from: date, until: duty_day)
        |> Interval.duration(:days)
        |> abs
        ( days_interval <= 2 ) || acc
      end)
    end

    defp exceed_maximun?(person, date) do
      person.current_point + get_specific_date(date).point   > person.max_points
    end

    #holiday special function
    defp break_holiday_policy?(person) do
      person.max_holidays == person.holidays_count
    end


    # return keyword list
    defp filter_holidays(month) do
      Enum.filter(month, fn {date, value} -> value.is_holiday  end)
    end

    defp filter_no_person_day(month) do
      Stream.filter(month, fn {date, value} -> value.person == :D0000 end)
      |> Enum.count
    end

end
