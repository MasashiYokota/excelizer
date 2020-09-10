defmodule Excelizer.Cell do
  @moduledoc """
    This is a module to tread excel cell
  """
  alias Excelizer.Native.Base
  @type value :: String.t() | number | boolean | nil

  @acceptable_value_types ["int", "float", "string", "boolean", "datetime", "nil"]

  @spec set_cell_value(Base.file_id(), String.t(), String.t(), String.t(), value) ::
          Base.nif_resp(Base.file_id())
  def set_cell_value(file_id, sheet_name, column, value_type, value)
      when value_type in @acceptable_value_types do
    converted_value = convert_according_to_value_type(value, value_type)
    Base.set_cell_value(file_id, sheet_name, column, value_type, converted_value)
  end

  @spec set_cell_value!(Base.file_id(), String.t(), String.t(), String.t(), value) ::
          Base.file_id()
  def set_cell_value!(file_id, sheet_name, column, value_type, value)
      when value_type in @acceptable_value_types do
    converted_value = convert_according_to_value_type(value, value_type)

    case Base.set_cell_value(file_id, sheet_name, column, value_type, converted_value) do
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

  @spec merge_cell(Base.file_id(), String.t(), String.t(), String.t()) ::
          Base.nif_resp(Base.file_id())
  def merge_cell(file_id, sheet_name, hcell, vcell),
    do: Base.merge_cell(file_id, sheet_name, hcell, vcell)

  @spec merge_cell!(Base.file_id(), String.t(), String.t(), String.t()) ::
          Base.file_id()
  def merge_cell!(file_id, sheet_name, hcell, vcell) do
    case Base.merge_cell(file_id, sheet_name, hcell, vcell) do
      {:ok, file_id} -> file_id
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end

  @spec unmerge_cell(Base.file_id(), String.t(), String.t(), String.t()) ::
          Base.nif_resp(Base.file_id())
  def unmerge_cell(file_id, sheet_name, hcell, vcell),
    do: Base.unmerge_cell(file_id, sheet_name, hcell, vcell)

  @spec unmerge_cell!(Base.file_id(), String.t(), String.t(), String.t()) ::
          Base.file_id()
  def unmerge_cell!(file_id, sheet_name, hcell, vcell) do
    case Base.unmerge_cell(file_id, sheet_name, hcell, vcell) do
      {:ok, file_id} -> file_id
      {:error, err_msg} -> raise Excelizer.Exception, message: err_msg
    end
  end

  defp convert_according_to_value_type(value, value_type) when value_type in ["boolean", "nil"],
    do: to_string(value)

  defp convert_according_to_value_type(
         <<_year::binary-size(4), "-", _month::binary-size(2), "-", _date::binary-size(2)>> =
           value,
         "datetime"
       ) do
    "#{value}T00:00:00Z"
  end

  defp convert_according_to_value_type(%Date{} = value, "datetime") do
    "#{Date.to_iso8601(value)}T00:00:00Z"
  end

  defp convert_according_to_value_type(%DateTime{} = value, "datetime") do
    DateTime.to_iso8601(value)
  end

  defp convert_according_to_value_type(value, value_type) when value_type in ["int", "float"],
    do: value

  defp convert_according_to_value_type(value, _value_type),
    do: to_string(value)
end
