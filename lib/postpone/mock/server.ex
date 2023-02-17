defmodule Postpone.Mock.Server do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @spec set(reference(), non_neg_integer(), function()) :: :ok
  def set(ref, time, fun) do
    Agent.update(__MODULE__, fn state -> Map.put(state, ref, {time, fun}) end)
  end

  @spec drop(reference()) :: :ok
  def drop(ref) do
    Agent.update(__MODULE__, fn state -> Map.drop(state, [ref]) end)
  end

  def reset do
    Agent.update(__MODULE__, fn _ -> %{} end)
  end

  @spec advance_timers_by(number) :: :ok
  def advance_timers_by(time) do
    timers = get_state()

    for {ref, {rem_time, fun}} <- timers do
      time_after_advance = rem_time - time

      if time_after_advance <= 0 do
        fun.()
        drop(ref)
      else
        set(ref, time_after_advance, fun)
      end
    end

    :ok
  end

  @spec run_all_timers :: :ok
  def run_all_timers do
    timers = get_state()

    timers
    |> Enum.sort(fn {_, {rem_time_1, _}}, {_, {rem_time_2, _}} ->
      rem_time_1 >= rem_time_2
    end)
    |> Enum.each(fn {_ref, {_time, fun}} -> fun.() end)

    reset()

    :ok
  end

  defp get_state do
    Agent.get(__MODULE__, & &1)
  end
end
