defmodule Instagram.Posts.Post do
  use Ecto.Schema
  use Waffle.Ecto.Schema

  alias Instagram.Uploaders.PostImageUploader

  import Ecto.Changeset

  schema "posts" do
    field :description, :string
    field :user_id, :id
    field :image, PostImageUploader.Type

    timestamps(type: :utc_datetime)
  end

  def image_url(post) do
    if post.image do
      PostImageUploader.url({post.image, post}, :original)
    end
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:description, :user_id, :image])
    |> validate_required([:description, :user_id])
  end

  # def update_changeset(post, attrs) do
  #   post
  #   |> cast(attrs, [:description, :user_id, :image])
  #   |> cast_attachments(attrs, [:image])
  #   |> validate_required([:description, :user_id])
  # end
end
