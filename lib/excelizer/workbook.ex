defmodule Excelizer.Workbook do
  @moduledoc """
    This is a module to tread excel workbooks
  """
  alias Excelizer.Native.Base

  @spec new_sheet(Base.file_id(), String.t()) :: Base.nif_resp(pos_integer)
  def new_sheet(file_id, sheet_name), do: Base.new_sheet(file_id, sheet_name)

  @spec new_sheet!(Base.file_id(), String.t()) :: pos_integer
  def new_sheet!(file_id, sheet_name) do
    case Base.new_sheet(file_id, sheet_name) do
      {:ok, sheet_index} -> sheet_index
      {:error, err} -> raise Excelizer.Exception, message: err
    end
  end

  @spec set_active_sheet(Base.file_id(), pos_integer) :: Base.nif_resp(Base.file_id())
  def set_active_sheet(file_id, sheet_id), do: Base.set_active_sheet(file_id, sheet_id)

  @spec set_active_sheet!(Base.file_id(), pos_integer) :: Base.file_id()
  def set_active_sheet!(file_id, sheet_id) do
    case Base.set_active_sheet(file_id, sheet_id) do
      {:ok, file_id} -> file_id
      {:error, err} -> raise Excelizer.Exception, message: err
    end
  end

  @spec delete_sheet(Base.file_id(), String.t()) :: Base.nif_resp(Base.file_id())
  def delete_sheet(file_id, sheet_name), do: Base.delete_sheet(file_id, sheet_name)

  @spec delete_sheet!(Base.file_id(), String.t()) :: Base.file_id()
  def delete_sheet!(file_id, sheet_name) do
    case Base.delete_sheet(file_id, sheet_name) do
      {:ok, file_id} -> file_id
      {:error, err} -> raise Excelizer.Exception, message: err
    end
  end

  @spec copy_sheet(Base.file_id(), pos_integer, pos_integer) :: Base.nif_resp(Base.file_id())
  def copy_sheet(file_id, from, to), do: Base.copy_sheet(file_id, from, to)

  @spec copy_sheet!(Base.file_id(), pos_integer, pos_integer) :: Base.file_id()
  def copy_sheet!(file_id, from, to) do
    case Base.copy_sheet(file_id, from, to) do
      {:ok, file_id} -> file_id
      {:error, err} -> raise Excelizer.Exception, message: err
    end
  end

  @spec set_sheet_background(Base.file_id(), String.t(), String.t()) ::
          Base.nif_resp(Base.file_id())
  def set_sheet_background(file_id, sheet_name, picture_path),
    do: Base.set_sheet_background(file_id, sheet_name, picture_path)

  @spec set_sheet_background!(Base.file_id(), String.t(), String.t()) :: Base.file_id()
  def set_sheet_background!(file_id, sheet_name, picture_path) do
    case Base.set_sheet_background(file_id, sheet_name, picture_path) do
      {:ok, file_id} -> file_id
      {:error, err} -> raise Excelizer.Exception, message: err
    end
  end

  @spec get_active_sheet_index(Base.file_id()) :: Base.nif_resp(pos_integer)
  def get_active_sheet_index(file_id),
    do: Base.get_active_sheet_index(file_id)

  @spec get_active_sheet_index!(Base.file_id()) :: pos_integer()
  def get_active_sheet_index!(file_id) do
    case Base.get_active_sheet_index(file_id) do
      {:ok, sheet_id} -> sheet_id
      {:error, err} -> raise Excelizer.Exception, message: err
    end
  end

  @spec set_sheet_visible(Base.file_id(), String.t(), boolean) ::
          Base.nif_resp(Base.file_id())
  def set_sheet_visible(file_id, sheet_name, visible),
    do: Base.set_sheet_visible(file_id, sheet_name, to_string(visible))

  @spec set_sheet_visible!(Base.file_id(), String.t(), boolean) :: Base.file_id()
  def set_sheet_visible!(file_id, sheet_name, visible) do
    case Base.set_sheet_visible(file_id, sheet_name, to_string(visible)) do
      {:ok, sheet_id} -> sheet_id
      {:error, err} -> raise Excelizer.Exception, message: err
    end
  end

  @spec get_sheet_visible(Base.file_id(), String.t()) :: boolean
  def get_sheet_visible(file_id, sheet_name) do
    case Base.get_sheet_visible(file_id, sheet_name) do
      {:ok, "true"} -> true
      {:ok, "false"} -> false
      {:error, err} -> raise Excelizer.Exception, message: err
    end
  end
end
