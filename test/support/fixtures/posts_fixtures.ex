defmodule Instagram.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Instagram.Posts` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        description: "some description"
      })
      |> Instagram.Posts.create_post()

    post
  end

  @doc """
  Generate a like.
  """
  def like_fixture(attrs \\ %{}) do
    {:ok, like} =
      attrs
      |> Enum.into(%{

      })
      |> Instagram.Posts.create_like()

    like
  end

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        body: "some body"
      })
      |> Instagram.Posts.create_comment()

    comment
  end
end
