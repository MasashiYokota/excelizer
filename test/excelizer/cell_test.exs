defmodule Excelizer.CellTest do
  use ExUnit.Case
  alias Excelizer.Cell
  alias Excelizer.Native.Base

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

      {status, resp} =
        Cell.set_cell_style(file_id, "Sheet1", "A1", "A2", %{
          "fill" => %{"type" => "gradient", "color" => ["#FFFFFF", "#E0EBF5"], "shading" => 1}
        })

      assert status == :ok
      assert resp == file_id

      Base.close_file(file_id)
    end

    test "failed given invalid file_id" do
      {status, resp} =
        Cell.set_cell_style("invalid file id", "Sheet1", "A1", "A2", %{
          "fill" => %{"type" => "gradient", "color" => ["#FFFFFF", "#E0EBF5"], "shading" => 1}
        })

      assert status == :error
      assert resp == "given invalid file id"
    end
  end

  describe "set_cell_style!/5" do
    test "set a style" do
      {:ok, file_id} = Base.new_file()

      resp =
        Cell.set_cell_style!(file_id, "Sheet1", "A1", "A2", %{
          "fill" => %{"type" => "gradient", "color" => ["#FFFFFF", "#E0EBF5"], "shading" => 1}
        })

      assert resp == file_id

      Base.close_file(file_id)
    end

    test "failed given invalid file_id" do
      assert_raise Excelizer.Exception, "given invalid file id", fn ->
        Cell.set_cell_style!("invalid file id", "Sheet1", "A1", "A2", %{
          "fill" => %{"type" => "gradient", "color" => ["#FFFFFF", "#E0EBF5"], "shading" => 1}
        })
      end
    end
  end
end
