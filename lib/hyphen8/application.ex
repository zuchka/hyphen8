defmodule Hyphen8.Application do
  @moduledoc false

  use Application

  defp poolboy_config do
    [
      name: {:local, :worker},
      worker_module: Hyphen8.Worker,
      size: 10,
      max_overflow: 2
    ]
  end

  def start(_type, _args) do
    children = [
      :poolboy.child_spec(:worker, poolboy_config())
    ]

    opts = [strategy: :one_for_one, name: Hyphen8.Supervisor]
    Supervisor.start_link(children, opts)
  end
end