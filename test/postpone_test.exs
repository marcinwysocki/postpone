defmodule PostponeTest do
  use ExUnit.Case
  use Postpone.Mock

  describe "send" do
    test "sends a message after given interval in ms" do
      Postpone.send_after(:message, self(), 100)

      refute_received :message

      :timer.sleep(110)

      assert_received :message
    end

    test "can be manually controlled via the Postpone.Mock module" do
      with_timers_mock do
        Postpone.send_after(:one, self(), 100)

        refute_received :one

        :timer.sleep(110)
        refute_received :one

        run_all_timers()
        assert_received :one

        Postpone.send_after(:two, self(), 100)

        refute_received :two

        :timer.sleep(110)
        refute_received :two

        advance_timers_by(50)
        refute_received :two

        advance_timers_by(50)
        assert_received :two
      end
    end
  end

  describe "apply" do
    test "applies a function after given interval in ms" do
      test_process = self()

      Postpone.apply_after(fn -> send(test_process, :message) end, 100)

      refute_received :message

      :timer.sleep(110)

      assert_received :message
    end

    def sample_function(pid, msg), do: send(pid, msg)

    test "applies a function, in a given module, with given args, after given interval in ms" do
      Postpone.apply_after({__MODULE__, :sample_function, [self(), :message]}, 100)

      refute_received :message

      :timer.sleep(110)

      assert_received :message
    end

    test "can be manually controlled via the Postpone.Mock module" do
      with_timers_mock do
        Postpone.apply_after(fn -> send(self(), :one) end, 100)

        refute_received :one

        :timer.sleep(110)
        refute_received :one

        run_all_timers()
        assert_received :one

        Postpone.apply_after(fn -> send(self(), :two) end, 100)

        refute_received :two

        :timer.sleep(110)
        refute_received :two

        advance_timers_by(50)
        refute_received :two

        advance_timers_by(50)
        assert_received :two
      end
    end
  end
end
