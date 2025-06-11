defmodule Tether.Middleware.ResponseBehaviour do
  @callback call(
              response :: {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()},
              args :: keyword()
            ) :: any()
end
