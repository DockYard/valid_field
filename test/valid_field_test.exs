defmodule ValidFieldTest do
  use ExUnit.Case
  alias ValidField.Support.Model
  doctest ValidField

  test "valid field values" do
    %Model{}
    |> ValidField.assert_valid_field(:first_name, ["Test", "Good Value"])
    |> ValidField.assert_valid_field(:last_name, ["", nil, "Something"])
    |> ValidField.assert_valid_field(:title, ["", nil, "Something else"])

    assert_raise ExUnit.AssertionError, "Expected the following values to be invalid for \"first_name\": \"Test\", \"Good Value\"", fn ->
      %Model{}
      |> ValidField.assert_invalid_field(:first_name, ["Test", "Good Value"])
    end

    assert_raise ExUnit.AssertionError, "Expected the following values to be invalid for \"last_name\": \"\", nil, \"Something\"", fn ->
      %Model{}
      |> ValidField.assert_invalid_field(:last_name, ["", nil, "Something"])
    end

    assert_raise ExUnit.AssertionError, "Expected the following values to be invalid for \"title\": \"\", nil, \"Something else\"", fn ->
      %Model{}
      |> ValidField.assert_invalid_field(:title, ["", nil, "Something else"])
    end
  end

  test "invalid field values" do
    %Model{}
    |> ValidField.assert_invalid_field(:first_name, ["", nil])

    assert_raise ExUnit.AssertionError, "Expected the following values to be valid for \"first_name\": \"\", nil", fn ->
      %Model{}
      |> ValidField.assert_valid_field(:first_name, ["", nil])
    end
  end
end
