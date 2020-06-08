defmodule ExcelizerTest do
  use ExUnit.Case
  alias Excelizer.Native.Base

  @tag timeout: :infinity
  test "create a new xlsx data" do
    {:ok, file} = Base.new_file()
    {:ok, _file} = Base.new_sheet(file, "hoge")
    {:ok, file} = Base.set_cell_value(file, "hoge", "A1", "string", "test")
    {:ok, file} = Base.save_as(file, "tmp/test.xlsx")
    Base.close_file(file)
  end
end
