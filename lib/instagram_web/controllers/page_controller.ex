defmodule InstagramWeb.PageController do
  use InstagramWeb, :controller

  def home(conn, _params) do
    current_user = conn.assigns.current_user
    render(conn, "home.html", current_user: current_user)
  end
end
