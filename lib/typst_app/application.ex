defmodule TypstApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TypstAppWeb.Telemetry,
      TypstApp.Repo,
      {DNSCluster, query: Application.get_env(:typst_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TypstApp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TypstApp.Finch},
      # Start a worker by calling: TypstApp.Worker.start_link(arg)
      # {TypstApp.Worker, arg},
      # Start to serve requests, typically the last entry
      TypstAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TypstApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TypstAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
