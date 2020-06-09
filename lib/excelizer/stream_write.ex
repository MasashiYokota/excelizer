defmodule Excelizer.StreamWrite do
  @moduledoc """
    This is a module to tread excel stream writing.
  """
  alias Excelizer.Native.Base

  @spec set_row(Base.file_id(), String.t(), String.t(), list(tuple())) ::
          Base.nif_resp(Base.file_id())
  def set_row(file_id, sheet_name, column, rows),
    do: Base.set_row(file_id, sheet_name, column, rows)

  @spec set_row!(Base.file_id(), String.t(), String.t(), list(tuple())) ::
          Base.file_id()
  def set_row!(file_id, sheet_name, column, rows) do
    case Base.set_row(file_id, sheet_name, column, rows) do
      {:ok, file_id} -> file_id
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end
end
