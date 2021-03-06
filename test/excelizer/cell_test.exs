defmodule Excelizer.CellTest do
  use ExUnit.Case
  alias Excelizer.Cell
  alias Excelizer.Native.Base
  alias Excelizer.Style.CellStyle

  describe "set_cell_value/4" do
    test "sets a string value to a target cell" do
      {:ok, file_id} = Base.new_file()
      {status, resp} = Cell.set_cell_value(file_id, "Sheet1", "A1", "string", "test")
      assert status == :ok
      assert resp == file_id
      Base.close_file(file_id)
    end

    test "sets a float value to a target cell" do
      {:ok, file_id} = Base.new_file()
      {status, resp} = Cell.set_cell_value(file_id, "Sheet1", "A1", "float", 1.1)
      assert status == :ok
      assert resp == file_id
      Base.close_file(file_id)
    end

    test "sets a int value to a target cell" do
      {:ok, file_id} = Base.new_file()
      {status, resp} = Cell.set_cell_value(file_id, "Sheet1", "A1", "int", 10)
      assert status == :ok
      assert resp == file_id
      Base.close_file(file_id)
    end

    test "sets a boolean value to a target cell" do
      {:ok, file_id} = Base.new_file()
      {status, resp} = Cell.set_cell_value(file_id, "Sheet1", "A1", "boolean", true)
      assert status == :ok
      assert resp == file_id
      Base.close_file(file_id)
    end

    test "sets a nil value to a target cell" do
      {:ok, file_id} = Base.new_file()
      {status, resp} = Cell.set_cell_value(file_id, "Sheet1", "A1", "nil", nil)
      assert status == :ok
      assert resp == file_id
      Base.close_file(file_id)
    end

    test "sets a datetime value to a target cell" do
      {:ok, file_id} = Base.new_file()

      {status, resp} =
        Cell.set_cell_value(file_id, "Sheet1", "A1", "datetime", ~U[2018-07-16 10:00:00Z])

      assert status == :ok
      assert resp == file_id

      {status, resp} = Cell.set_cell_value(file_id, "Sheet1", "A1", "datetime", ~D[2000-01-01])

      assert status == :ok
      assert resp == file_id

      {status, resp} = Cell.set_cell_value(file_id, "Sheet1", "A1", "datetime", "2018-07-16")

      assert status == :ok
      assert resp == file_id
      Base.close_file(file_id)
    end

    test "fails given invalid value_type" do
      {:ok, file_id} = Base.new_file()

      assert_raise FunctionClauseError,
                   "no function clause matching in Excelizer.Cell.set_cell_value/5",
                   fn ->
                     Cell.set_cell_value(file_id, "Sheet1", "A1", "invalid_type", "test")
                   end

      Base.close_file(file_id)
    end
  end

  describe "set_cell_value!/4" do
    test "sets a string value to a target cell" do
      {:ok, file_id} = Base.new_file()
      resp = Cell.set_cell_value!(file_id, "Sheet1", "A1", "string", "test")
      assert resp == file_id
      Base.close_file(file_id)
    end

    test "sets a float value to a target cell" do
      {:ok, file_id} = Base.new_file()
      resp = Cell.set_cell_value!(file_id, "Sheet1", "A1", "float", 1.1)
      assert resp == file_id
      Base.close_file(file_id)
    end

    test "sets a int value to a target cell" do
      {:ok, file_id} = Base.new_file()
      resp = Cell.set_cell_value!(file_id, "Sheet1", "A1", "int", 10)
      assert resp == file_id
      Base.close_file(file_id)
    end

    test "sets a boolean value to a target cell" do
      {:ok, file_id} = Base.new_file()
      resp = Cell.set_cell_value!(file_id, "Sheet1", "A1", "boolean", true)
      assert resp == file_id
      Base.close_file(file_id)
    end

    test "sets a nil value to a target cell" do
      {:ok, file_id} = Base.new_file()
      resp = Cell.set_cell_value!(file_id, "Sheet1", "A1", "nil", nil)
      assert resp == file_id
      Base.close_file(file_id)
    end

    test "sets a datetime value to a target cell" do
      {:ok, file_id} = Base.new_file()

      resp = Cell.set_cell_value!(file_id, "Sheet1", "A1", "datetime", ~U[2018-07-16 10:00:00Z])
      assert resp == file_id

      resp = Cell.set_cell_value!(file_id, "Sheet1", "A1", "datetime", ~D[2000-01-01])
      assert resp == file_id

      resp = Cell.set_cell_value!(file_id, "Sheet1", "A1", "datetime", "2018-07-16")
      assert resp == file_id
      Base.close_file(file_id)
    end

    test "fails given invalid value_type" do
      {:ok, file_id} = Base.new_file()

      assert_raise FunctionClauseError,
                   "no function clause matching in Excelizer.Cell.set_cell_value!/5",
                   fn ->
                     Cell.set_cell_value!(file_id, "Sheet1", "A1", "invalid_type", "test")
                   end

      Base.close_file(file_id)
    end
  end

  describe "set_cell_style/5" do
    test "set a style" do
      {:ok, file_id} = Base.new_file()

      {status, resp} = Cell.set_cell_style(file_id, "Sheet1", "A1", "A2", %CellStyle{})

      assert status == :ok
      assert resp == file_id

      Base.close_file(file_id)
    end

    test "failed given invalid file_id" do
      {status, resp} = Cell.set_cell_style("invalid file id", "Sheet1", "A1", "A2", %CellStyle{})

      assert status == :error
      assert resp == "given invalid file id"
    end
  end

  describe "set_cell_style!/5" do
    test "set a style" do
      {:ok, file_id} = Base.new_file()

      resp = Cell.set_cell_style!(file_id, "Sheet1", "A1", "A2", %CellStyle{})

      assert resp == file_id

      Base.close_file(file_id)
    end

    test "failed given invalid file_id" do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Cell.set_cell_style!("invalid file id", "Sheet1", "A1", "A2", %CellStyle{})
      end
    end
  end

  describe "merge_cell/5" do
    test "merge cells" do
      {:ok, file_id} = Base.new_file()

      {status, resp} = Cell.merge_cell(file_id, "Sheet1", "A1", "A2")

      assert status == :ok
      assert resp == file_id

      Base.close_file(file_id)
    end

    test "failed given invalid file_id" do
      {status, resp} = Cell.merge_cell("invalid file id", "Sheet1", "A1", "A2")

      assert status == :error
      assert resp == "given invalid file id"
    end
  end

  describe "merge_cell!/5" do
    test "merges cells" do
      {:ok, file_id} = Base.new_file()

      resp = Cell.merge_cell!(file_id, "Sheet1", "A1", "A2")

      assert resp == file_id

      Base.close_file(file_id)
    end

    test "failed given invalid file_id" do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Cell.merge_cell!("invalid file id", "Sheet1", "A1", "A2")
      end
    end
  end

  describe "unmerge_cell/5" do
    test "unmerge cells" do
      {:ok, file_id} = Base.new_file()

      {status, resp} = Cell.unmerge_cell(file_id, "Sheet1", "A1", "A2")

      assert status == :ok
      assert resp == file_id

      Base.close_file(file_id)
    end

    test "failed given invalid file_id" do
      {status, resp} = Cell.unmerge_cell("invalid file id", "Sheet1", "A1", "A2")

      assert status == :error
      assert resp == "given invalid file id"
    end
  end

  describe "unmerge_cell!/5" do
    test "unmerges cells" do
      {:ok, file_id} = Base.new_file()

      resp = Cell.unmerge_cell!(file_id, "Sheet1", "A1", "A2")

      assert resp == file_id

      Base.close_file(file_id)
    end

    test "failed given invalid file_id" do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Cell.unmerge_cell!("invalid file id", "Sheet1", "A1", "A2")
      end
    end
  end

  describe "set_cell_formula/5" do
    test "unmerge cells" do
      {:ok, file_id} = Base.new_file()

      {status, resp} = Cell.set_cell_formula(file_id, "Sheet1", "A1", "SUM(Sheet1!D2,Sheet1!D11)")

      assert status == :ok
      assert resp == file_id

      Base.close_file(file_id)
    end

    test "failed given invalid file_id" do
      {status, resp} =
        Cell.set_cell_formula("invalid file id", "Sheet1", "A1", "SUM(Sheet1!D2,Sheet1!D11)")

      assert status == :error
      assert resp == "given invalid file id"
    end
  end

  describe "set_cell_formula!/5" do
    test "unmerges cells" do
      {:ok, file_id} = Base.new_file()

      resp = Cell.set_cell_formula!(file_id, "Sheet1", "A1", "SUM(Sheet1!D2,Sheet1!D11)")

      assert resp == file_id

      Base.close_file(file_id)
    end

    test "failed given invalid file_id" do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Cell.set_cell_formula!("invalid file id", "Sheet1", "A1", "SUM(Sheet1!D2,Sheet1!D11)")
      end
    end
  end

  describe "get_cell_formula/5" do
    test "unmerge cells" do
      {:ok, file_id} = Base.new_file()

      {_, file_id} = Cell.set_cell_formula(file_id, "Sheet1", "A1", "SUM(Sheet1!D2,Sheet1!D11)")
      {status, formula} = Cell.get_cell_formula(file_id, "Sheet1", "A1")

      assert status == :ok
      assert formula == "SUM(Sheet1!D2,Sheet1!D11)"

      Base.close_file(file_id)
    end

    test "failed given invalid file_id" do
      {status, formula} = Cell.get_cell_formula("invalid file id", "Sheet1", "A1")

      assert status == :error
      assert formula == "given invalid file id"
    end
  end

  describe "get_cell_formula!/5" do
    test "unmerges cells" do
      {:ok, file_id} = Base.new_file()

      _ = Cell.set_cell_formula!(file_id, "Sheet1", "A1", "SUM(Sheet1!D2,Sheet1!D11)")
      formula = Cell.get_cell_formula!(file_id, "Sheet1", "A1")

      assert formula == "SUM(Sheet1!D2,Sheet1!D11)"

      Base.close_file(file_id)
    end

    test "failed given invalid file_id" do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Cell.get_cell_formula!("invalid file id", "Sheet1", "A1")
      end
    end
  end
end
