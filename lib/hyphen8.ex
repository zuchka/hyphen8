defmodule Hyphen8 do
@moduledoc false

@timeout 1000000
  
def start(list) do
  list
  |> Enum.map(fn i -> async_call_square_root(i) end)
  |> Enum.map(fn task -> await_and_inspect(task) end)
  |> Enum.join(" ")
end

def async_call_square_root(i) do
  Task.async(fn ->
    :poolboy.transaction(
      :worker,
      fn pid -> GenServer.call(pid, {:square_root, i}, 600000) end,
      @timeout
    )
  end)
end

def await_and_inspect(task) do 

  task
  |> Task.await(@timeout) 

end
end
