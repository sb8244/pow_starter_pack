defmodule UserService.Redix do
  @pool_size 15

  def child_spec(_args) do
    redis_url = Application.get_env(:user_service, :redis_uri)

    children =
      for i <- 0..(@pool_size - 1) do
        Supervisor.child_spec({Redix, {redis_url, name: :"redix_#{i}"}}, id: {Redix, i})
      end

    %{
      id: RedixSupervisor,
      type: :supervisor,
      start: {Supervisor, :start_link, [children, [strategy: :one_for_one]]}
    }
  end

  def instance_name() do
    :"redix_#{random_index()}"
  end

  defp random_index() do
    rem(System.unique_integer([:positive]), @pool_size)
  end
end
