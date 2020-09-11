defmodule Excelizer.Style.Border do
  @moduledoc """
    module to manage a struct about border
  """

  defstruct type: nil,
            color: nil,
            style: 0

  @typedoc """
  """
  @type t :: %__MODULE__{
          type: String.t() | nil,
          color: String.t() | nil,
          style: border_style()
        }

  @typedoc """
  type for border's style

   Index | Name          | Weight | Style
  -------+---------------+--------+-------------
   0     | None          | 0      |
   1     | Continuous    | 1      | -----------
   2     | Continuous    | 2      | -----------
   3     | Dash          | 1      | - - - - - -
   4     | Dot           | 1      | . . . . . .
   5     | Continuous    | 3      | -----------
   6     | Double        | 3      | ===========
   7     | Continuous    | 0      | -----------
   8     | Dash          | 2      | - - - - - -
   9     | Dash Dot      | 1      | - . - . - .
   10    | Dash Dot      | 2      | - . - . - .
   11    | Dash Dot Dot  | 1      | - . . - . .
   12    | Dash Dot Dot  | 2      | - . . - . .
   13    | SlantDash Dot | 2      | / - . / - .
  """
  @type border_style :: 0..13
end
