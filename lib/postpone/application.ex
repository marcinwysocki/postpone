defmodule Postpone.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = if Mix.env() === :test, do: [Postpone.Mock.Server], else: []

    opts = [strategy: :one_for_one, name: Postpone.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
