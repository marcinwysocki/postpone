defmodule Postpone do
  @moduledoc """
  A set of helpers for testing `timer`-based code, inspired by [`Jest`](https://jestjs.io/docs/en/timer-mocks).

  ## Why?

  Sometimes things need to be postponed. Whether it's calling a function or sending a message, Erlang's `timer` module has a function for that.
  However, this creates a haeadache when it comes to testing. Time-based test are often fragile, tricky to write and [mocking `timer` with popular
  tools is even trickier](https://github.com/eproxus/meck#caveats).

  `Postpone` offers a solution for this problem. It allows a user to postpone certain actions, using trusted `timer` under the hood,
  but at the same time offers a way to mock and control timers inside test cases.
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
