defmodule Tether.Actions do
  defmacro get(path, name, opts \\ []), do: action(:get, path: path, name: name, opts: opts)
  defmacro post(path, name, opts \\ []), do: action(:post, path: path, name: name, opts: opts)
  defmacro put(path, name, opts \\ []), do: action(:put, path: path, name: name, opts: opts)
  defmacro patch(path, name, opts \\ []), do: action(:patch, path: path, name: name, opts: opts)
  defmacro delete(path, name, opts \\ []), do: action(:delete, path: path, name: name, opts: opts)

  defp action(:get = method, opts) do
    path = Keyword.get(opts, :path, "")
    name = Keyword.fetch!(opts, :name)
    headers = Keyword.get(opts, :headers, [])
    params = Keyword.get(opts, :params, [])

    quote location: :keep do
      @spec unquote(name)(params :: keyword()) :: any()
      def unquote(name)(params \\ []) do
        params = Keyword.merge(unquote(params), params)

        host = Application.get_env(:tether, Tether)[:host]
        path = Enum.join(@path) <> unquote(path)
        {new_path, new_params} = Tether.Url.replace(path, params)

        ensure_no_missing_params(new_path)

        %HTTPoison.Request{
          url: host <> new_path,
          params: new_params,
          method: unquote(method),
          body: "{}",
          options: [],
          headers: unquote(headers)
        }
        |> run_hooks(@request_hooks)
        |> HTTPoison.request()
        |> run_hooks(@response_hooks)
      end
    end
  end

  defp action(method, opts) do
    path = Keyword.get(opts, :path, "")
    name = Keyword.fetch!(opts, :name)
    headers = Keyword.get(opts, :headers, [])
    params = Keyword.get(opts, :params, [])

    quote location: :keep do
      def unquote(name)() do
        host = Application.get_env(:tether, Tether)[:host]
        path = Enum.join(@path) <> unquote(path)
        {new_path, _new_params} = Tether.Url.replace(path, [])

        ensure_no_missing_params(new_path)

        %HTTPoison.Request{
          url: host <> new_path,
          params: [],
          method: unquote(method),
          body: "{}",
          options: [],
          headers: unquote(headers)
        }
        |> run_hooks(@request_hooks)
        |> HTTPoison.request()
        |> run_hooks(@response_hooks)
      end

      def unquote(name)(params) when is_list(params) do
        params = Keyword.merge(unquote(params), params)
        host = Application.get_env(:tether, Tether)[:host]
        path = Enum.join(@path) <> unquote(path)
        {new_path, new_params} = Tether.Url.replace(path, params)

        ensure_no_missing_params(new_path)

        %HTTPoison.Request{
          url: host <> new_path,
          params: new_params,
          method: unquote(method),
          body: "{}",
          options: [],
          headers: unquote(headers)
        }
        |> run_hooks(@request_hooks)
        |> HTTPoison.request()
        |> run_hooks(@response_hooks)
      end

      def unquote(name)(body, params \\ []) when is_map(body) and is_list(params) do
        params = Keyword.merge(unquote(params), params)

        host = Application.get_env(:tether, Tether)[:host]
        path = Enum.join(@path) <> unquote(path)
        {new_path, new_params} = Tether.Url.replace(path, params)

        ensure_no_missing_params(new_path)

        %HTTPoison.Request{
          url: host <> new_path,
          params: new_params,
          method: unquote(method),
          body: Jason.encode!(body),
          options: [],
          headers: unquote(headers)
        }
        |> run_hooks(@request_hooks)
        |> HTTPoison.request()
        |> run_hooks(@response_hooks)
      end
    end
  end

  def run_hooks(data, hooks) do
    Enum.reduce(
      hooks,
      data,
      fn {module, args}, data ->
        apply(module, :call, [data, args])
      end
    )
  end

  def ensure_no_missing_params(path) do
    missing_params = Regex.scan(~r/:\w+/, path) |> List.flatten()

    if missing_params != [] do
      raise """
        #{Enum.join(missing_params, ", ")} variable(s) found in the url after path compilation.
        Ensure you are passing params with those keys into the request.
      """
    end
  end
end
