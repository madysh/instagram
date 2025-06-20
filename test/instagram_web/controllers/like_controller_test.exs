defmodule InstagramWeb.LikeControllerTest do
  use InstagramWeb.ConnCase

  import Instagram.PostsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all likes", %{conn: conn} do
      conn = get(conn, ~p"/likes")
      assert html_response(conn, 200) =~ "Listing Likes"
    end
  end

  describe "new like" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/likes/new")
      assert html_response(conn, 200) =~ "New Like"
    end
  end

  describe "create like" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/likes", like: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/likes/#{id}"

      conn = get(conn, ~p"/likes/#{id}")
      assert html_response(conn, 200) =~ "Like #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/likes", like: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Like"
    end
  end

  describe "edit like" do
    setup [:create_like]

    test "renders form for editing chosen like", %{conn: conn, like: like} do
      conn = get(conn, ~p"/likes/#{like}/edit")
      assert html_response(conn, 200) =~ "Edit Like"
    end
  end

  describe "update like" do
    setup [:create_like]

    test "redirects when data is valid", %{conn: conn, like: like} do
      conn = put(conn, ~p"/likes/#{like}", like: @update_attrs)
      assert redirected_to(conn) == ~p"/likes/#{like}"

      conn = get(conn, ~p"/likes/#{like}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, like: like} do
      conn = put(conn, ~p"/likes/#{like}", like: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Like"
    end
  end

  describe "delete like" do
    setup [:create_like]

    test "deletes chosen like", %{conn: conn, like: like} do
      conn = delete(conn, ~p"/likes/#{like}")
      assert redirected_to(conn) == ~p"/likes"

      assert_error_sent 404, fn ->
        get(conn, ~p"/likes/#{like}")
      end
    end
  end

  defp create_like(_) do
    like = like_fixture()
    %{like: like}
  end
end
