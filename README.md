# Aliyun.CIAM

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `aliyun_ciam` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:aliyun_ciam, "~> 0.1.0"}
  ]
end
```

Add app config for `config/config.exs`:

```elixir
config :aliyun_ciam, Aliyun.CIAM.Refresher,
  app_name: %{
    appid: "idaas_ciam_appid",
    login_endpoint: "https://xxxxx.login.aliyunidaas.com",
    endpoint: "https://xxxxx.api.aliyunidaas.com",
    client_id: "client_id",
    client_secret: "client_secret"
  }
```

Fetch the config and login by api:

```elixir
config = Aliyun.CIAM.get_config("app_name")
{:ok, %{body: %{"success" => true, "data" => data}}} = Aliyun.CIAM.Login.login_by_pwd(config, "username", "password")
```

user_config transform:

```elixir
user_config = Aliyun.CIAM.User.init_user_config(config, data)
```

Fetch the user_info by api:

```elixir
Aliyun.CIAM.User.user_info(user_config)
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/aliyun_ciam>.

