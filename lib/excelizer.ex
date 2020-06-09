defmodule Excelizer do
  @moduledoc """
    Excelizer is a NIF wrapper of the excel read/write library written by golang, excelize(https://github.com/360EntSecGroup-Skylar/excelize).
    This module depend on two foreign function interface modules(erlang's NIF and golang's cgo).
    To avoid strange errors(ex. memory leak and ErlangVM scheduling issue etc.),
    we shouldn't recommend to use `Excelizer.Native.Base` module directly as possible as you can.
  """
  alias Excelizer.Native.Base
  alias Excelizer.Workbook

  @spec read_sheet(String.t(), String.t()) :: Base.nif_resp(Base.file_id())
  def read_sheet(filename, sheetname), do: Base.read_sheet(filename, sheetname)

  @spec read_sheet!(String.t(), String.t()) :: Base.file_id()
  def read_sheet!(filename, sheetname) do
    case Base.read_sheet(filename, sheetname) do
      {:ok, resp} -> resp
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end

  @spec open(String.t(), function) :: :ok | :error
  def open(filename, func) do
    if File.exists?(filename) do
      do_open(filename, func)
    else
      raise Excelizer.Exception, message: "invalid filepath"
    end
  end

  defp do_open(filename, func) do
    with {:ok, file_id} <- Base.open_file(filename),
         {:ok, file_id} <- func.(file_id),
         {:ok, file_id} <- Workbook.save(file_id) do
      Base.close_file(file_id)
    else
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end

  @spec new(String.t(), function) :: :ok | :error
  def new(filename, func) do
    with {:ok, file_id} <- Base.new_file(),
         {:ok, file_id} <- func.(file_id),
         {:ok, file_id} <- Workbook.save_as(file_id, filename) do
      Base.close_file(file_id)
    else
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end
end
