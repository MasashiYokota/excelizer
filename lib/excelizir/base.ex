defmodule Excelizir.Base do
  @compile {:autoload, false}
  @on_load {:init, 0}

  def init do
    case load_nif() do
      :ok ->
        :ok

      _ ->
        raise """
        An error occurred when loading Excelizir Go library.
        Make sure your environemnt (e.g. C compiler, Erlang version, Elixir version).
        """
    end
  end

  def read_sheet(filename, sheetname)
  def read_sheet(_, _), do: :erlang.nif_error(:not_loaded)

  def open_file(filename)
  def open_file(_), do: :erlang.nif_error(:not_loaded)

  def new_file
  def new_file, do: :erlang.nif_error(:not_loaded)

  def new_sheet(file_id, sheet_name)
  def new_sheet(_, _), do: :erlang.nif_error(:not_loaded)

  def set_cell_value(file_id, sheet_name, column, value_type, value)
  def set_cell_value(_, _, _, _, _), do: :erlang.nif_error(:not_loaded)

  def set_cell_style(file_id, sheet_name, hcell, vcell, style)
  def set_cell_style(_, _, _, _, _), do: :erlang.nif_error(:not_loaded)

  def set_active_sheet(file_id, sheet_id)
  def set_active_sheet(_, _), do: :erlang.nif_error(:not_loaded)

  def save_as(file_id, path)
  def save_as(_, _), do: :erlang.nif_error(:not_loaded)

  def close_file(file_id)
  def close_file(_), do: :erlang.nif_error(:not_loaded)

  defp load_nif do
    # path = :filename.join('./go_src/nif_excelizir')
    path = :filename.join(:code.priv_dir(:excelizir), 'excelizir_nif')
    :erlang.load_nif(path, 0)
  end
end
