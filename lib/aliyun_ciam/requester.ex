defmodule Aliyun.CIAM.Requester do
  @moduledoc """
  默认的请求客户端
  """
  use Tesla, only: [:get, :post, :put]

  adapter(Tesla.Adapter.Finch,
    name: Aliyun.CIAM.Finch,
    pool_timeout: 5_000,
    receive_timeout: 5_000
  )

  plug(Tesla.Middleware.JSON, decode_content_types: ["text/plain"])
end
