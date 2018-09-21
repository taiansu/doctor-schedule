defmodule Schedule.PeopleServer do
use GenServer
alias Schedule.Person
import IEx

def start_link() do
  GenServer.start_link(__MODULE__, nil, name: __MODULE__)
end

def init(_) do
  {:ok, %{}}
end

def handle_call({:get}, _from, people) do
  {:reply, people, people}
end

def handle_cast({:add, name, id, level, points}, people) do
  person = %Person{
    name: name,
    id: id,
    level: level,
    max_points: points
  }
  {:noreply, Map.put(people, id, person) }
end

def handle_cast({:set_reserve,id, weekdays, reserve_days}, people) do
  person = Map.get(people, id) 
  new_person = %{ person | reserve_days: reserve_days,
                  weekday_reserve: weekdays
                }
  {:noreply, Map.put(people, id, new_person) }
end

end
