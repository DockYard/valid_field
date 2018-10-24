defmodule ValidField.NoFieldError do
  @moduledoc """
  Raised when trying to use a field which doesn't exist on the schema.
  """

  defexception [:field, :schema]

  @doc false
  @spec message(Exception.t()) :: String.t()
  def message(exception) do
    formatted_field =
      exception.field |> Atom.to_string() |> inspect()

    formatted_schema =
      exception.schema |> Atom.to_string() |> inspect() |> String.replace("Elixir.", "")

    "Field #{formatted_field} does not exist on schema #{formatted_schema}."
  end
end
