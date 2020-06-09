defmodule ExcelizerTest do
  use ExUnit.Case
  alias Excelizer.Cell

  describe "read_sheet/2" do
    test "read an excel file" do
      {status, results} = Excelizer.read_sheet("tmp/test.xlsx", "Sheet1")
      assert status == :ok
      assert results == [["test"]]
    end

    test "fails to read a file given invalid filename" do
      {status, err_msg} = Excelizer.read_sheet("tmp/hoge_test.xlsx", "Sheet1")
      assert status == :error
      assert err_msg == "open tmp/hoge_test.xlsx: no such file or directory"
    end
  end

  describe "read_sheet!/2" do
    test "read an excel file" do
      results = Excelizer.read_sheet!("tmp/test.xlsx", "Sheet1")
      assert results == [["test"]]
    end

    test "fails to read a file given invalid filename" do
      assert_raise Excelizer.Exception,
                   "open tmp/hoge_test.xlsx: no such file or directory",
                   fn ->
                     Excelizer.read_sheet!("tmp/hoge_test.xlsx", "Sheet1")
                   end
    end
  end

  describe "open/2" do
    test "open and edit an excel file" do
      status =
        Excelizer.open("tmp/test.xlsx", fn file_id ->
          Cell.set_cell_value!(file_id, "Sheet1", "A1", "string", "test")
          {:ok, file_id}
        end)

      assert status == :ok
    end

    test "failed to read a file given invalid filename" do
      assert_raise Excelizer.Exception, "invalid filepath", fn ->
        Excelizer.open("tmp/hoge_test.xlsx", fn file_id ->
          Cell.set_cell_value!(file_id, "Sheet1", "A1", "string", "test")
          {:ok, file_id}
        end)
      end
    end
  end

  describe "new/2" do
    test "create a new excel file" do
      Excelizer.new("tmp/new_test.xlsx", fn file_id ->
        Cell.set_cell_value!(file_id, "Sheet1", "A1", "string", "test")
        {:ok, file_id}
      end)
    end
  end
end
