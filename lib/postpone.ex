defmodule Postpone do
  @moduledoc """
  Documentation for `Postpone`.
  """
  def send(msg, to, time) do
    :timer.send_after(time, to, msg)
  end

  def apply(fun, time) do
    :timer.apply_after(time, :erlang, :apply, [fun, []])
  end
end
