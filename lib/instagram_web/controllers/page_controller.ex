defmodule InstagramWeb.PageController do
  use InstagramWeb, :controller

  def home(conn, _params) do
    render(conn, "home.html")
  end
end
