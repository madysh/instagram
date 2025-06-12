defmodule Instagram.Uploaders.PostImageUploader do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @extension_whitelist ~w(.jpg .jpeg .png .webp)

  def validate(_version, {file, _scope}) do
    file_extension =
      file.file_name
      |> Path.extname()
      |> String.downcase()

    Enum.member?(@extension_whitelist, file_extension)
  end

  def storage_dir(_, _) do
    "post_images"
  end
end

