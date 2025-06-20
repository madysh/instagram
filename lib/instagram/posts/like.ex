defmodule Instagram.Posts.Like do
  use Ecto.Schema
  import Ecto.Changeset

  schema "likes" do
    field :user_id, :id
    field :post_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, [:post_id, :user_id])
    |> validate_required([:post_id, :user_id])
  end
end
