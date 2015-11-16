defmodule ValidField do
  import ExUnit.Assertions, only: [assert: 2]
  @moduledoc ~S"""
  ValidField allows for unit testing values against a changeset.
  """

  @doc """
  Raises an ExUnit.AssertionError when the values for the field are invalid for
  the changset provided. Returns the original changset map from `with_changeset/1`
  to allow subsequent calls to be piped

  ## Examples
      iex> ValidField.with_changeset(%Model{})
      ...> |> ValidField.assert_valid_field(:first_name, ["Test"])
      ...> |> ValidField.assert_valid_field(:last_name, ["Value"])
      iex> ValidField.with_changeset(%Model{})
      ...> |> ValidField.assert_valid_field(:first_name, [nil, ""])
      ** (ExUnit.AssertionError) Expected the following values to be valid for "first_name": nil, ""
  """
  @spec assert_valid_field(map, atom, list) :: map
  def assert_valid_field(changeset, field, values) do
    invalid_values = _map_value_assertions(changeset, field, values)
    |> Enum.filter_map(fn {_key, value} -> value end, fn {key, _value} -> key end)

    assert invalid_values == [], "Expected the following values to be valid for #{inspect Atom.to_string(field)}: #{_format_values invalid_values}"
    changeset
  end

  @doc """
  Raises an ExUnit.AssertionError when the values for the field are valid for
  the changset provided. Returns the original changset map from `with_changeset/1`
  to allow subsequent calls to be piped

  ## Examples
      iex> ValidField.with_changeset(%Model{})
      ...> |> ValidField.assert_invalid_field(:first_name, [nil])
      ...> |> ValidField.assert_invalid_field(:first_name, [""])
      iex> ValidField.with_changeset(%Model{})
      ...> |> ValidField.assert_invalid_field(:first_name, ["Test"])
      ** (ExUnit.AssertionError) Expected the following values to be invalid for "first_name": "Test"
  """
  @spec assert_invalid_field(map, atom, list) :: map
  def assert_invalid_field(changeset, field, values) do
    valid_values = _map_value_assertions(changeset, field, values)
    |> Enum.filter_map(fn {_key, value} -> !value end, fn {key, _value} -> key end)

    assert valid_values == [], "Expected the following values to be invalid for #{inspect Atom.to_string(field)}: #{_format_values valid_values}"
    changeset
  end

  @doc """
  Combines `assert_valid_field/3` and `assert_invalid_field/3` into a single call.
  The third argument is the collection of valid values to be tested. The fourth argument 
  is the collection of invalid values to be tested.

  ## Examples
      ValidField.with_changeset(%Model{})
      |> ValidField.assert_field(:first_name, ["George", "Barry"], ["", nil])
  """
  @spec assert_field(map, atom, list, list) :: map
  def assert_field(changeset, field, valid_values, invalid_values) do
    changeset
    |> assert_valid_field(field, valid_values)
    |> assert_invalid_field(field, invalid_values)
  end

  @doc """
  Returns a changeset map to be used with `assert_valid_field/3` or
  `assert_invalid_field/3`. When with_changeset is passed a single arguments, it is
  assumed to be an Ecto Model struct and will call the `changeset` function on
  the struct's module

  ## Examples
      ValidField.with_changeset(%Model{})
      |> ValidField.assert_invalid_field(:first_name, [nil])
      |> ValidField.assert_invalid_field(:first_name, [""])
  """
  @spec with_changeset(Ecto.Model.t) :: map
  def with_changeset(model), do: with_changeset(model, &model.__struct__.changeset/2)

  @doc """
  Returns a changeset map to be used with `assert_valid_field/3` or
  `assert_invalid_field/3`. The function passed to `with_changeset/2` must accept two
  arguments, the first being the model provided to `with_changeset/2`, the second
  being the map of properties to be applied in the changeset.

  ## Examples
      ValidField.with_changeset(%Model{}, &Model.changeset/2)
      |> ValidField.assert_invalid_field(:first_name, [nil])
      |> ValidField.assert_invalid_field(:first_name, [""])
  """
  @spec with_changeset(Ecto.Model.t, function) :: map
  def with_changeset(model, func) when is_function(func), do: %{model: model, changeset_func: func}

  defp _format_values(values) do
    values
    |> Enum.map(&inspect/1)
    |> Enum.join(", ")
  end

  defp _map_value_assertions(changeset, field, values) do
    values
    |> Enum.map(fn value -> {value, _is_invalid_for(changeset, field, value)} end)
  end

  defp _is_invalid_for(%{model: model, changeset_func: changeset}, field, value) do
    params = Map.put(%{},field, value)
    changeset.(model, params).errors
    |> Dict.has_key?(field)
  end
end
