# ValidField

[![Build Status](https://travis-ci.org/dockyard/valid_field.svg?branch=master)](https://travis-ci.org/dockyard/valid_field)
[![Inline docs](http://inch-ci.org/github/dockyard/valid_field.svg?branch=master)](http://inch-ci.org/github/dockyard/valid_field)

ValidField allows you to unit test changesets

## Usage

Add valid_field to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:valid_field, "~> 0.2.0", only: :test}]
end
```

Then in your unit test:

```elixir
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
```

Alternatively you can combine the `assert_valid_field/3` and
`assert_invalid_field/3` syntax into `assert_field/4`. Refactoring the
same example above using `assert_field/4` would yield:

```elixir
defmodule App.UserTest do
  import ValidField
  alias App.User

  test ".changeset - Validations" do
    with_changeset(%User{})
    |> assert_field(:email, ["something@else.com"], ["", nil, "test"])
    |> assert_field(:password, ["password123!"], [nil, "", "test", "nospecialcharacters1", "nonumber!"])
  end
end
```

## Copyright & License

Copyright (c) 2015, Dan McClain.

ValidField source code is licensed under the [MIT License](http://opensource.org/licenses/MIT)
