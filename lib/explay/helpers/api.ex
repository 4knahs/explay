defmodule ExPlay.Helpers.API do
  use ExPlay.Request.Base

  @moduledoc """
  Google Play API call handler methods
  """

  def category_names(account) do
    ret = ExPlay.Request.categories(account)

    case ret do
              {:ok,       data} -> {:ok,
                Enum.map(data, fn n ->
                           [category | _c] = tl(Regex.run(~r/cat=([\w]+)&c=([\d]+)/, n["dataUrl"]))
                           category
                end)
              }
              {:error, message} -> {:error, message}
    end
  end

  def subcategory_names(account) do
    ret = category_names(account)

    case ret do
        {:ok, data} -> {:ok,
            Enum.flat_map(data, fn n ->
                cat = ExPlay.Request.category(account, n)

                case cat do
                    {:ok, []} -> []
                    {:ok, cat} ->
                        Enum.map(cat, fn x ->
                            x["name"]
                            #[category | _c] = tl(Regex.run(~r/cat=([\w]+)&c=([\d]+)/, x["dataUrl"]))
                            end)
                    {:error, message} -> :error
                end
            end)
        }
        {:error, message} -> {:error, message}
    end

  end
end