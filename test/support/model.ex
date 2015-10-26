defmodule ValidField.Support.Model do
  use Ecto.Model
  import Ecto.Changeset

  schema "contacts" do
    field :first_name, :string
    field :last_name, :string
    field :title, :string

    timestamps
  end

  @required_fields ~w(first_name)
  @optional_fields ~w(last_name title)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:first_name, min: 1)
  end
end
