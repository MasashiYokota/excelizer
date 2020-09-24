defmodule Excelizer do
  @moduledoc """
    Excelizer is a NIF wrapper of the excel read/write library written by golang, excelize(https://github.com/360EntSecGroup-Skylar/excelize).
    This module depend on two foreign function interface modules(erlang's NIF and golang's cgo).
    To avoid strange errors(ex. memory leak and ErlangVM scheduling issue etc.),
    we shouldn't recommend to use `Excelizer.Native.Base` module directly as possible as you can.
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

  @spec open(String.t(), function) :: :ok
  def open(filename, func) do
    if File.exists?(filename) do
      do_open(filename, func)
    else
      raise Excelizer.Exception, message: "invalid filepath"
    end
  end

  defp do_open(filename, func) do
    file_id =
      case Base.open_file(filename) do
        {:ok, file_id} -> file_id
        {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
      end

    try do
      func.(file_id)
      :ok
    after
      Base.close_file(file_id)
    end
  end

  @spec new(String.t(), function) :: :ok
  def new(filename, func) do
    file_id =
      case Base.new_file() do
        {:ok, file_id} -> file_id
        {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
      end

    try do
      func.(file_id)
      {:ok, _} = Base.save_as(file_id, filename)
      :ok
    after
      Base.close_file(file_id)
    end
  end
end
