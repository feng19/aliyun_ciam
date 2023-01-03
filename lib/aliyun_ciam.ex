defmodule Aliyun.CIAM do
  @moduledoc """
  Aliyun CIAM SDK for elixir
  """
  import Jason.Helpers
  alias Aliyun.CIAM.Requester

  @doc """
  获取 Token(客户端授权模式)
  """
  def get_token(config) do
    Requester.post(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/oauth/token",
      json_map(
        client_id: config.client_id,
        client_secret: config.client_secret,
        grant_type: "client_credentials"
      )
    )
  end

  @doc """
  获取 Token(授权码模式)
  """
  def get_token_by_code(config, code, redirect_uri, scope \\ "USER_API") do
    Requester.post(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/oauth/token",
      json_map(
        client_id: config.client_id,
        client_secret: config.client_secret,
        grant_type: "authorization_code",
        scope: scope,
        code: code,
        redirect_uri: redirect_uri
      )
    )
  end

  @doc """
  令牌有效性检验
  """
  def check_token(config) do
    Requester.get(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/oauth/token/check",
      query: [access_token: config.access_token]
    )
  end

  @doc """
  获取登录配置信息
  """
  def login_config(config) do
    Requester.get(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/config/loginpage",
      query: [access_token: config.access_token]
    )
  end

  @doc """
  获取应用已发布的条款
  """
  def load_consents(config) do
    Requester.get(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/consents",
      query: [access_token: config.access_token]
    )
  end

  @doc """
  获取应用支持的认证源
  """
  def load_auths(config) do
    Requester.get(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/load_enterprise_auths",
      query: [access_token: config.access_token]
    )
  end

  @doc """
  获取社交认证源的信息
  """
  def get_adapter_info(config, enterprise_auth_id) do
    Requester.get(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/get_adapter_info",
      query: [enterpriseAuthId: enterprise_auth_id, access_token: config.access_token]
    )
  end

  @doc """
  获取图片验证码
  """
  def captcha(config) do
    Requester.get(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/captcha",
      query: [access_token: config.access_token]
    )
  end
end
