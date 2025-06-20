defmodule InstagramWeb.CommentController do
  use InstagramWeb, :controller

  alias Instagram.Posts
  alias Instagram.Posts.Comment

  def create(conn, %{"post_id" => post_id, "comment" => comment_params}) do
    current_user = conn.assigns.current_user
    # comment_params = Map.merge(comment_params, %{"post_id" => post_id, "user_id" => current_user.id})

  comment_params =
    comment_params
    |> Map.merge(%{"post_id" => post_id, "user_id" => current_user.id})
    |> IO.inspect(label: "Comment Params")

    case Posts.create_comment(comment_params) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: ~p"/posts/#{post_id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Posts.get_comment!(id)
    {:ok, _comment} = Posts.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: ~p"/")
  end
end
