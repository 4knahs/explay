defmodule ExPlay.Request do
  @moduledoc """
  Wrapper methods around Google Play API Calls
  """

  defdelegate authenticate(account),                                      to: ExPlay.Request.Auth
  defdelegate authenticate!(account),                                     to: ExPlay.Request.Auth

  defdelegate download!(account, package, path),                          to: ExPlay.Asset
  defdelegate package_download_info(account, package, version \\ nil),    to: ExPlay.Request.API
end
