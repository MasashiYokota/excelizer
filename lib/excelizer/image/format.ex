defmodule Excelizer.Image.Format do
  @moduledoc """
    module to manage a struct for Excelizer.Image module
  """
  defstruct x_scale: nil,
            y_scale: nil,
            x_offset: nil,
            y_offset: nil,
            print_obj: false,
            lock_aspect_ratio: false,
            locked: false,
            positioning: nil,
            hyperlink: nil,
            hyperlink_type: nil

  @typedoc """
    struct for Excelizer.Image module

    * x_scale / y_scale: scale for x/y axis
    * x_offset / y_offset: offset for x/y axis
    * print_obj: printing an attached image
    * lock_aspect_ratio: if true, lock aspect ratio of an attached image
    * locked: if true, users can't modify an attached image,
    * positioning:
        :one_cell → (Move but don't size with cells).
        :absolute → (Don't move or size with cells).
        If you don't set this parameter, default positioning is move and size with cells.
    * hyperlink: if you set, you can add a hyperlink to an attached image,
    * hyperlink_type:
        :external → link for external source
        :location → link for internal excel location. When you use it, coordinates need to start with `#`.
  """
  @type t :: %__MODULE__{
          x_scale: nil | number(),
          y_scale: nil | number(),
          x_offset: nil | number(),
          y_offset: nil | number(),
          print_obj: boolean(),
          lock_aspect_ratio: boolean(),
          locked: boolean(),
          positioning: nil | :one_cell | :absolute,
          hyperlink: nil | String.t(),
          hyperlink_type: nil | :external | :location
        }

  @doc """
    convert Format struct to json string
    ## Example
        iex> data = convert_to_json(%Excelizer.Image.Format{})
        iex> Poison.decode!(data)
        %{
          "hyperlink" => nil,
          "hyperlink_type" => nil,
          "lock_aspect_ratio" => false,
          "locked" => false,
          "positioning" => nil,
          "print_obj" => false,
          "x_offset" => nil,
          "x_scale" => nil,
          "y_offset" => nil,
          "y_scale" => nil
        }

        iex> data = convert_to_json(%Excelizer.Image.Format{positioning: :one_cell, hyperlink_type: :external})
        iex> Poison.decode!(data)
        %{
          "hyperlink" => nil,
          "hyperlink_type" => "External",
          "lock_aspect_ratio" => false,
          "locked" => false,
          "positioning" => "oneCell",
          "print_obj" => false,
          "x_offset" => nil,
          "x_scale" => nil,
          "y_offset" => nil,
          "y_scale" => nil
        }

        iex> data = convert_to_json(%Excelizer.Image.Format{positioning: :absolute, hyperlink_type: :location})
        iex> Poison.decode!(data)
        %{
          "hyperlink" => nil,
          "hyperlink_type" => "Location",
          "lock_aspect_ratio" => false,
          "locked" => false,
          "positioning" => "absolute",
          "print_obj" => false,
          "x_offset" => nil,
          "x_scale" => nil,
          "y_offset" => nil,
          "y_scale" => nil
        }
  """
  @spec convert_to_json(t()) :: String.t()
  def convert_to_json(data = %__MODULE__{}) do
    data
    |> Map.from_struct()
    |> Map.put(:positioning, format_positioning(data))
    |> Map.put(:hyperlink_type, format_hyperlink_type(data))
    |> Poison.encode!()
  end

  defp format_positioning(%{positioning: nil}), do: nil
  defp format_positioning(%{positioning: :one_cell}), do: "oneCell"
  defp format_positioning(%{positioning: :absolute}), do: "absolute"

  defp format_hyperlink_type(%{hyperlink_type: nil}), do: nil
  defp format_hyperlink_type(%{hyperlink_type: :external}), do: "External"
  defp format_hyperlink_type(%{hyperlink_type: :location}), do: "Location"
end
