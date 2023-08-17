defmodule Aliyun.CIAM.Refresher do
  @moduledoc false
  use GenServer
  require Logger
  @table :aliyun_ciam

  def get_config(name) do
    case :ets.lookup(@table, name) do
      [{_, config}] -> config
      _ -> nil
    end
  end

  def get_appid(name) do
    with %{appid: appid} <- get_config(name) do
      appid
    end
  end

  def start_link(settings) when is_list(settings) do
    GenServer.start_link(__MODULE__, settings, name: __MODULE__)
  end

  @impl true
  def init(settings) do
    state =
      Map.new(settings, fn {name, config} ->
        {name, refresh_token(config, name)}
      end)

    {:ok, state}
  end

  @impl true
  def handle_info({:timeout, _timer, {:refresh_token, name}}, state) do
    config = Map.fetch!(state, name) |> Map.delete(:timer) |> refresh_token(name)
    state = Map.put(state, name, config)
    {:noreply, state}
  end

  defp now_unix, do: System.system_time(:second)

  defp start_refresh_token_timer(time, name) do
    Logger.info("Start Refresh Timer for #{name}, time: #{time}s.")
    :erlang.start_timer(time * 1000, self(), {:refresh_token, name})
  end

  def refresh_token(config, name) do
    case Aliyun.CIAM.get_token(config) do
      {:ok, %{status: 200, body: %{"code" => "Operation.Success", "data" => data}}} ->
        %{
          "access_token" => access_token,
          "token_type" => token_type,
          "expires_in" => expires_in,
          "scope" => scope
        } = data

        Logger.info(
          "got token successes, token_type: #{token_type}, scope: #{scope}, expires_in: #{expires_in}"
        )

        expires = now_unix() + expires_in
        timer = max(expires_in - 30, 0) |> start_refresh_token_timer(name)

        Map.merge(config, %{
          access_token: access_token,
          timer: timer,
          expires: expires,
          expires_in: expires_in,
          token_type: token_type,
          scope: scope
        })

      error ->
        Logger.warn("got token failed: #{inspect(error)}, will try again after one minute.")
        timer = start_refresh_token_timer(60, name)
        Map.merge(config, %{timer: timer})
    end
    |> tap(fn config ->
      cache_config =
        Map.take(config, [
          :appid,
          :login_endpoint,
          :endpoint,
          :client_id,
          :client_secret,
          :access_token
        ])

      :ets.insert(@table, {name, cache_config})
    end)
  end
end
