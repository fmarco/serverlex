defmodule Serverlex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Serverlex.Worker.start_link(arg)
      # {Serverlex.Worker, arg}
      Serverlex.Repo,
      {Task.Supervisor, name: Serverlex.TaskSupervisor},
      {Plug.Cowboy, scheme: :http, plug: Serverlex.Plug, options: [port: 4040]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Serverlex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
