defmodule Aliyun.CIAM.User do
  @moduledoc "用户接口"
  import Jason.Helpers
  alias Aliyun.CIAM.Requester

  @doc """
  初始化用户配置

  ## Example

      config = Aliyun.CIAM.get_config("app_name")
      {:ok, %{body: %{"success" => true, "data" => data}}} = Aliyun.CIAM.Login.login_by_pwd(config, "username", "password")
      user_config = #{inspect(__MODULE__)}.init_user_config(config, data)
  """
  def init_user_config(
        config,
        %{
          "userId" => user_id,
          "uuid" => uuid,
          "access_token" => access_token,
          "expires_in" => expires_in,
          "id_token" => id_token,
          "refresh_token" => refresh_token,
          "scope" => scope,
          "token_type" => token_type
        } = _data
      ) do
    expires = System.system_time(:second) + expires_in

    %{
      endpoint: config.endpoint,
      user_id: user_id,
      uuid: uuid,
      access_token: access_token,
      refresh_token: refresh_token,
      expires_in: expires_in,
      expires: expires,
      id_token: id_token,
      scope: scope,
      token_type: token_type
    }
  end

  def init_user_config(
        config,
        %{
          "access_token" => access_token,
          "expires_in" => expires_in,
          "id_token" => id_token,
          "refresh_token" => refresh_token,
          "scope" => scope,
          "token_type" => token_type
        } = _data
      ) do
    expires = System.system_time(:second) + expires_in

    %{
      endpoint: config.endpoint,
      user_id: nil,
      uuid: nil,
      access_token: access_token,
      refresh_token: refresh_token,
      expires_in: expires_in,
      expires: expires,
      id_token: id_token,
      scope: scope,
      token_type: token_type
    }
  end

  def oauth2_authorize_url(
        login_endpoint,
        client_id,
        redirect_uri,
        scope \\ "USER_API",
        state \\ ""
      ) do
    [
      [login_endpoint, "?", "client_id=", client_id],
      ["&redirect_uri=", URI.encode_www_form(redirect_uri)],
      "&response_type=code",
      ["&scope=", scope],
      if match?("", state) do
        []
      else
        ["&state=", state]
      end
    ]
    |> IO.iodata_to_binary()
  end

  @doc """
  令牌有效性检验
  """
  def check_token(config) do
    Requester.get(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/user/token/check",
      query: [access_token: config.access_token]
    )
  end

  # 账号安全

  @doc """
  操作检查
  """
  def operate_check(config, operate_type) do
    Requester.get(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/user/operate_check",
      query: [access_token: config.access_token, operateType: operate_type]
    )
  end

  # 个人信息

  @doc """
  获取个人信息

  ## Example

      #{inspect(__MODULE__)}.user_info(user_config)
  """
  def user_info(config) do
    Requester.get(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/user/info",
      query: [access_token: config.access_token]
    )
  end

  @doc """
   修改个人信息
  """
  def update_user_info(config, body) do
    Requester.put(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/user/info",
      body,
      query: [access_token: config.access_token]
    )
  end

  @doc """
  获取登录历史
  """
  def list_login_history(config) do
    Requester.get(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/user/login/history/list",
      query: [access_token: config.access_token]
    )
  end

  @doc """
  获取隐私条款授权历史
  """
  def get_agree_records(config) do
    Requester.get(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/user/get_agree_records",
      query: [access_token: config.access_token]
    )
  end

  @doc """
  撤回隐私条款授权
  """
  def recall_agree_records(config, uuid) do
    Requester.post(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/user/agree_records/recall",
      json_map(uuid: uuid),
      query: [access_token: config.access_token]
    )
  end

  @doc """
  组件内 SSO

  ## Example

      #{inspect(__MODULE__)}.component_sso(user_config, "appid", "redirect_uri", "state")
  """
  def component_sso(config, appid, redirect_uri, state, forward \\ "") do
    Requester.post(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/authorized/sso",
      json_map(
        idaasAppId: appid,
        responseType: "code",
        userType: "default",
        redirectUrl: redirect_uri,
        state: state,
        forward: forward
      ),
      query: [access_token: config.access_token]
    )
  end
end
