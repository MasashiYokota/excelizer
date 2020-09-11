defmodule Excelizer.Image do
  @moduledoc """
    This is a module to tread an image
  """
  alias Excelizer.Image.Format
  alias Excelizer.Native.Base

  @spec add_picture(Base.file_id(), String.t(), String.t(), String.t(), Format.t()) ::
          Base.nif_resp(Base.file_id())
  def add_picture(file_id, sheet_name, cell, picture_path, format) do
    Base.add_picture(file_id, sheet_name, cell, picture_path, Format.convert_to_json(format))
  end

  @spec add_picture!(Base.file_id(), String.t(), String.t(), String.t(), Format.t()) ::
          Base.file_id()
  def add_picture!(file_id, sheet_name, cell, picture_path, format) do
    case Base.add_picture(file_id, sheet_name, cell, picture_path, Format.convert_to_json(format)) do
      {:ok, file_id} -> file_id
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end

  @spec add_picture_from_bytes(
          Base.file_id(),
          String.t(),
          String.t(),
          Format.t(),
          String.t(),
          String.t(),
          binary()
        ) ::
          Base.nif_resp(Base.file_id())
  def add_picture_from_bytes(file_id, sheet_name, cell, format, name, extension, file_data) do
    Base.add_picture_from_bytes(
      file_id,
      sheet_name,
      cell,
      Format.convert_to_json(format),
      name,
      extension,
      file_data
    )
  end

  @spec add_picture_from_bytes!(
          Base.file_id(),
          String.t(),
          String.t(),
          Format.t(),
          String.t(),
          String.t(),
          binary()
        ) ::
          Base.file_id()
  def add_picture_from_bytes!(file_id, sheet_name, cell, format, name, extension, file_data) do
    case Base.add_picture_from_bytes(
           file_id,
           sheet_name,
           cell,
           Format.convert_to_json(format),
           name,
           extension,
           file_data
         ) do
      {:ok, file_id} -> file_id
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end
end
