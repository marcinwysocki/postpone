defmodule Postpone do
  @moduledoc """
  Documentation for `Postpone`.
  """
  def send(msg, to, time) do
    :timer.send_after(time, to, msg)
  end

  def apply(fun, time) do
    apply(:erlang, :apply, [fun, []], time)
  end

  def apply(mod, fun, args, time) do
    :timer.apply_after(time, mod, fun, args)
  end
end
