defmodule InstagramWeb.PageController do
  use InstagramWeb, :controller

  alias Instagram.Posts

  def home(conn, _params) do
    current_user = conn.assigns.current_user
    posts = Posts.list_posts()
    render(conn, "home.html", current_user: current_user, posts: posts)
  end
end
