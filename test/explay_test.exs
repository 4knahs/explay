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

    account = authenticate()

    assert true = ExPlay.Account.authenticated?(account)
  end

  test "App details" do

    account = authenticate()

    assert {:ok, app} = ExPlay.Request.package_details(account, "com.facebook.katana")

    assert app.title == "Facebook"

  end

  test "Categories" do
    account = authenticate()

    assert {:ok, categories} = ExPlay.Request.categories(account)

    Enum.each categories, fn n ->
       [category | _subcat_id] = tl(Regex.run(~r/cat=([\w]+)&c=([\d]+)/, n["dataUrl"]))
       IO.puts "#{category} -> #{n["name"]}"
    end

    assert {:ok, category} = ExPlay.Request.category(account, "GAME")
    assert "Action" == hd(category)["name"]

    Enum.each category, fn n ->
        IO.puts n["name"]
    end



  end


end
