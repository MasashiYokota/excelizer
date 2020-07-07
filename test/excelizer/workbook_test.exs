defmodule Excelizer.WorkbookTest do
  use ExUnit.Case
  alias Excelizer.Native.Base
  alias Excelizer.Workbook

  describe "new_sheet/2" do
    test "create a new sheet" do
      {:ok, file_id} = Base.new_file()
      {status, resp} = Workbook.new_sheet(file_id, "test")
      assert status == :ok
      assert is_number(resp)
      Base.close_file(file_id)
    end

    test "fails to create a new sheet" do
      {status, resp} = Workbook.new_sheet("invalid file id", "test")
      assert status == :error
      assert resp == "given invalid file id"
    end
  end

  describe "new_sheet!/2" do
    test "create a new sheet" do
      {:ok, file_id} = Base.new_file()
      resp = Workbook.new_sheet!(file_id, "test")
      assert is_number(resp)
      Base.close_file(file_id)
    end

    test "fails to create a new sheet" do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Workbook.new_sheet!("invalid file id", "test")
      end
    end
  end

  describe "set_active_sheet/2" do
    test "change active sheet" do
      {:ok, file_id} = Base.new_file()
      {status, resp} = Workbook.set_active_sheet(file_id, 1)
      assert status == :ok
      assert resp == file_id
      Base.close_file(file_id)
    end

    test "fails to change active sheet" do
      {status, resp} = Workbook.set_active_sheet("invalid file id", 1)
      assert status == :error
      assert resp == "given invalid file id"
    end
  end

  describe "set_active_sheet!/2" do
    test "change active sheet" do
      {:ok, file_id} = Base.new_file()
      file_id = Workbook.set_active_sheet!(file_id, 1)
      assert is_binary(file_id)
      Base.close_file(file_id)
    end

    test "fails to change active sheet" do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Workbook.set_active_sheet!("invalid file id", 1)
      end
    end
  end
end
