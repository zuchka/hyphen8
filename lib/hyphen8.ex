defmodule Hyphen8 do
  @moduledoc false
  @timeout 1000000

  def start(string) do
    list =
    String.split(string, ~r{\W}, trim: true)
    |> Stream.filter(fn x -> String.valid?(x)end)
    |> Stream.chunk_every(5)
    |> Enum.map(fn x -> Enum.join(x, " ")end)

    list
    |> Enum.map(fn chunk_of_words -> async_call_hyphen8(chunk_of_words) end)
    |> Enum.map(fn task -> await_and_inspect(task) end)
    |> Enum.join(" ")
  end

  def async_call_hyphen8(chunk_of_words) do
    Task.async(fn ->
      :poolboy.transaction(
        :hyphen8_worker,
        fn pid -> GenServer.call(pid, {:hyphen8, chunk_of_words}, 600000) end,
        @timeout
      )
    end)
  end

  def await_and_inspect(task), do: task |> Task.await(@timeout)
end
