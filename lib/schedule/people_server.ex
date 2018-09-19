defmodule Schedule.PeopleServer do
use GenServer
alias Schedule.Person

def start_link() do
  GenServer.start_link(__MODULE__, nil, name: __MODULE__)
end

def init(_) do
  {:ok, %{}}
end

def handle_cast({:add, name, id, level, points}, people) do
  person = %Person{name: name, id: id, level: level, max_points: points}
  {:noreply, Map.put(people, id, person) }
end

end
