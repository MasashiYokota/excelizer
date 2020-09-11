defmodule Excelizer.Style.Alignment do
  @moduledoc """
    module to manage a struct about alignment
  """
  defstruct horizonal: :left,
            indent: nil,
            justify_last_line: false,
            reading_order: nil,
            relative_indent: nil,
            shrink_to_fit: nil,
            text_rotation: nil,
            vertical: :top,
            wrap_text: false

  @typedoc """
    struct for Excelizer.Image module
  """
  @type t :: %__MODULE__{
          horizonal: horizonal(),
          indent: nil | integer(),
          justify_last_line: boolean(),
          reading_order: nil | integer(),
          relative_indent: nil | integer(),
          shrink_to_fit: boolean(),
          text_rotation: nil | integer(),
          vertical: vertical(),
          wrap_text: boolean()
        }

  @typedoc """
  type for horizontal setting

    * left: indented left
    * center: centering
    * right: indented right
    * fill: filling
    * justify: justified
    * center_continuous: cross-column centered
    * distributed: intended decentralized alignment
  """
  @type horizonal ::
          :left | :center | :right | :fill | :justify | :center_continuous | :distributed

  @typedoc """
  type for vertical setting

    * left: indented left
    * center: centering
    * justify: justified
    * distributed: intended decentralized alignment
  """
  @type vertical :: :top | :center | :justify | :distributed

  @doc """
  convert Alignment struct to json

  ## Example
      iex> convert_to_map(%Excelizer.Style.Alignment{horizonal: :center_continuous})
      %{horizonal: "centerContinuous", indent: nil, justify_last_line: false, reading_order: nil, relative_indent: nil, shrink_to_fit: nil, text_rotation: nil, vertical: :top, wrap_text: false}

      iex> convert_to_map(%Excelizer.Style.Alignment{horizonal: :top})
      %{horizonal: "top", indent: nil, justify_last_line: false, reading_order: nil, relative_indent: nil, shrink_to_fit: nil, text_rotation: nil, vertical: :top, wrap_text: false}
  """
  @spec convert_to_map(__MODULE__.t()) :: map
  def convert_to_map(data = %__MODULE__{}) do
    data
    |> Map.put(:horizonal, format_horizontal(data))
    |> Map.from_struct()
  end

  defp format_horizontal(%{horizonal: :center_continuous}), do: "centerContinuous"
  defp format_horizontal(%{horizonal: type}), do: to_string(type)
end
