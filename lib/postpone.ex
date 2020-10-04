defmodule Postpone do
  @moduledoc """
  A set of helpers for testing `timer`-based code, inspired by [`Jest`](https://jestjs.io/docs/en/timer-mocks).

  ## Why?

  Sometimes things need to be postponed. Whether it's calling a function or sending a message, Erlang's `timer` module has a function for that.
  However, this creates a haeadache when it comes to testing. Time-based test are often fragile, tricky to write and [mocking `timer` with popular
  tools is even trickier](https://github.com/eproxus/meck#caveats).

  `Postpone` offers a solution for this problem. It allows a user to postpone certain actions, using trusted `timer` under the hood,
  but at the same time offers a way to mock and control timers inside test cases.

  ## Usage

  Use `Postpone` in your code:

      defmodule Foo do
        def send_me_a_greeting do
          Postpone.send_after(:hello, self(), 1000)
        end
      end

  Then test it:

      defmodule FooTest do
        use ExUnit.Case
        use Postpone.Mock

        test "greeting" do
          with_timers_mock do
            Foo.send_me_a_greeting()

            run_all_timers()

            assert_received :hello
          end
        end
      end
  """

  @doc """
  Sends a `msg` to `pid` after `time`.
  """
  @spec send_after(term(), pid(), non_neg_integer()) :: {:ok, reference()} | {:error, term()}
  def send_after(msg, pid, time) do
    :timer.send_after(time, pid, msg)
  end

  @doc """
  Applies `fun` or `fun` in `mod` with `args` after `time`.
  """
  @spec apply_after(fun() | mfa(), non_neg_integer()) :: {:ok, reference()} | {:error, term()}
  def apply_after(fun, time) when is_function(fun) do
    apply_after({:erlang, :apply, [fun, []]}, time)
  end

  def apply_after({mod, fun, args}, time) do
    :timer.apply_after(time, mod, fun, args)
  end
end
