defmodule Tether.Url do
  def replace(path, params \\ []) when is_binary(path) and is_list(params) do
    Enum.reduce(
      params,
      {path, params},
      fn {key, value}, {path, params} = acc ->
        str_match = ":#{Atom.to_string(key)}"

        new_path = String.replace(path, str_match, get_value(value))
        key_in_path? = new_path != path

        if key_in_path? do
          {
            new_path,
            Keyword.delete(params, key)
          }
        else
          acc
        end
      end
    )
  end

  defp get_value(value) when is_integer(value), do: to_string(value)
  defp get_value(value) when is_boolean(value), do: to_string(value)

  defp get_value(value) when is_struct(value) do
    raise("got struct #{value.__struct__}, not acceptable param value")
  end

  defp get_value(value) when is_map(value) do
    raise("got #{value} map() not acceptable param value")
  end

  defp get_value(value), do: value
end
