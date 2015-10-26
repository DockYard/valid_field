defmodule ValidField do
  import ExUnit.Assertions, only: [assert: 2]
  @moduledoc ~S"""
  ValidField allows for unit testing values against a changeset. It is assumed that
  the changeset function is defined on the model you are testing.
  """

  @doc """
  Raises an ExUnit.AssertionError when the values for the field are invalid for
  the model provided. Returns the original model to allow subsequent calls to
  be piped

  ## Examples
      iex> ValidField.assert_valid_field(%Model{}, :first_name, ["Test"])
      ...> |> ValidField.assert_valid_field(:last_name, ["Value"])
      iex> ValidField.assert_valid_field(%Model{}, :first_name, [nil, ""])
      ** (ExUnit.AssertionError) Expected the following values to be valid for "first_name": nil, ""
  """
  @spec assert_valid_field(Ecto.Model.t, atom, list) :: Ecto.Model.t
  def assert_valid_field(model, field, values) do
    invalid_values = _map_value_assertions(model, field, values)
    |> Enum.filter_map(fn {_key, value} -> value end, fn {key, _value} -> key end)

    assert invalid_values == [], "Expected the following values to be valid for #{inspect Atom.to_string(field)}: #{_format_values invalid_values}"
    model
  end

  @doc """
  Raises an ExUnit.AssertionError when the values for the field are valid for
  the model provided. Returns the original model to allow subsequent calls to
  be piped

  ## Examples
      iex> ValidField.assert_invalid_field(%Model{}, :first_name, [nil])
      ...> |> ValidField.assert_invalid_field(:first_name, [""])
      iex> ValidField.assert_invalid_field(%Model{}, :first_name, ["Test"])
      ** (ExUnit.AssertionError) Expected the following values to be invalid for "first_name": "Test"
  """
  @spec assert_invalid_field(Ecto.Model.t, atom, list) :: Ecto.Model.t
  def assert_invalid_field(model, field, values) do
    valid_values = _map_value_assertions(model, field, values)
    |> Enum.filter_map(fn {_key, value} -> !value end, fn {key, _value} -> key end)

    assert valid_values == [], "Expected the following values to be invalid for #{inspect Atom.to_string(field)}: #{_format_values valid_values}"
    model
  end

  defp _format_values(values) do
    values
    |> Enum.map(&inspect/1)
    |> Enum.join(", ")
  end

  defp _map_value_assertions(model, field, values) do
    values
    |> Enum.map(fn
      value ->
        attributes = %{}
        |> Map.put(field, value)

        {value,
          model
          |> _errors_for(attributes)
          |> Dict.has_key?(field)
        }
    end)
  end

  defp _errors_for(model, data) do
    model.__struct__.changeset(model, data).errors
  end
end
