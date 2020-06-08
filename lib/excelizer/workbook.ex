defmodule Excelizer.Workbook do
  @moduledoc """
    This is a module to tread excel workbooks
  """
  alias Excelizer.Native.Base

  @spec read_sheet(String.t(), String.t()) :: Base.nif_resp(Base.file_id())
  def read_sheet(filename, sheetname), do: Base.read_sheet(filename, sheetname)

  @spec read_sheet!(String.t(), String.t()) :: Base.file_id()
  def read_sheet!(filename, sheetname) do
    case Base.read_sheet(filename, sheetname) do
      {:ok, resp} -> resp
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end

  @spec save(Base.file_id()) :: Base.nif_resp(Base.file_id())
  def save(file_id), do: Base.save(file_id)

  @spec save!(Base.file_id()) :: Base.file_id()
  def save!(file_id) do
    case Base.save(file_id) do
      {:ok, resp} -> resp
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end

  @spec save_as(Base.file_id(), String.t()) :: Base.nif_resp(Base.file_id())
  def save_as(file_id, filename), do: Base.save_as(file_id, filename)

  @spec save_as!(Base.file_id(), String.t()) :: Base.file_id()
  def save_as!(file_id, filename) do
    case Base.save_as(file_id, filename) do
      {:ok, resp} -> resp
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end

  @spec close_file(Base.file_id()) :: :ok | :error
  def close_file(file_id), do: Base.close_file(file_id)

  @spec close_file!(Base.file_id()) :: :ok
  def close_file!(file_id) do
    case Base.close_file(file_id) do
      :ok -> :ok
      :error -> raise Excelizer.Exception, message: "failed to close file"
    end
  end

  @spec new_file :: {:ok, Base.file_id()}
  def new_file, do: Base.new_file()

  @spec new_sheet(Base.file_id(), String.t()) :: Base.nif_resp(pos_integer)
  def new_sheet(file_id, sheet_name), do: Base.new_sheet(file_id, sheet_name)

  @spec new_sheet!(Base.file_id(), String.t()) :: pos_integer
  def new_sheet!(file_id, sheet_name) do
    case Base.new_sheet(file_id, sheet_name) do
      {:ok, sheet_index} -> sheet_index
      {:error, err} -> raise Excelizer.Exception, message: err
    end
  end
end
