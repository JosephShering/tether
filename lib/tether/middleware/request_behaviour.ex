defmodule Tether.Middleware.RequestBehaviour do
  @callback call(request :: HTTPoison.Request.t(), args :: keyword()) ::
              HTTPoison.Request.t()
end
