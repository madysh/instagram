defmodule InstagramWeb.UserController do
  use InstagramWeb, :controller
  alias Instagram.Accounts

  def index(conn, _params) do
    current_user = conn.assigns.current_user
    users = Accounts.list_users()
    following_user_ids = if current_user, do: Accounts.get_following_users(current_user.id), else: []
    render(conn, "index.html", users: users, current_user: current_user, following_user_ids: following_user_ids)
  end

  def follow(conn, %{"user_id" => user_id}) do
    user_id = String.to_integer(user_id)
    current_user = conn.assigns.current_user

    if current_user.id == user_id do
      conn
      |> put_flash(:error, "You cannot follow yourself.")
      |> redirect(to: "/users")
      |> halt()
    end

    if Accounts.following?(current_user.id, user_id) do
      conn
      |> put_flash(:info, "You are already following this user.")
      |> redirect(to: "/users")
    else
      Accounts.follow!(current_user.id, user_id)
      conn
      |> put_flash(:info, "Success")
      |> redirect(to: "/users")
    end
  end

  def unfollow(conn, %{"user_id" => user_id}) do
    user_id = String.to_integer(user_id)
    current_user = conn.assigns[:current_user]

    if current_user.id == user_id do
      conn
      |> put_flash(:error, "You cannot follow yourself.")
      |> redirect(to: "/users")
      |> halt()
    end

    if Accounts.following?(current_user.id, user_id) do
      Accounts.unfollow!(current_user.id, user_id)
      conn
      |> put_flash(:info, "Success")
      |> redirect(to: "/users")
    else
      conn
      |> put_flash(:info, "You are not following this user.")
      |> redirect(to: "/users")
    end
  end
end
