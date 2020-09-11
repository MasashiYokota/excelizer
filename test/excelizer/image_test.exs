defmodule Excelizer.ImageTest do
  use ExUnit.Case
  alias Excelizer.Image
  alias Excelizer.Native.Base

  setup do
    {:ok, file_id} = Base.new_file()

    on_exit(fn ->
      Base.close_file(file_id)
    end)

    [file_id: file_id]
  end

  describe "add_picture/5" do
    test "add picture and returns file_id", %{file_id: file_id} do
      path = Path.join([File.cwd!(), "test", "assets", "test_image.jpeg"])
      {status, resp} = Image.add_picture(file_id, "Sheet1", "A1", path, %{})
      assert status == :ok
      assert resp == file_id
    end

    test "return error when given invalid picture path", %{file_id: file_id} do
      path = Path.join([File.cwd!(), "test", "assets", "invalid_data.jpeg"])
      {status, resp} = Image.add_picture(file_id, "Sheet1", "A1", path, %{})
      assert status == :error
      assert String.contains?(resp, "no such file or directory")
    end
  end

  describe "add_picture!/5" do
    test "add picture and returns file_id", %{file_id: file_id} do
      path = Path.join([File.cwd!(), "test", "assets", "test_image.jpeg"])
      resp = Image.add_picture!(file_id, "Sheet1", "A1", path, %{})
      assert resp == file_id
    end

    test "raise error when given invalid picture path", %{file_id: file_id} do
      path = Path.join([File.cwd!(), "test", "assets", "invalid_data.jpeg"])

      assert_raise Excelizer.Exception, "stat #{path}: no such file or directory", fn ->
        Image.add_picture!(file_id, "Sheet1", "A1", path, %{})
      end
    end
  end

  describe "add_picture_from_bytes/5" do
    test "add picture and returns file_id", %{file_id: file_id} do
      path = Path.join([File.cwd!(), "test", "assets", "test_image.jpeg"])
      data = File.read!(path)

      {status, resp} =
        Image.add_picture_from_bytes(
          file_id,
          "Sheet1",
          "A1",
          %{},
          "test_image.jpeg",
          ".jpeg",
          data
        )

      assert status == :ok
      assert resp == file_id
    end

    test "return error when given invalid picture path", %{file_id: file_id} do
      {status, resp} =
        Image.add_picture_from_bytes(file_id, "Sheet1", "A1", %{}, "test image", "txt", "xxx")

      assert status == :error
      assert String.contains?(resp, "unsupported image extension")
    end
  end

  describe "add_picture_from_bytes!/5" do
    test "add picture and returns file_id", %{file_id: file_id} do
      path = Path.join([File.cwd!(), "test", "assets", "test_image.jpeg"])
      data = File.read!(path)

      resp =
        Image.add_picture_from_bytes!(
          file_id,
          "Sheet1",
          "A1",
          %{},
          "test_image.jpeg",
          ".jpeg",
          data
        )

      assert resp == file_id
    end

    test "raise error when given unsupported image extension", %{file_id: file_id} do
      assert_raise Excelizer.Exception, "unsupported image extension", fn ->
        Image.add_picture_from_bytes!(
          file_id,
          "Sheet1",
          "A1",
          %{},
          "test_image.jpeg",
          ".txt",
          "xxx"
        )
      end
    end
  end
end
