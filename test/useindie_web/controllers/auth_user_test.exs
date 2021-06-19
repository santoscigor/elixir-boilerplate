defmodule UseIndieWeb.AuthUserTest do
  use UseIndieWeb.ConnCase, async: true

  import UseIndie.Factory
  alias UseIndieWeb.UserAuth

  def fixture(:user, is_active \\ true) do
    insert(:user, is_active: is_active, email: "test0@test0.local", password: "test000")
  end

  def create_user(_) do
    %{user: fixture(:user)}
  end

  describe "fetch_current_user/2" do
    setup [:create_user]

    test "fetches user for valid token", %{conn: conn, user: user} do
      token = UserAuth.get_token(user)

      conn =
        conn
        |> put_req_header("authorization", "Token #{token}")
        |> UserAuth.fetch_current_user([])

      assert conn.assigns.current_user.id == user.id
    end

    test "sets current_user to nil on invalid token" do
      fake_token =
        build_conn()
        |> put_req_header("authorization", "Token fake_token")
        |> UserAuth.fetch_current_user([])

      missing_token =
        build_conn()
        |> put_req_header("authorization", "Token fake_token")
        |> UserAuth.fetch_current_user([])

      assert fake_token.assigns.current_user == nil
      assert missing_token.assigns.current_user == nil
    end
  end

  describe "require_guest_user/2" do
    setup [:create_user]

    test "rejects authenticated users", %{conn: conn, user: user} do
      conn =
        conn
        |> bypass_through(UseIndieWeb.Router, :api)
        |> get("/auth/")
        |> assign(:current_user, user)
        |> UserAuth.require_guest_user([])

      assert conn.halted
    end

    test "accepts guest users", %{conn: conn} do
      conn =
        conn
        |> bypass_through(UseIndieWeb.Router, :api)
        |> get("/auth/")
        |> UserAuth.require_guest_user([])

      refute conn.halted
    end
  end

  describe "require_authenticated_user/2" do
    setup [:create_user]

    test "rejects guest users", %{conn: conn} do
      conn =
        conn
        |> bypass_through(UseIndieWeb.Router, :api)
        |> get("/auth/")
        |> UserAuth.require_authenticated_user([])

      assert conn.halted
    end

    test "accepts authenticated users", %{conn: conn, user: user} do
      conn =
        conn
        |> bypass_through(UseIndieWeb.Router, :api)
        |> get("/auth/")
        |> assign(:current_user, user)
        |> UserAuth.require_authenticated_user([])

      refute conn.halted
    end
  end
end
