defmodule ValidField.Support.Model do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field :first_name, :string
    field :last_name, :string
    field :title, :string
    field :password, :string
    field :password_confirmation
    field :date_of_birth, Ecto.Date

    timestamps()
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, [:first_name, :last_name, :title, :password, :password_confirmation, :date_of_birth])
    |> validate_required([:first_name])
    |> validate_length(:first_name, min: 1)
    |> validate_confirmation(:password)
  end

  def other_changeset(model, params) do
    params = Map.merge(params, %{"title" => "Grand Poobah"})

    changeset(model, params)
  end
end
