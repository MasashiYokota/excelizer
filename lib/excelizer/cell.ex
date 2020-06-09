defmodule Excelizer.Cell do
  @moduledoc """
    This is a module to tread excel cell
  """
  alias Excelizer.Native.Base
  @type value :: String.t() | number | boolean | nil

  @spec set_cell_value(Base.file_id(), String.t(), String.t(), String.t(), value) ::
          Base.nif_resp(Base.file_id())
  def set_cell_value(file_id, sheet_name, column, value_type, value),
    do: Base.set_cell_value(file_id, sheet_name, column, value_type, value)

  @spec set_cell_value!(Base.file_id(), String.t(), String.t(), String.t(), value) ::
          Base.file_id()
  def set_cell_value!(file_id, sheet_name, column, value_type, value) do
    case Base.set_cell_value(file_id, sheet_name, column, value_type, value) do
      {:ok, file_id} -> file_id
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end

  @spec set_cell_style(Base.file_id(), String.t(), String.t(), String.t(), map) ::
          Base.nif_resp(Base.file_id())
  def set_cell_style(file_id, sheet_name, hcell, vcell, style),
    do: Base.set_cell_style(file_id, sheet_name, hcell, vcell, Poison.encode!(style))

  @spec set_cell_style!(Base.file_id(), String.t(), String.t(), String.t(), map) ::
          Base.file_id()
  def set_cell_style!(file_id, sheet_name, hcell, vcell, style) do
    case Base.set_cell_style(file_id, sheet_name, hcell, vcell, Poison.encode!(style)) do
      {:ok, file_id} -> file_id
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end
end
