defmodule Excelizir.Base do
  @compile {:autoload, false}
  @on_load {:init, 0}

  def init do
    case load_nif() do
      :ok ->
        :ok

      e ->
        IO.inspect(e)
    end
  end

  def read_sheet(filename, sheetname)
  def read_sheet(_, _), do: IO.inspect(1)

  defp load_nif do
    # path = :filename.join('./go_src/nif_excelizir')
    path = :filename.join(:code.priv_dir(:excelizir), 'excelizir_nif')
    :erlang.load_nif(path, 0)
  end
end
