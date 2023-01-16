defmodule Aliyun.CIAM.Login do
  @moduledoc "登录接口"
  import Jason.Helpers
  alias Aliyun.CIAM.Requester

  @doc """
  SSO 登录
  """
  def sso_url(config) do
    "#{config.login_endpoint}/api/bff/v1.2/developer/ciam/sp/sso?idaasAppId=#{config.appid}"
  end

  @doc """
  账密登录
  """
  def login_by_pwd(config, username, password) do
    login_by_pwd(config, json_map(username: username, password: password))
  end

  @doc """
  账密登录
  """
  def login_by_pwd(config, body) do
    Requester.post(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/login/pwd",
      body,
      query: [access_token: config.access_token]
    )
  end

  @doc """
  验证码登录 - 发送验证码
  """
  def obtain_code_to_phone(config, phone_region \\ "86", phone_no) do
    obtain_code(config, json_map(type: "SMS", phoneRegion: phone_region, phoneNumber: phone_no))
  end

  @doc """
  验证码登录 - 发送验证码
  """
  def obtain_code_to_email(config, email) do
    obtain_code(config, json_map(type: "EMAIL", email: email))
  end

  @doc """
  验证码登录 - 发送验证码
  """
  def obtain_code(config, body) do
    Requester.post(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/login/obtain_code",
      body,
      query: [access_token: config.access_token]
    )
  end

  @doc """
  验证码登录 - 校验验证码 - by phone
  """
  def verify_code_by_phone(config, fid, phone_region \\ "86", phone_no, code) do
    verify_code(
      config,
      json_map(
        fId: fid,
        type: "SMS",
        phoneRegion: phone_region,
        phoneNumber: phone_no,
        code: code
      )
    )
  end

  @doc """
  验证码登录 - 校验验证码 - by email
  """
  def verify_code_by_email(config, fid, email, code) do
    verify_code(
      config,
      json_map(fId: fid, type: "EMAIL", phoneRegion: email, code: code)
    )
  end

  @doc """
  验证码登录 - 校验验证码
  """
  def verify_code(config, body) do
    Requester.post(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/login/verify_code",
      body,
      query: [access_token: config.access_token]
    )
  end

  @doc """
  社交登录
  """
  def login_by_social(config, body) do
    Requester.post(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/login/social",
      body,
      query: [access_token: config.access_token]
    )
  end

  @doc """
  二次认证 - 发送验证码
  """
  def obtain_code_2fa(config, body) do
    Requester.post(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/prepare_second_factor",
      body,
      query: [access_token: config.access_token]
    )
  end

  @doc """
  二次认证 - 验证验证码
  """
  def verify_code_2fa(config, fid, type, code) do
    verify_2fa(config, json_map(fId: fid, type: type, code: code))
  end

  @doc """
  二次认证 - 验证密码
  """
  def verify_pwd_2fa(config, fid, password) do
    verify_2fa(config, json_map(fId: fid, type: "PWD", password: password))
  end

  @doc """
  二次认证 - 验证
  """
  def verify_2fa(config, body) do
    Requester.post(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/verify_second_factor",
      body,
      query: [access_token: config.access_token]
    )
  end
end
