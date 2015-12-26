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

  test "valid field with no values passed" do
    ValidField.with_changeset(%Model{first_name: "Test"})
    |> ValidField.assert_valid_field(:first_name)

    assert_raise ExUnit.AssertionError, "Expected the following values to be valid for \"first_name\": nil", fn ->
      ValidField.with_changeset(%Model{})
      |> ValidField.assert_valid_field(:first_name)
    end
  end

  test "valid fields with no values passed" do
    ValidField.with_changeset(%Model{first_name: "Test", last_name: "Something", title: "Something else"})
    |> ValidField.assert_valid_fields([:first_name, :last_name, :title])

    assert_raise ExUnit.AssertionError, "Expected the following values to be valid for \"first_name\": nil", fn ->
      ValidField.with_changeset(%Model{})
      |> ValidField.assert_valid_fields([:first_name, :last_name, :title])
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

  test "invalid field with no values values" do
    ValidField.with_changeset(%Model{})
    |> ValidField.assert_invalid_field(:first_name)

    assert_raise ExUnit.AssertionError, "Expected the following values to be invalid for \"first_name\": \"Test\"", fn ->
      ValidField.with_changeset(%Model{first_name: "Test"})
      |> ValidField.assert_invalid_field(:first_name)
    end
  end

  test "invalid fields with no values values" do
    ValidField.with_changeset(%Model{})
    |> ValidField.assert_invalid_fields([:first_name])

    assert_raise ExUnit.AssertionError, "Expected the following values to be invalid for \"first_name\": \"Test\"", fn ->
      ValidField.with_changeset(%Model{first_name: "Test"})
      |> ValidField.assert_invalid_fields([:first_name])
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

  test "assert_field combines assert_valid_field and assert_invalid_field" do
    ValidField.with_changeset(%Model{})
    |> ValidField.assert_field(:first_name, ["Test", "Good Value"], ["", nil])

    assert_raise ExUnit.AssertionError, "Expected the following values to be valid for \"first_name\": \"\", nil", fn ->
      ValidField.with_changeset(%Model{})
      |> ValidField.assert_field(:first_name, ["", nil], ["", nil])
    end

    assert_raise ExUnit.AssertionError, "Expected the following values to be invalid for \"first_name\": \"Test\", \"Good Value\"", fn ->
      ValidField.with_changeset(%Model{})
      |> ValidField.assert_field(:first_name, ["Test", "Good Value"], ["Test", "Good Value"])
    end
  end

  test "passing changeset directly into assertions" do
    Model.changeset(%Model{}, %{first_name: "Test", last_name: "Something", title: "Something else"})
    |> ValidField.assert_valid_field(:first_name)
    |> ValidField.assert_valid_field(:last_name)
    |> ValidField.assert_valid_field(:title)

    Model.changeset(%Model{}, %{})
    |> ValidField.assert_invalid_field(:first_name)
  end

  test "passing field with key type mismatch from changeset params" do
    ValidField.with_changeset(%Model{}, &Model.other_changeset/2)
    |> ValidField.assert_valid_field(:first_name, ["Test"])
  end

  test "only reports on failed values" do
    changeset = ValidField.with_changeset(%Model{})

    assert_raise ExUnit.AssertionError, "Expected the following values to be valid for \"first_name\": \"a\"", fn ->
      changeset
      |> ValidField.assert_valid_field(:first_name, ["a", "ab"])
    end

    assert_raise ExUnit.AssertionError, "Expected the following values to be invalid for \"first_name\": \"ab\"", fn ->
      changeset
      |> ValidField.assert_invalid_field(:first_name, ["a", "ab"])
    end
  end
end
