defmodule ValidField do
  @moduledoc ~S"""
  ValidField allows for unit testing values against a changeset.
  """

  @doc """
  Raises an ValidField.ValidationError when the values for the field are invalid for
  the changset provided. Returns the original changset map from `with_changeset/1`
  to allow subsequent calls to be piped

  ## Examples
      iex> ValidField.with_changeset(%Model{})
      ...> |> ValidField.assert_valid_field(:first_name, ["Test"])
      ...> |> ValidField.assert_valid_field(:last_name, ["Value"])
      iex> ValidField.with_changeset(%Model{})
      ...> |> ValidField.assert_valid_field(:first_name, [nil, ""])
      ** (ValidField.ValidationError) Expected the following values to be valid for "first_name": nil, ""
  """
  @spec assert_valid_field(Ecto.Changeset.t(), atom, list) :: Ecto.Changeset.t() | no_return
  def assert_valid_field(changeset, field, values) do
    invalid_values =
      changeset
      |> map_value_assertions(field, values)
      |> Enum.filter(fn {_key, value} -> value end)
      |> Enum.map(fn {key, _value} -> key end)

    if invalid_values != [] do
      raise ValidField.ValidationError, field: field, values: values, validity: "valid"
    end

    changeset
  end

  @doc """
  Will assert if the given field's current value in the changeset is valid or not.

  ## Examples
      iex> ValidField.with_changeset(%Model{first_name: "Test"})
      ...> |> ValidField.assert_valid_field(:first_name)
      iex> ValidField.with_changeset(%Model{})
      ...> |> ValidField.assert_valid_field(:first_name)
      ** (ValidField.ValidationError) Expected the following values to be valid for "first_name": nil
  """
  @spec assert_valid_field(Ecto.Changeset.t(), atom) :: Ecto.Changeset.t() | no_return
  def assert_valid_field(changeset, field) do
    assert_valid_field(changeset, field, [Map.get(changeset.data, field)])
  end

  @doc """
  Will assert if the given fields current values in the changeset are valid or not.

  Only returns an error on the first occurance, doesn't collect.

  ## Examples
      iex> ValidField.with_changeset(%Model{})
      ...> |> ValidField.assert_valid_fields([:first_name, :last_name])
      iex> ValidField.with_changeset(%Model{first_name: "Test", last_name: "Something"})
      ...> |> ValidField.assert_valid_fields([:first_name, :last_name])
      ** (ValidField.ValidationError) Expected the following values to be valid for "first_name": nil
  """
  @spec assert_valid_fields(Ecto.Changeset.t(), list) :: Ecto.Changeset.t() | no_return
  def assert_valid_fields(changeset, fields) when is_list(fields) do
    Enum.each(fields, &assert_valid_field(changeset, &1))

    changeset
  end

  @doc """
  Raises an ValidField.ValidationError when the values for the field are valid for
  the changset provided. Returns the original changset map from `with_changeset/1`
  to allow subsequent calls to be piped

  ## Examples
      iex> ValidField.with_changeset(%Model{})
      ...> |> ValidField.assert_invalid_field(:first_name, [nil])
      ...> |> ValidField.assert_invalid_field(:first_name, [""])
      iex> ValidField.with_changeset(%Model{})
      ...> |> ValidField.assert_invalid_field(:first_name, ["Test"])
      ** (ValidField.ValidationError) Expected the following values to be invalid for "first_name": "Test"
  """
  @spec assert_invalid_field(Ecto.Changeset.t(), atom, list) :: Ecto.Changeset.t() | no_return
  def assert_invalid_field(changeset, field, values) do
    valid_values =
      changeset
      |> map_value_assertions(field, values)
      |> Enum.filter(fn {_key, value} -> !value end)
      |> Enum.map(fn {key, _value} -> key end)

    if valid_values != [] do
      raise ValidField.ValidationError, field: field, values: valid_values, validity: "invalid"
    end

    changeset
  end

  @doc """
  Will assert if the given field's current value in the changeset is invalid or not.

  ## Examples
      iex> ValidField.with_changeset(%Model{})
      ...> |> ValidField.assert_invalid_field(:first_name)
      iex> ValidField.with_changeset(%Model{first_name: "Test"})
      ...> |> ValidField.assert_invalid_field(:first_name)
      ** (ValidField.ValidationError) Expected the following values to be invalid for "first_name": "Test"
  """
  @spec assert_invalid_field(Ecto.Changeset.t(), atom) :: Ecto.Changeset.t() | no_return
  def assert_invalid_field(changeset, field) do
    assert_invalid_field(changeset, field, [Map.get(changeset.data, field)])
  end

  @doc """
  Will assert if the given fields current values in the changeset are invalid or not.

  Only returns an error on the first occurance, doesn't collect.

  ## Examples
      iex> ValidField.with_changeset(%Model{})
      ...> |> ValidField.assert_invalid_fields([:first_name])
      iex> ValidField.with_changeset(%Model{first_name: "Test"})
      ...> |> ValidField.assert_invalid_fields([:first_name])
      ** (ValidField.ValidationError) Expected the following values to be invalid for "first_name": "Test"
  """
  @spec assert_invalid_fields(Ecto.Changeset.t(), list) :: Ecto.Changeset.t() | no_return
  def assert_invalid_fields(changeset, fields) when is_list(fields) do
    Enum.each(fields, fn field -> assert_invalid_field(changeset, field) end)

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
  @spec assert_field(Ecto.Changeset.t(), atom, list, list) :: Ecto.Changeset.t() | no_return
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
  @spec with_changeset(Ecto.Model.t()) :: %{data: any, changeset_func: fun}
  def with_changeset(model),
    do: with_changeset(model, &model.__struct__.changeset/2)

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
  @spec with_changeset(Ecto.Model.t(), function) :: %{data: any, changeset_func: fun}
  def with_changeset(model, func) when is_function(func),
    do: %{data: model, changeset_func: func}

  @doc """
  Add values that will be set on the changeset during assertion runs
  """
  @spec put_params(Ecto.Changeset.t(), map) :: Ecto.Changeset.t()
  def put_params(changeset, params) when is_map(changeset) do
    Map.put(changeset, :params, params)
  end

  defp map_value_assertions(changeset, field, values) do
    Enum.map(values, &{&1, invalid_for?(changeset, field, &1)})
  end

  defp invalid_for?(%{data: model, params: params, changeset_func: changeset}, field, value) do
    params =
      params
      |> Map.put(field, value)
      |> stringify_keys()

    changeset.(model, params)
    |> Ecto.Changeset.traverse_errors(fn _ -> nil end)
    |> Map.has_key?(field)
  end

  defp invalid_for?(%{data: model, changeset_func: changeset}, field, value),
    do: invalid_for?(%{params: %{}, data: model, changeset_func: changeset}, field, value)

  defp invalid_for?(changeset, field, _value),
    do: Keyword.has_key?(changeset.errors, field)

  defp stringify_field(field) when is_atom(field),
    do: Atom.to_string(field)

  defp stringify_field(field) when is_binary(field), do: field

  defp stringify_keys(%{__struct__: _struct} = struct), do: struct

  defp stringify_keys(map) when is_map(map),
    do:
      Enum.into(map, %{}, fn {key, value} ->
        {stringify_field(key), stringify_keys(value)}
      end)

  defp stringify_keys(value), do: value
end
