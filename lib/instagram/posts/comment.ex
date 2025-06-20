defmodule Instagram.Posts.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    belongs_to :user, Instagram.Accounts.User
    belongs_to :post, Instagram.Posts.Post

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:user_id, :post_id, :body])
    |> validate_required([:user_id, :post_id, :body])
  end
end
