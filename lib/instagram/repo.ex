defmodule Instagram.Repo do
  use Ecto.Repo,
    otp_app: :instagram,
    adapter: Ecto.Adapters.SQLite3
end
