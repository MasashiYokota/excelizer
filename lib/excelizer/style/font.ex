defmodule Excelizer.Style.Font do
  @moduledoc """
    module to manage a struct about font
  """

  defstruct bold: false,
            italic: false,
            underline: nil,
            family: nil,
            size: nil,
            strike: false,
            color: nil

  @typedoc """
  type for font
  """
  @type t :: %__MODULE__{
          bold: boolean(),
          italic: boolean(),
          underline: nil | underline(),
          family: String.t() | nil,
          size: number() | nil,
          strike: boolean(),
          color: String.t() | nil
        }

  @typedoc """
  type for font's underline

  * single: single line
  * double: double line
  """
  @type underline :: :single | :double
end
