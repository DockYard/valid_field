defmodule ValidField.Support.EmbeddedModel do
  use Ecto.Schema

  import Ecto.Changeset

  alias ValidField.Support.EmbeddedModel

  embedded_schema do
    field(:street, :string)
    field(:city, :string)
    field(:postcode, :string)

    timestamps()
  end

  def changeset(%EmbeddedModel{} = embedded_model, params \\ :empty) do
    embedded_model
    |> cast(params, [:street, :city])
    |> validate_required([:street, :city])
  end
end
