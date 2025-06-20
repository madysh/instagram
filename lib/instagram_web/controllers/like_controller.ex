defmodule InstagramWeb.LikeController do
  use InstagramWeb, :controller

  alias Instagram.Posts

  def create(conn, %{"post_id" => post_id}) do
    current_user = conn.assigns.current_user

    case Posts.create_like(%{post_id: post_id, user_id: current_user.id}) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Liked")
        |> redirect(to: ~p"/posts/#{post_id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def delete(conn, %{"post_id" => post_id}) do
    current_user = conn.assigns.current_user

    {:ok, _} = Posts.delete_like(post_id, current_user.id)

    conn
    |> put_flash(:info, "Unliked")
    |> redirect(to: ~p"/posts/#{post_id}")
  end
end
