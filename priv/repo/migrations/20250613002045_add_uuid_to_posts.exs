defmodule Instagram.Repo.Migrations.AddUuidToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :uuid, :string
    end
  end
end
