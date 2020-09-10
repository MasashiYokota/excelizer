defmodule Excelizer.WorksheetTest do
  use ExUnit.Case
  alias Excelizer.Native.Base
  alias Excelizer.Worksheet
  alias Excelizer.Cell

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
    test "sets column visible", %{file_id: file_id} do
      {status, resp} = Worksheet.set_col_visible(file_id, "Sheet1", "A", true)
      assert status == :ok
      assert resp == file_id
    end

    test "fails to set column visible", %{file_id: file_id} do
      {status, resp} = Worksheet.set_col_visible("invalid ", "Sheet1", "A", true)
      assert status == :error
      assert resp == "given invalid file id"

      {status, resp} = Worksheet.set_col_visible(file_id, "Sheet1", 1, true)
      assert status == :error
      assert resp == "invalid column name \"\""
    end
  end

  describe "set_col_visible!/3" do
    test "sets column visible", %{file_id: file_id} do
      resp = Worksheet.set_col_visible!(file_id, "Sheet1", "A", true)
      assert resp == file_id
    end

    test "fails to set column visible", %{file_id: file_id} do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Worksheet.set_col_visible!("invalid ", "Sheet1", "A", true)
      end

      assert_raise Excelizer.Exception, "invalid column name \"\"", fn ->
        Worksheet.set_col_visible!(file_id, "Sheet1", 1, true)
      end
    end
  end

  describe "set_row_visible/3" do
    test "sets row visible", %{file_id: file_id} do
      {status, resp} = Worksheet.set_row_visible(file_id, "Sheet1", 1, true)
      assert status == :ok
      assert resp == file_id
    end

    test "fails to set row visible", %{file_id: file_id} do
      {status, resp} = Worksheet.set_row_visible("invalid ", "Sheet1", 1, true)
      assert status == :error
      assert resp == "given invalid file id"

      {status, resp} = Worksheet.set_row_visible(file_id, "Sheet1", "A", true)
      assert status == :error
      assert resp == "invalid row number 0"
    end
  end

  describe "set_row_visible!/3" do
    test "sets width row width", %{file_id: file_id} do
      resp = Worksheet.set_row_visible!(file_id, "Sheet1", 1, true)
      assert resp == file_id
    end

    test "fails to set col width", %{file_id: file_id} do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Worksheet.set_row_visible!("invalid ", "Sheet1", 1, true)
      end

      assert_raise Excelizer.Exception, "invalid row number 0", fn ->
        Worksheet.set_row_visible!(file_id, "Sheet1", "A", true)
      end
    end
  end

  describe "get_sheet_name/2" do
    test "get sheet name", %{file_id: file_id} do
      {status, resp} = Worksheet.get_sheet_name(file_id, 0)
      assert status == :ok
      assert resp == "Sheet1"
    end

    test "return blank string when given invalid sheet id", %{file_id: file_id} do
      {status, resp} = Worksheet.get_sheet_name(file_id, -100)
      assert status == :ok
      assert resp == ""
    end

    test "fails to set row visible" do
      {status, resp} = Worksheet.get_sheet_name("invalid ", 1)
      assert status == :error
      assert resp == "given invalid file id"
    end
  end

  describe "get_col_visible/3" do
    test "get a column visibility", %{file_id: file_id} do
      assert Worksheet.get_col_visible(file_id, "Sheet1", "A")
    end

    test "raise Error when given invalid argument", %{file_id: file_id} do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Worksheet.get_col_visible("invalid file id", "Sheet1", "A")
      end

      assert_raise Excelizer.Exception, "invalid column name \"1\"", fn ->
        Worksheet.get_col_visible(file_id, "Sheet1", "1")
      end
    end
  end

  describe "get_col_width/3" do
    test "return {:ok, width} of given valid sheet_name and column", %{file_id: file_id} do
      {status, width} = Worksheet.get_col_width(file_id, "Sheet1", "A")
      assert status == :ok
      assert width == 64.0
    end

    test "return {:error, error_msg} of given invalid sheet_name and column", %{file_id: file_id} do
      {status, width} = Worksheet.get_col_width("invalid file_id", "Sheet1", "A")
      assert status == :error
      assert width == "given invalid file id"

      {status, width} = Worksheet.get_col_width(file_id, "Sheet1", "1")
      assert status == :error
      assert width == "invalid column name \"1\""
    end
  end

  describe "get_col_width!/3" do
    test "return width of given valid sheet_name and column", %{file_id: file_id} do
      width = Worksheet.get_col_width!(file_id, "Sheet1", "A")
      assert width == 64.0
    end

    test "raise error when given invalid sheet_name and column", %{file_id: file_id} do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Worksheet.get_col_width!("invalid file id", "Sheet1", "A")
      end

      assert_raise Excelizer.Exception, "invalid column name \"1\"", fn ->
        Worksheet.get_col_width!(file_id, "Sheet1", "1")
      end
    end
  end

  describe "get_row_height/3" do
    test "return {:ok, height} of given valid sheet_name and height", %{file_id: file_id} do
      {status, width} = Worksheet.get_row_height(file_id, "Sheet1", 1)
      assert status == :ok
      assert width == 20.0
    end

    test "return {:error, error_msg} of given invalid sheet_name and height", %{file_id: file_id} do
      {status, width} = Worksheet.get_row_height("invalid file_id", "Sheet1", 1)
      assert status == :error
      assert width == "given invalid file id"

      {status, width} = Worksheet.get_row_height(file_id, "Sheet1", "A")
      assert status == :error
      assert width == "invalid row number 0"
    end
  end

  describe "get_row_height!/3" do
    test "return height of given valid sheet_name and height", %{file_id: file_id} do
      width = Worksheet.get_row_height!(file_id, "Sheet1", 1)
      assert width == 20.0
    end

    test "raise error when given invalid sheet_name and height", %{file_id: file_id} do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Worksheet.get_row_height!("invalid file id", "Sheet1", 1)
      end

      assert_raise Excelizer.Exception, "invalid row number 0", fn ->
        Worksheet.get_row_height!(file_id, "Sheet1", "A")
      end
    end
  end

  describe "get_row_visible/3" do
    test "get a column visibility", %{file_id: file_id} do
      file_id = Cell.set_cell_value!(file_id, "Sheet1", "A1", "int", 1)
      assert Worksheet.get_row_visible(file_id, "Sheet1", 1)
      file_id = Worksheet.set_row_visible!(file_id, "Sheet1", 1, false)
      refute Worksheet.get_row_visible(file_id, "Sheet1", 1)
    end

    test "raise Error when given invalid argument", %{file_id: file_id} do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Worksheet.get_row_visible("invalid file id", "Sheet1", 1)
      end

      assert_raise Excelizer.Exception, "invalid row number 0", fn ->
        Worksheet.get_row_visible(file_id, "Sheet1", "A")
      end
    end
  end

  describe "get_sheet_index/3" do
    test "return {:ok, index} of given valid sheet_name", %{file_id: file_id} do
      {status, index} = Worksheet.get_sheet_index(file_id, "Sheet1")
      assert status == :ok
      assert index == 0
    end

    test "return {:ok, -1} when given invaid sheet_name", %{file_id: file_id} do
      {status, index} = Worksheet.get_sheet_index(file_id, "Sheet100")
      assert status == :ok
      assert index == -1
    end

    test "return {:error, error_msg} of given invalid sheet_name and height" do
      {status, error} = Worksheet.get_sheet_index("invalid file_id", "Sheet1")
      assert status == :error
      assert error == "given invalid file id"
    end
  end
end
