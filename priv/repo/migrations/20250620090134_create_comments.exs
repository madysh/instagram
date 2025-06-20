defmodule Instagram.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :string, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :post_id, references(:posts, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:comments, [:user_id])
    create index(:comments, [:post_id])
  end
end
