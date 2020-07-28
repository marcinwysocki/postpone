defmodule Postpone.Mock.Server do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> :idle end, name: __MODULE__)
  end

  @spec set(non_neg_integer(), function()) :: :ok
  def set(time, fun) do
    Agent.update(__MODULE__, fn _ -> {time, fun} end)
  end

  @spec advance_timers_by(number) :: :ok
  def advance_timers_by(time) do
    {rem_time, fun} = get_state()
    time_after_advance = rem_time - time

    if time_after_advance <= 0 do
      fun.()

      :ok
    else
      set(time_after_advance, fun)
    end
  end

  @spec run_all_timers :: :ok
  def run_all_timers do
    {_, fun} = get_state()

    fun.()

    :ok
  end

  defp get_state do
    Agent.get(__MODULE__, & &1)
  end
end
