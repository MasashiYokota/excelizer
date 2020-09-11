defmodule Excelizer.Style.Fill do
  @moduledoc """
    module to manage a struct about filling
  """

  defstruct type: nil,
            pattern: 0,
            color: [],
            shading: :horizontal

  @typedoc """
  type for filling style
  """
  @type t :: %__MODULE__{
          type: String.t() | nil,
          pattern: pattern(),
          color: [String.t()],
          shading: shading()
        }

  @typedoc """
  type for shading pattern
  """
  @type shading ::
          :horizontal | :vertical | :diagonal_up | :diagonal_down | :from_corner | :from_center

  @typedoc """
  type for filling pattern

   Index | Style           | Index | Style
  -------+-----------------+-------+-----------------
   0     | None            | 10    | darkTrellis
   1     | solid           | 11    | lightHorizontal
   2     | mediumGray      | 12    | lightVertical
   3     | darkGray        | 13    | lightDown
   4     | lightGray       | 14    | lightUp
   5     | darkHorizontal  | 15    | lightGrid
   6     | darkVertical    | 16    | lightTrellis
   7     | darkDown        | 17    | gray125
   8     | darkUp          | 18    | gray0625
   9     | darkGrid        |       |
  """
  @type pattern :: 0..18

  @doc """
  convert Fill struct to json

  ## Example
      iex> convert_to_map(%Excelizer.Style.Fill{shading: :horizontal})
      %{color: [], pattern: 0, shading: 0, type: nil}

      iex> convert_to_map(%Excelizer.Style.Fill{shading: :vertical})
      %{color: [], pattern: 0, shading: 1, type: nil}

      iex> convert_to_map(%Excelizer.Style.Fill{shading: :diagonal_up})
      %{color: [], pattern: 0, shading: 2, type: nil}

      iex> convert_to_map(%Excelizer.Style.Fill{shading: :diagonal_down})
      %{color: [], pattern: 0, shading: 3, type: nil}

      iex> convert_to_map(%Excelizer.Style.Fill{shading: :from_corner})
      %{color: [], pattern: 0, shading: 4, type: nil}

      iex> convert_to_map(%Excelizer.Style.Fill{shading: :from_center})
      %{color: [], pattern: 0, shading: 5, type: nil}
  """
  @spec convert_to_map(__MODULE__.t()) :: map
  def convert_to_map(data = %__MODULE__{}) do
    data
    |> Map.put(:shading, format_shading(data))
    |> Map.from_struct()
  end

  defp format_shading(%{shading: :horizontal}), do: 0
  defp format_shading(%{shading: :vertical}), do: 1
  defp format_shading(%{shading: :diagonal_up}), do: 2
  defp format_shading(%{shading: :diagonal_down}), do: 3
  defp format_shading(%{shading: :from_corner}), do: 4
  defp format_shading(%{shading: :from_center}), do: 5
end
