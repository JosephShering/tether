defmodule Tether do
  defmacro __using__(_args) do
    quote do
      import Tether.Actions
      import Tether.Middleware

      Module.register_attribute(__MODULE__, :path, accumulate: true)
      Module.register_attribute(__MODULE__, :request_hooks, accumulate: true)
      Module.register_attribute(__MODULE__, :response_hooks, accumulate: true)
    end
  end
end
