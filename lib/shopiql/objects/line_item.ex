defmodule ShopiQL.Objects.LineItem do
  # @enforce_keys [:id, :name]
  defstruct [:__typename, :id, :sku]

  def decode(result) do
    Enum.reduce(result, %__MODULE__{}, &decode/2)
  end

  def decode({key, value}, struct) do
    %{struct | key => value}
  end
end
