defmodule Instagram.Posts.Post do
  use Ecto.Schema
  use Waffle.Ecto.Schema

  alias Instagram.Uploaders.PostImageUploader

  import Ecto.Changeset

  schema "posts" do
    field :description, :string
    belongs_to :user, Instagram.Accounts.User
    field :image, PostImageUploader.Type
    field :uuid

    timestamps(type: :utc_datetime)
  end

  def image_url(post, version \\ :original) do
    if post.image do
      PostImageUploader.url({post.image, post}, version)
    end
  end

  def changeset(post, attrs) do
    post
    |> Map.update(:uuid, Ecto.UUID.generate, fn val -> val || Ecto.UUID.generate end)
    |> cast(attrs, [:description, :user_id])
    |> cast_attachments(attrs, [:image])
    |> validate_required([:description, :user_id, :image])
  end
end
