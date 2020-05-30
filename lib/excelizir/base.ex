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
  def open_file(_, _), do: :erlang.nif_error(:not_loaded)

  def close_file(filename)
  def close_file(_, _), do: :erlang.nif_error(:not_loaded)

  defp load_nif do
    # path = :filename.join('./go_src/nif_excelizir')
    path = :filename.join(:code.priv_dir(:excelizir), 'excelizir_nif')
    :erlang.load_nif(path, 0)
  end
end
