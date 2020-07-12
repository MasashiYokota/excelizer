defmodule Excelizer.Worksheet do
  @moduledoc """
    This is a module to tread excel worksheet
  """
  alias Excelizer.Native.Base

  @spec set_col_width(Base.file_id(), String.t(), String.t(), String.t(), number) ::
          Base.nif_resp(Base.file_id())
  def set_col_width(file_id, sheet_name, start_col, end_col, width) do
    Base.set_col_width(file_id, sheet_name, start_col, end_col, width)
  end

  @spec set_col_width!(Base.file_id(), String.t(), String.t(), String.t(), number) ::
          Base.file_id()
  def set_col_width!(file_id, sheet_name, start_col, end_col, width) do
    case Base.set_col_width(file_id, sheet_name, start_col, end_col, width) do
      {:ok, file_id} -> file_id
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end

  @spec set_row_height(Base.file_id(), String.t(), pos_integer(), number) ::
          Base.nif_resp(Base.file_id())
  def set_row_height(file_id, sheet_name, row, height) do
    Base.set_row_height(file_id, sheet_name, row, height)
  end

  @spec set_row_height!(Base.file_id(), String.t(), pos_integer(), number) ::
          Base.file_id()
  def set_row_height!(file_id, sheet_name, row, height) do
    case Base.set_row_height(file_id, sheet_name, row, height) do
      {:ok, file_id} -> file_id
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end
end
