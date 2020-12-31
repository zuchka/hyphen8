defmodule Hyphen8.Worker do
    use GenServer
  
    def start_link(_) do
      GenServer.start_link(__MODULE__, nil)
    end
  
    def init(_) do
      {:ok, nil}
    end
  
    def handle_call({:square_root, x}, from, state) do
      IO.puts("process #{inspect(self())}: hyphenating \"#{inspect(from)}\"")
    #   Process.sleep(1000)
      {:reply, Hyphen8.Engine.main(x), state}
    end
  end