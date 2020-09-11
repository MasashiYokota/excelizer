defmodule Excelizer.Style.Protection do
  @moduledoc """
    module to manage a struct about protection
  """

  defstruct hidden: false, locked: false

  @typedoc """
  type for cell protection
  """
  @type t :: %__MODULE__{
          hidden: boolean(),
          locked: boolean()
        }
end
