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
        send_after: fn msg, to, time ->
          set_timer_with_ref(time, fn -> send(to, msg) end)
        end,
        apply_after: fn fun, time ->
          set_timer_with_ref(time, fun)
        end do
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

  @spec set_timer_with_ref(non_neg_integer, fun) :: {:ok, reference}
  def set_timer_with_ref(time, fun) do
    ref = Kernel.make_ref()

    Server.set(ref, time, fun)

    {:ok, ref}
  end
end
