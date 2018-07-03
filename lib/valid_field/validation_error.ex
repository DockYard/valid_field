defmodule ValidField.ValidationError do
  @moduledoc """
  Raises validation error.
  """

  defexception [:field, :values, :validity]

  @doc false
  @spec message(Exception.t()) :: String.t()
  def message(exception) do
    formatted_field = inspect(Atom.to_string(exception.field))
    formatted_values = _format_values(exception.values)
    validity = exception.validity

    "Expected the following values to be #{validity} for #{formatted_field}: #{formatted_values}"
  end

  defp _format_values(values) do
    values
    |> Enum.map(&inspect/1)
    |> Enum.join(", ")
  end
end
