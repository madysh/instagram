defmodule Instagram.Uploaders.PostImageUploader do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @extension_whitelist ~w(.jpg .jpeg .png .webp)
  @versions [:original, :thumb]

  # # Define a thumbnail transformation:
  # def transform(:thumb, _) do
  #   {:convert, "-strip -thumbnail 150x150^ -gravity center -extent 150x150"}
  # end

  # Override the persisted filenames:
  def filename(version, {_file, scope}) do
    "#{version}_#{scope.uuid}"
  end

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

