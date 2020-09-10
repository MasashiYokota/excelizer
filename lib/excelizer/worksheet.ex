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

  @spec set_col_visible(Base.file_id(), String.t(), String.t(), boolean) ::
          Base.nif_resp(Base.file_id())
  def set_col_visible(file_id, sheet_name, col, visible) do
    Base.set_col_visible(file_id, sheet_name, col, "#{visible}")
  end

  @spec set_col_visible!(Base.file_id(), String.t(), String.t(), boolean) ::
          Base.file_id()
  def set_col_visible!(file_id, sheet_name, col, visible) do
    case Base.set_col_visible(file_id, sheet_name, col, "#{visible}") do
      {:ok, file_id} -> file_id
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end

  @spec set_row_visible(Base.file_id(), String.t(), pos_integer(), boolean) ::
          Base.nif_resp(Base.file_id())
  def set_row_visible(file_id, sheet_name, row, visible) do
    Base.set_row_visible(file_id, sheet_name, row, "#{visible}")
  end

  @spec set_row_visible!(Base.file_id(), String.t(), pos_integer(), boolean) ::
          Base.file_id()
  def set_row_visible!(file_id, sheet_name, row, visible) do
    case Base.set_row_visible(file_id, sheet_name, row, "#{visible}") do
      {:ok, file_id} -> file_id
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end

  @spec get_sheet_name(Base.file_id(), integer()) :: Base.nif_resp(String.t())
  def get_sheet_name(file_id, sheet_id) do
    Base.get_sheet_name(file_id, sheet_id)
  end

  @spec get_sheet_name!(Base.file_id(), integer()) :: String.t()
  def get_sheet_name!(file_id, sheet_id) do
    case Base.get_sheet_name(file_id, sheet_id) do
      {:ok, sheet_name} -> sheet_name
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end

  @spec get_col_visible(Base.file_id(), String.t(), String.t()) :: boolean()
  def get_col_visible(file_id, sheet_name, column) do
    case Base.get_col_visible(file_id, sheet_name, column) do
      {:ok, "true"} -> true
      {:ok, "false"} -> false
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end

  @spec get_col_width(Base.file_id(), String.t(), String.t()) :: Base.nif_resp(float)
  def get_col_width(file_id, sheet_name, column) do
    Base.get_col_width(file_id, sheet_name, column)
  end

  @spec get_col_width!(Base.file_id(), String.t(), String.t()) :: float
  def get_col_width!(file_id, sheet_name, column) do
    case Base.get_col_width(file_id, sheet_name, column) do
      {:ok, width} -> width
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end

  @spec get_row_height(Base.file_id(), String.t(), pos_integer()) :: Base.nif_resp(float)
  def get_row_height(file_id, sheet_name, row) do
    Base.get_row_height(file_id, sheet_name, row)
  end

  @spec get_row_height!(Base.file_id(), String.t(), pos_integer()) :: float
  def get_row_height!(file_id, sheet_name, row) do
    case Base.get_row_height(file_id, sheet_name, row) do
      {:ok, height} -> height
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end

  @spec get_row_visible(Base.file_id(), String.t(), pos_integer()) :: boolean()
  def get_row_visible(file_id, sheet_name, row) do
    case Base.get_row_visible(file_id, sheet_name, row) do
      {:ok, "true"} -> true
      {:ok, "false"} -> false
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end

  @spec get_sheet_index(Base.file_id(), String.t()) :: Base.nif_resp(integer())
  def get_sheet_index(file_id, sheet_name) do
    Base.get_sheet_index(file_id, sheet_name)
  end

  @spec get_sheet_index!(Base.file_id(), String.t()) :: integer()
  def get_sheet_index!(file_id, sheet_name) do
    case Base.get_sheet_index(file_id, sheet_name) do
      {:ok, index} -> index
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end
end
