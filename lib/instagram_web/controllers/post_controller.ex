defmodule InstagramWeb.PostController do
  use InstagramWeb, :controller

  alias Instagram.Repo
  alias Instagram.Posts
  alias Instagram.Posts.Post
  alias Instagram.Accounts

  def index(conn, %{"user_id" => user_id}) do
    user = Accounts.get_user(user_id) |> Repo.preload(:posts)
    render(conn, :index, posts: user.posts, user: user)
  end

  def new(conn, _params) do
    changeset = Posts.change_post(%Post{})
    current_user = conn.assigns.current_user
    render(conn, :new, changeset: changeset, current_user: current_user)
  end

  def create(conn, %{"post" => post_params}) do
    current_user = conn.assigns.current_user
    post_params = Map.put(post_params, "user_id", current_user.id)

    case Posts.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: ~p"/posts/#{post}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset, current_user: current_user)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user
    post = Posts.get_post!(id)
    render(conn, :show, post: post, current_user: current_user)
  end

  def edit(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user
    post = Posts.get_post!(id)
    changeset = Posts.change_post(post)
    render(conn, :edit, post: post, changeset: changeset, current_user: current_user)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    # current_user = conn.assigns.current_user
    post = Posts.get_post!(id)

    case Posts.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: ~p"/posts/#{post}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user
    post = Posts.get_post!(id)
    {:ok, _post} = Posts.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: ~p"/users/#{current_user.id}/posts")
  end
end
