defmodule Aliyun.CIAM.Register do
  @moduledoc "注册接口"
  import Jason.Helpers
  alias Aliyun.CIAM.Requester

  @doc """
  发送验证码 - to phone NO
  """
  def obtain_code_to_phone(config, phone_region, phone_no) do
    obtain_code(config, json_map(type: "SMS", phoneRegion: phone_region, phoneNumber: phone_no))
  end

  @doc """
  发送验证码 - to email
  """
  def obtain_code_to_email(config, email) do
    obtain_code(config, json_map(type: "EMAIL", email: email))
  end

  @doc """
  发送验证码
  """
  def obtain_code(config, body) do
    Requester.post(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/register/obtain_code",
      body,
      query: [access_token: config.access_token]
    )
  end

  @doc """
  验证验证码 - by phone NO
  """
  def verify_code(config, fid, phone_region, phone_no, code) do
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
  验证验证码 - by email
  """
  def verify_code(config, fid, email, code) do
    verify_code(
      config,
      json_map(fId: fid, type: "EMAIL", phoneRegion: email, code: code)
    )
  end

  @doc """
  验证验证码
  """
  def verify_code(config, body) do
    Requester.post(
      "#{config.endpoint}/api/bff/v1.2/developer/ciam/register/submit",
      body,
      query: [access_token: config.access_token]
    )
  end
end
