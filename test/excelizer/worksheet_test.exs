defmodule Excelizer.WorksheetTest do
  use ExUnit.Case
  alias Excelizer.Native.Base
  alias Excelizer.Worksheet

  setup do
    {:ok, file_id} = Base.new_file()

    on_exit(fn ->
      Base.close_file(file_id)
    end)

    [file_id: file_id]
  end

  describe "set_col_width/5" do
    test "sets width col width", %{file_id: file_id} do
      {status, resp} = Worksheet.set_col_width(file_id, "Sheet1", "A", "B", 100)
      assert status == :ok
      assert resp == file_id
    end

    test "fails to set col width", %{file_id: file_id} do
      {status, resp} = Worksheet.set_col_width("invalid ", "Sheet1", "A", "B", 100)
      assert status == :error
      assert resp == "given invalid file id"

      {status, resp} = Worksheet.set_col_width(file_id, "Sheet1", "1", "2", 100)
      assert status == :error
      assert resp == "invalid column name \"1\""
    end
  end

  describe "set_col_width!/5" do
    test "sets width col width", %{file_id: file_id} do
      resp = Worksheet.set_col_width!(file_id, "Sheet1", "A", "B", 100)
      assert resp == file_id
    end

    test "fails to set col width", %{file_id: file_id} do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Worksheet.set_col_width!("invalid ", "Sheet1", "A", "B", 100)
      end

      assert_raise Excelizer.Exception, "invalid column name \"1\"", fn ->
        Worksheet.set_col_width!(file_id, "Sheet1", "1", "2", 100)
      end
    end
  end

  describe "set_row_height/4" do
    test "sets width col width", %{file_id: file_id} do
      {status, resp} = Worksheet.set_row_height(file_id, "Sheet1", 1, 100)
      assert status == :ok
      assert resp == file_id
    end

    test "fails to set col width", %{file_id: file_id} do
      {status, resp} = Worksheet.set_row_height("invalid ", "Sheet1", 1, 100)
      assert status == :error
      assert resp == "given invalid file id"

      {status, resp} = Worksheet.set_row_height(file_id, "Sheet1", "A", 100)
      assert status == :error
      assert resp == "invalid row number 0"
    end
  end

  describe "set_row_height!/4" do
    test "sets width col width", %{file_id: file_id} do
      resp = Worksheet.set_row_height!(file_id, "Sheet1", 1, 100)
      assert resp == file_id
    end

    test "fails to set col width", %{file_id: file_id} do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Worksheet.set_row_height!("invalid ", "Sheet1", 1, 100)
      end

      assert_raise Excelizer.Exception, "invalid row number 0", fn ->
        Worksheet.set_row_height!(file_id, "Sheet1", "A", 100)
      end
    end
  end

  describe "set_col_visible/3" do
    test "sets width col width", %{file_id: file_id} do
      {status, resp} = Worksheet.set_col_visible(file_id, "Sheet1", "A", true)
      assert status == :ok
      assert resp == file_id
    end

    test "fails to set col width", %{file_id: file_id} do
      {status, resp} = Worksheet.set_col_visible("invalid ", "Sheet1", "A", true)
      assert status == :error
      assert resp == "given invalid file id"

      {status, resp} = Worksheet.set_col_visible(file_id, "Sheet1", 1, true)
      assert status == :error
      assert resp == "invalid column name \"\""
    end
  end

  describe "set_col_visible!/3" do
    test "sets width col width", %{file_id: file_id} do
      resp = Worksheet.set_col_visible!(file_id, "Sheet1", "A", true)
      assert resp == file_id
    end

    test "fails to set col width", %{file_id: file_id} do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Worksheet.set_col_visible!("invalid ", "Sheet1", "A", true)
      end

      assert_raise Excelizer.Exception, "invalid column name \"\"", fn ->
        Worksheet.set_col_visible!(file_id, "Sheet1", 1, true)
      end
    end
  end
end
