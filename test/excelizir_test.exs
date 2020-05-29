defmodule ExcelizirTest do
  use ExUnit.Case
  alias Excelizir.Base

  @tag timeout: :infinity
  test "greets the world" do
    Base.read_sheet("あああ.xlsx", "代表情報") |> IO.inspect()
    Base.read_sheet("test.xlsx", "代表情報") |> IO.inspect()
  end
end
