defmodule Aliyun.CIAM.Application do
  @moduledoc false

  use Application
  @app :aliyun_ciam
  @finch_name Aliyun.CIAM.Finch

  @impl true
  def start(_type, _args) do
    :ets.new(@app, [:named_table, :set, :public, read_concurrency: true])
    settings = Application.get_env(@app, Aliyun.CIAM.Refresher, [])

    children = [
      {Finch, name: @finch_name, pools: %{:default => [size: 32, count: 8]}},
      {Aliyun.CIAM.Refresher, settings}
    ]

    opts = [strategy: :one_for_one, name: Aliyun.CIAM.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
