defmodule Tether.Middleware do
  defmacro __using__(arg \\ :request) do
    case arg do
      :request ->
        quote do
          @behaviour Tether.Middleware.RequestBehaviour

          import Tether.Middleware
        end

      :response ->
        quote do
          @behaviour Tether.Middleware.ResponseBehaviour

          import Tether.Middleware
        end
    end
  end

  defmacro request(module_ast, args \\ []) do
    module_ast
    |> Macro.expand(__ENV__)
    |> define(:request_hooks, args)
  end

  defmacro response(module_ast, args \\ []) do
    module_ast
    |> Macro.expand(__ENV__)
    |> define(:response_hooks, args)
  end

  defp define(module, name, args) do
    quote do
      Module.put_attribute(__MODULE__, unquote(name), {unquote(module), unquote(args)})
    end
  end
end
