# ValidField

ValidField allows you to unit test changesets

## Usage

Add valid_field to your list of dependencies in `mix.exs`:

    def deps do
      [{:valid_field, "~> 0.1.0", only: :test}]
    end

Then in your unit test:

    defmodule App.UserTest do
      import ValidField
      alias App.User

      test ".changeset - Validations" do
        with_changeset(%User{})
        |> assert_valid_field(:email, ["something@else.com"])
        |> assert_invalid_field(:email, ["", nil, "test"])
        |> assert_valid_field(:password, ["password123!"])
        |> assert_invalid_field(:password, [nil, "", "test", "nospecialcharacters1", "nonumber!"])
      end
    end

## Copyright & License

Copyright (c) 2015, Dan McClain.

ValidField source code is licensed under the [MIT License](http://opensource.org/licenses/MIT)
