defmodule ValidFieldTest do
  use ExUnit.Case
  alias ValidField.Support.Model
  doctest ValidField

  test "valid field values" do
    ValidField.with_changeset(%Model{})
    |> ValidField.assert_valid_field(:first_name, ["Test", "Good Value"])
    |> ValidField.assert_valid_field(:last_name, ["", nil, "Something"])
    |> ValidField.assert_valid_field(:title, ["", nil, "Something else"])

    assert_raise ExUnit.AssertionError, "Expected the following values to be invalid for \"first_name\": \"Test\", \"Good Value\"", fn ->
      ValidField.with_changeset(%Model{})
      |> ValidField.assert_invalid_field(:first_name, ["Test", "Good Value"])
    end

    assert_raise ExUnit.AssertionError, "Expected the following values to be invalid for \"last_name\": \"\", nil, \"Something\"", fn ->
      ValidField.with_changeset(%Model{})
      |> ValidField.assert_invalid_field(:last_name, ["", nil, "Something"])
    end

    assert_raise ExUnit.AssertionError, "Expected the following values to be invalid for \"title\": \"\", nil, \"Something else\"", fn ->
      ValidField.with_changeset(%Model{})
      |> ValidField.assert_invalid_field(:title, ["", nil, "Something else"])
    end
  end

  test "invalid field values" do
    ValidField.with_changeset(%Model{})
    |> ValidField.assert_invalid_field(:first_name, ["", nil])

    assert_raise ExUnit.AssertionError, "Expected the following values to be valid for \"first_name\": \"\", nil", fn ->
      ValidField.with_changeset(%Model{})
      |> ValidField.assert_valid_field(:first_name, ["", nil])
    end
  end

  test "passing funciton to changeset" do
    custom_changeset_function = ValidField.with_changeset(%Model{}, &Model.changeset/2)
    |> ValidField.assert_invalid_field(:first_name, ["", nil])

    assert_raise ExUnit.AssertionError, "Expected the following values to be valid for \"first_name\": \"\", nil", fn ->
      custom_changeset_function
      |> ValidField.assert_valid_field(:first_name, ["", nil])
    end
  end
end
