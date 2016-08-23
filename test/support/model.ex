defmodule ValidField.Support.Model do
  use Ecto.Model
  import Ecto.Changeset

  schema "contacts" do
    field :first_name, :string
    field :last_name, :string
    field :title, :string
    field :password, :string
    field :password_confirmation
    field :date_of_birth, Ecto.DateTime

    timestamps
  end

  @required_fields ~w(first_name)
  @optional_fields ~w(last_name title password password_confirmation)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:first_name, min: 1)
    |> validate_confirmation(:password)
  end

  def other_changeset(model, params) do
    params = Map.merge(params, %{"title" => "Grand Poobah"})

    changeset(model, params)
  end
end
