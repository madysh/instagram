defmodule Instagram.Accounts.Follower do
  use Ecto.Schema
  import Ecto.Changeset

  schema "followers" do

    field :user_id, :id
    field :follower_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(follower, attrs) do
    follower
    |> cast(attrs, [:user_id, :follower_id])
    |> validate_required([:user_id, :follower_id])
  end
end
