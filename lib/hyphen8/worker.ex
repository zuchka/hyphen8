defmodule Hyphen8.Worker do
    use GenServer
  
    def start_link(_) do
      GenServer.start_link(__MODULE__, nil)
    end
  
    def init(_) do
      {:ok, nil}
    end
  
    def handle_call({:hyphen8, chunk_of_words}, from, state) do
      IO.puts("process #{inspect(self())}: hyphenating \"#{inspect(from)}\"")
      {:reply, Hyphen8.Engine.main(chunk_of_words), state}
    end
  end