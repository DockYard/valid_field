# ValidField [![Build Status](https://travis-ci.org/DockYard/valid_field.svg?branch=master)](https://travis-ci.org/DockYard/valid_field) [![Inline docs](http://inch-ci.org/github/dockyard/valid_field.svg?branch=master)](http://inch-ci.org/github/dockyard/valid_field)

**[ValidField is built and maintained by DockYard, contact us for expert Elixir and Phoenix consulting](https://dockyard.com/phoenix-consulting)**.

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

## Authors

* [Dan McClain](http://twitter.com/_danmcclain)
* [Brian Cardarella](http://twitter.com/bcardarella)

[We are very thankful for the many contributors](https://github.com/DockYard/valid_field/graphs/contributors)

## Versioning

This library follows [Semantic Versioning](http://semver.org)

## Want to help?

Please do! We are always looking to improve this library. Please see our
[Contribution Guidelines](https://github.com/DockYard/valid_field/blob/master/CONTRIBUTING.md)
on how to properly submit issues and pull requests.

## Legal

[DockYard](http://dockyard.com/), Inc. &copy; 2016

[@dockyard](http://twitter.com/DockYard)

[Licensed under the MIT license](http://www.opensource.org/licenses/mit-license.php)
