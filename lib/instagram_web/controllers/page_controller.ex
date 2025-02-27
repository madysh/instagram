defmodule InstagramWeb.PageController do
  use InstagramWeb, :controller

  alias Instagram.Accounts

  def home(conn, _params) do
    users = Accounts.list_users()
    render(conn, "home.html", users: users)
  end
end
