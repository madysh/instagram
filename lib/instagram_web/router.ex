defmodule InstagramWeb.Router do
  use InstagramWeb, :router

  import InstagramWeb.Warehouse.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {InstagramWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", InstagramWeb do
    pipe_through :browser

    get "/", PageController, :home, as: :home
    get "/users", UserController, :index, as: :users

    resources "/posts", PostController, except: [:index] do
      resources "/comments", CommentController, only: [:create]
    end

    resources "/comments", CommentController, only: [:delete]

    scope "/users/:user_id" do
      post "/follow", UserController, :follow, as: :follow_user
      post "/unfollow", UserController, :unfollow, as: :unfollow_user
      get "/posts", PostController, :index, as: :user_posts
    end

    post "/likes/:post_id", LikeController, :create, as: :user_post_like_create
    delete "/likes/:post_id", LikeController, :delete, as: :user_post_like_delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", InstagramWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:instagram, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: InstagramWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/warehouse", InstagramWeb.Warehouse, as: :warehouse do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{InstagramWeb.Warehouse.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/warehouse", InstagramWeb.Warehouse, as: :warehouse do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{InstagramWeb.Warehouse.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/warehouse", InstagramWeb.Warehouse, as: :warehouse do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{InstagramWeb.Warehouse.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
