defmodule ExPlay.Request.API do
  use ExPlay.Request.Base

  @moduledoc """
  Google Play API call handler methods
  """


  @doc """
  Returns all details about a Google Play APK package,
  needs an authorized account object
  """
  def package_details(account, package) do
    ExPlay.Account.verify_authenticated!(account)

    details =
      get!("details", [{"doc", package}], api_headers(account, :get))
      |> ExPlay.Protobuf.decode
      |> ExUtils.Map.symbolize_keys
      |> handle_response

    case details do
      {:ok,    details} -> {:ok,    details.detailsResponse.docV2}
      {:error, message} -> {:error, message}
    end
  end

  def browse(account, query) do
    ExPlay.Account.verify_authenticated!(account)

    data = get!("browse", query, api_headers(account, :get))
    |> ExPlay.Protobuf.decode
          |> ExUtils.Map.symbolize_keys
          |> handle_response

    case data do
          {:ok,       data} -> {:ok, data.browseResponse.category}
          {:error, message} -> {:error, message}
    end
  end

  def category(account, cat_id, sub_cat_id) do
      browse(account, [{"c",3},{"cat",cat_id}, {"ctr",sub_cat_id}])
  end

  def category(account, cat_id) do
    browse(account, [{"c",3},{"cat",cat_id}])
  end

  def categories(account) do
    browse(account, [{"c",3}])
  end

  @doc """
  Attempts to retrieve APK download information
  """
  def package_download_info(account, {package, version}) do
    ExPlay.Account.verify_authenticated!(account)

    data =
      post!("purchase", download_params(package, version), api_headers(account, :post))
      |> ExPlay.Protobuf.decode
      |> ExUtils.Map.symbolize_keys
      |> handle_response

    case data do
      {:ok, data} ->
        resp = data.buyResponse
        cond do
          !!resp.purchaseStatusResponse -> {:ok, resp.purchaseStatusResponse.appDeliveryData}
          !!resp.checkoutinfo           -> {:error, "App not free"}
          true                          -> {:error, "Cannot parse download data"}
        end
      {:error, message} ->
        {:error, message}
    end
  end

  def package_download_info(account, package) when is_binary(package) do
    package_download_info(account, {package, nil})
  end



  @doc "Parses Google API request response to check if it was successful"
  def handle_response(response) do
    cond do
      !!response.payload ->
        {:ok, response.payload}

      !!response.commands ->
        {:error, response.commands.displayErrorMessage}

      true ->
        {:error, "Unknown Error"}
    end
  end

#"https://r1---sn-h5q7dne6.gvt1.com/market/GetBinary/GetBinary/b/1/AF3DWBexsd0viV96e5U9-SkM_V5zGSYWf280gemCMlB-x-L5HTIUXBm21X16jcmZOE3qwK23Y2nVTYqK9KWhYTt-LqvxCbtQI7PgZ3LFimXjglToEVsRhUE?cpn=ryCBUs2YUTmn7QV6&amp;mm=31&amp;mn=sn-h5q7dne6&amp;ms=au&amp;mt=1491999386&amp;mv=m&amp;pl=16&amp;expire=1492172385&amp;ip=83.53.198.140&amp;ipbits=0&amp;sparams=expire,ipbits,ip,q:,mm,mn,ms,mv,pl&amp;signature=C0E87B8CC5F8ED96B0D2755C78CFD6A67750BB.43991631DE8BE0064EC8EFAA0CC471996E7DBDE0&amp;key=am3\

  @doc "Prepares body for Download information request"
  def download_params(package, version_code \\ nil) do
    body = [
      { "doc", package },
      { "ot",  "1"     }
    ]

    case version_code do
      nil -> body
      _   -> body ++ [{"vc", version_code}]
    end
  end



  @doc "Generates API specific URLs from specified paths"
  def process_url(path) do
    @url.api <> path
  end


  @doc "API specific GET requests"
  def get!(path, params, headers) do
    super(process_url(path), params, headers)
  end


  @doc "API specific POST requests"
  def post!(path, params, headers) do
    super(process_url(path), params, headers)
  end


  @doc "Prepare headers depending on the type of api request"
  def api_headers(account, type \\ :get) do
    common = [
      { "Authorization",                 "GoogleLogin auth=#{account.auth_token}"  },
      { "X-DFE-Device-Id",               account.device_id                         },

      { "User-Agent",                    @user_agent.api                           },
      { "Accept-Language",               @defaults.language                        },
      { "Host",                          @defaults.host                            },

      { "X-DFE-Client-Id",               @defaults.xdfe.client_id                  },
      { "X-DFE-SmallestScreenWidthDp",   @defaults.xdfe.screen_width               },
      { "X-DFE-Filter-Level",            @defaults.xdfe.filter_level               },
      { "X-DFE-No-Prefetch",             @defaults.xdfe.no_prefetch                },
      { "X-DFE-Enabled-Experiments",     @defaults.xdfe.enabled_experiments        },
      { "X-DFE-Unsupported-Experiments", @defaults.xdfe.unsupported_experiments    }
    ]

    case type do
      :get  -> common
      :post -> common ++ [{"Content-type",  @defaults.content_type}]
      _     -> raise "Unknown Request Type"
    end
  end
end
