defmodule Excelizer.Native.Base do
  @compile {:autoload, false}
  @on_load {:init, 0}

  @type file_id :: String.t()
  @type nif_resp(type) :: {:ok, type} | {:error, String.t()}

  def init do
    case load_nif() do
      :ok ->
        :ok

      e ->
        IO.inspect(e)

        raise """
        An error occurred when loading Excelizer Go library.
        Make sure your environemnt (e.g. C compiler, Erlang version, Elixir version).
        """
    end
  end

  def read_sheet(filename, sheetname)
  def read_sheet(_, _), do: :erlang.nif_error(:not_loaded)

  @spec open_file(String.t()) :: nif_resp(file_id())
  def open_file(filename)
  def open_file(_), do: :erlang.nif_error(:not_loaded)

  @spec new_file :: nif_resp(file_id())
  def new_file
  def new_file, do: :erlang.nif_error(:not_loaded)

  @spec set_col_width(file_id(), String.t(), String.t(), String.t(), number) ::
          nif_resp(file_id())
  def set_col_width(file_id, sheet_name, start_col, end_col, width)
  def set_col_width(_, _, _, _, _), do: :erlang.nif_error(:not_loaded)

  @spec set_row_height(file_id(), String.t(), pos_integer(), number) ::
          nif_resp(file_id())
  def set_row_height(file_id, sheet_name, row, height)
  def set_row_height(_, _, _, _), do: :erlang.nif_error(:not_loaded)

  @spec set_col_visible(file_id(), String.t(), String.t(), String.t()) ::
          nif_resp(file_id())
  def set_col_visible(file_id, sheet_name, col, boolean)
  def set_col_visible(_, _, _, _), do: :erlang.nif_error(:not_loaded)

  @spec set_row_visible(file_id(), String.t(), pos_integer(), String.t()) ::
          nif_resp(file_id())
  def set_row_visible(file_id, sheet_name, row, boolean)
  def set_row_visible(_, _, _, _), do: :erlang.nif_error(:not_loaded)

  def new_sheet(file_id, sheet_name)
  def new_sheet(_, _), do: :erlang.nif_error(:not_loaded)

  def set_active_sheet(file_id, sheet_id)
  def set_active_sheet(_, _), do: :erlang.nif_error(:not_loaded)

  def save_as(file_id, path)
  def save_as(_, _), do: :erlang.nif_error(:not_loaded)

  def save(file_id)
  def save(_), do: :erlang.nif_error(:not_loaded)

  def delete_sheet(file_id, sheet_name)
  def delete_sheet(_, _), do: :erlang.nif_error(:not_loaded)

  def copy_sheet(file_id, from, to)
  def copy_sheet(_, _, _), do: :erlang.nif_error(:not_loaded)

  def set_sheet_background(file_id, sheet_name, picture_path)
  def set_sheet_background(_, _, _), do: :erlang.nif_error(:not_loaded)

  def get_active_sheet_index(file_id)
  def get_active_sheet_index(_), do: :erlang.nif_error(:not_loaded)

  def set_sheet_visible(file_id, sheet_name, visible)
  def set_sheet_visible(_, _, _), do: :erlang.nif_error(:not_loaded)

  def get_sheet_visible(file_id, sheet_name)
  def get_sheet_visible(_, _), do: :erlang.nif_error(:not_loaded)

  def get_sheet_name(file_id, sheet_id)
  def get_sheet_name(_, _), do: :erlang.nif_error(:not_loaded)

  def get_col_visible(file_id, sheet_id, column)
  def get_col_visible(_, _, _), do: :erlang.nif_error(:not_loaded)

  def close_file(file_id)
  def close_file(_), do: :erlang.nif_error(:not_loaded)

  def set_cell_value(file_id, sheet_name, column, value_type, value)
  def set_cell_value(_, _, _, _, _), do: :erlang.nif_error(:not_loaded)

  def set_cell_style(file_id, sheet_name, hcell, vcell, style)
  def set_cell_style(_, _, _, _, _), do: :erlang.nif_error(:not_loaded)

  def set_row(file_id, sheet_name, column, rows)
  def set_row(_, _, _, _), do: :erlang.nif_error(:not_loaded)

  defp load_nif do
    path = :filename.join(:code.priv_dir(:excelizer), 'excelizer_nif')
    :erlang.load_nif(path, 0)
  end
end
