defmodule ExPlayTest do
  use ExUnit.Case
  doctest ExPlay

  require Logger

  def authenticate() do
    account = %ExPlay.Account{email: Application.get_env(:explay, :email),
            password: Application.get_env(:explay, :pass),
            device_id: Application.get_env(:explay, :token)}

    ExPlay.Account.authenticate!(account)
  end

  test "Authentication" do
    # Save this account object to later use in API requests

    account = authenticate()

    assert true = ExPlay.Account.authenticated?(account)
  end

  test "App details" do
    # Save this account object to later use in API requests

    account = authenticate()

    assert {:ok, app} = ExPlay.Request.package_details(account, "com.facebook.katana")

    assert app.title == "Facebook"

  end


end
