defmodule Instagram.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Instagram.Repo

  alias Instagram.Posts.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  def get_user_post(user_id, post_id) do
    from(p in Post,
      where: p.id == ^post_id and p.user_id == ^user_id
    )
    |> Instagram.Repo.one!()
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  alias Instagram.Posts.Like


  @doc """
  Creates a like.

  ## Examples

      iex> create_like(%{field: value})
      {:ok, %Like{}}

      iex> create_like(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_like(attrs \\ %{}) do
    %Like{}
    |> Like.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, like} ->
        increment_likes_count(like.post_id)
        {:ok, like}

      error ->
        error
    end
  end

  @doc """
  Deletes a like.

  ## Examples

      iex> delete_like(like)
      {:ok, %Like{}}

      iex> delete_like(like)
      {:error, %Ecto.Changeset{}}

  """
  def delete_like(post_id, user_id) do
    from(l in Like, where: l.post_id == ^post_id and l.user_id == ^user_id)
    |> Repo.one()
    |> case do
      nil ->
        {:error, :not_found}

      like ->
        Repo.transaction(fn ->
          Repo.delete!(like)
          decrement_likes_count(post_id)
          {:ok, like}
        end)
    end
  end

  defp increment_likes_count(post_id) do
    from(p in Post, where: p.id == ^post_id)
    |> Repo.update_all(inc: [likes_count: 1])
  end

  defp decrement_likes_count(post_id) do
    from(p in Post, where: p.id == ^post_id)
    |> Repo.update_all(inc: [likes_count: -1])
  end

  def likes?(post_id, user_id) do
    Instagram.Repo.exists?(
      from(f in Like,
        where: f.user_id == ^user_id and f.post_id == ^post_id
      )
    )
  end
end
