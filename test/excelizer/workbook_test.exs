defmodule Excelizer.WorkbookTest do
  use ExUnit.Case
  alias Excelizer.Native.Base
  alias Excelizer.Workbook

  setup do
    {:ok, file_id} = Base.new_file()

    on_exit(fn ->
      Base.close_file(file_id)
    end)

    [file_id: file_id]
  end

  describe "new_sheet/2" do
    test "create a new sheet", %{file_id: file_id} do
      {status, resp} = Workbook.new_sheet(file_id, "test")
      assert status == :ok
      assert is_number(resp)
    end

    test "fails to create a new sheet" do
      {status, resp} = Workbook.new_sheet("invalid file id", "test")
      assert status == :error
      assert resp == "given invalid file id"
    end
  end

  describe "new_sheet!/2" do
    test "create a new sheet", %{file_id: file_id} do
      resp = Workbook.new_sheet!(file_id, "test")
      assert is_number(resp)
    end

    test "fails to create a new sheet" do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Workbook.new_sheet!("invalid file id", "test")
      end
    end
  end

  describe "set_active_sheet/2" do
    test "change active sheet", %{file_id: file_id} do
      {status, resp} = Workbook.set_active_sheet(file_id, 1)
      assert status == :ok
      assert resp == file_id
    end

    test "fails to change active sheet" do
      {status, resp} = Workbook.set_active_sheet("invalid file id", 1)
      assert status == :error
      assert resp == "given invalid file id"
    end
  end

  describe "set_active_sheet!/2" do
    test "change active sheet", %{file_id: file_id} do
      file_id = Workbook.set_active_sheet!(file_id, 1)
      assert is_binary(file_id)
    end

    test "fails to change active sheet" do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Workbook.set_active_sheet!("invalid file id", 1)
      end
    end
  end

  describe "delete_sheet/2" do
    test "delete a sheet", %{file_id: file_id} do
      {status, file_id} = Workbook.delete_sheet(file_id, "Sheet1")
      assert status == :ok
      assert is_binary(file_id)
    end

    test "fails to delete a sheet" do
      {status, resp} = Workbook.delete_sheet("invalid file id", "Sheet1")
      assert status == :error
      assert resp == "given invalid file id"
    end
  end

  describe "delete_sheet!/2" do
    test "delete a sheet", %{file_id: file_id} do
      file_id = Workbook.delete_sheet!(file_id, "Sheet1")
      assert is_binary(file_id)
    end

    test "fails to delete a sheet" do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Workbook.delete_sheet!("invalid file id", "Sheet1")
      end
    end
  end

  describe "copy_sheet/2" do
    setup %{file_id: file_id} = context do
      sheet_index1 = Workbook.new_sheet!(file_id, "one")
      sheet_index2 = Workbook.new_sheet!(file_id, "two")
      Map.merge(context, %{sheet_index1: sheet_index1, sheet_index2: sheet_index2})
    end

    test "copy a sheet", %{
      file_id: file_id,
      sheet_index1: sheet_index1,
      sheet_index2: sheet_index2
    } do
      {status, file_id} = Workbook.copy_sheet(file_id, sheet_index1, sheet_index2)
      assert status == :ok
      assert is_binary(file_id)
    end

    test "fails to copy a sheet" do
      {status, resp} = Workbook.copy_sheet("invalid file id", 1, 2)
      assert status == :error
      assert resp == "given invalid file id"
    end
  end

  describe "copy_sheet!/2" do
    setup %{file_id: file_id} = context do
      sheet_index1 = Workbook.new_sheet!(file_id, "one")
      sheet_index2 = Workbook.new_sheet!(file_id, "two")
      Map.merge(context, %{sheet_index1: sheet_index1, sheet_index2: sheet_index2})
    end

    test "copy a sheet", %{
      file_id: file_id,
      sheet_index1: sheet_index1,
      sheet_index2: sheet_index2
    } do
      file_id = Workbook.copy_sheet!(file_id, sheet_index1, sheet_index2)
      assert is_binary(file_id)
    end

    test "fails to copy a sheet" do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Workbook.copy_sheet!("invalid file id", 0, 1)
      end
    end
  end

  describe "set_sheet_background/3" do
    test "set a sheet background image", %{file_id: file_id} do
      path = Path.join([File.cwd!(), "test", "assets", "test_image.jpeg"])
      {status, file_id} = Workbook.set_sheet_background(file_id, "Sheet1", path)
      assert status == :ok
      assert is_binary(file_id)
    end

    test "fails to set a sheet background image" do
      path = Path.join([File.cwd!(), "test", "assets", "test_image.jpeg"])
      {status, resp} = Workbook.set_sheet_background("invalid file id", "Sheet1", path)
      assert status == :error
      assert resp == "given invalid file id"
    end
  end

  describe "set_sheet_background!/3" do
    test "set a sheet background image", %{file_id: file_id} do
      path = Path.join([File.cwd!(), "test", "assets", "test_image.jpeg"])
      file_id = Workbook.set_sheet_background!(file_id, "Sheet1", path)
      assert is_binary(file_id)
    end

    test "fails to set a sheet background image" do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        path = Path.join([File.cwd!(), "test", "assets", "test_image.jpeg"])
        Workbook.set_sheet_background!("invalid file id", "Sheet1", path)
      end
    end
  end

  describe "get_active_sheet_index/1" do
    test "get an active sheet index", %{file_id: file_id} do
      {status, index} = Workbook.get_active_sheet_index(file_id)
      assert status == :ok
      assert index == 0
    end

    test "fails to get an active sheet index" do
      {status, resp} = Workbook.get_active_sheet_index("invalid file id")
      assert status == :error
      assert resp == "given invalid file id"
    end
  end

  describe "get_active_sheet_index!/1" do
    test "set a sheet background image", %{file_id: file_id} do
      index = Workbook.get_active_sheet_index!(file_id)
      assert index == 0
    end

    test "fails to get an active sheet index" do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Workbook.get_active_sheet_index!("invalid file id")
      end
    end
  end

  describe "set_sheet_visible/3" do
    test "makes a sheet visible", %{file_id: file_id} do
      {status, file_id} = Workbook.set_sheet_visible(file_id, "Sheet1", false)
      assert status == :ok
      assert is_binary(file_id)
    end

    test "fails to set make a sheet visible" do
      {status, resp} = Workbook.set_sheet_visible("invalid file id", "Sheet1", false)
      assert status == :error
      assert resp == "given invalid file id"
    end
  end

  describe "set_sheet_visible!/3" do
    test "makes a sheet visible", %{file_id: file_id} do
      file_id = Workbook.set_sheet_visible!(file_id, "Sheet1", false)
      assert is_binary(file_id)
    end

    test "fails to make a sheet visible" do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Workbook.set_sheet_visible!("invalid file id", "Sheet1", false)
      end
    end
  end
end
