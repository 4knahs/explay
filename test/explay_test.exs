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

    assert {:ok, app} = ExPlay.Request.package_details(account, "com.wb.goog.scribbleremix")

    assert app.title == "Scribblenauts Remix"

    #IO.inspect app

  end

  test "Categories" do
    account = authenticate()

    #All categories
    #assert {:ok, _categories} = ExPlay.Request.categories(account)

    #IO.inspect ExPlay.Request.browse(account)

    #IO.inspect categories

    #Filtered category names
    assert {:ok, cat_names} = ExPlay.Helpers.category_names(account)

    IO.inspect cat_names

    #assert hd(categories)["name"] != hd(cat_names)

    #IO.puts "Checking #{hd(cat_names)}..."

    #Category details and subcategories
    #assert {:ok, category} = ExPlay.Request.category(account, "GAME")

    #IO.inspect category

    #assert {:ok, category} = ExPlay.Request.category(account, "Game", "Strategy")

    #IO.inspect category

    assert {:ok, subcat} = ExPlay.Helpers.subcategory_names(account)

    IO.inspect subcat

    #Category details and subcategories
    #assert {:ok, category} = ExPlay.Request.category(account, "FAMILY_PRETEND")

    #IO.inspect category

  end

#  test "Download Apps" do
#    account = authenticate()
#
#    apps = ["com.fruitgames.bubbleshooter","com.fruitcandy.blast"]
#
#    Enum.each(apps, fn n ->
#        ExPlay.Request.download!(account, n, "#{Application.get_env(:explay, :downloads)}/#{n}.apk")
#    end)
#  end


end
