defmodule Postpone.Mock do
  use Agent

  alias Postpone.Mock.Server

  @doc false
  defmacro __using__(_) do
    quote do
      import Mock
      import Postpone.Mock
    end
  end

  defmacro with_timers_mock(do: block) do
    quote do
      with_mock Postpone,
        send: fn msg, to, time -> Server.set(time, fn -> send(to, msg) end) end,
        apply: fn fun, time -> Server.set(time, fun) end do
        unquote(block)
      end
    end
  end

  @spec advance_timers_by(number) :: :ok
  def advance_timers_by(time) do
    Server.advance_timers_by(time)
  end

  @spec run_all_timers :: :ok
  def run_all_timers do
    Server.run_all_timers()
  end
end
