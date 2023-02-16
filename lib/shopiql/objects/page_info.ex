defmodule ShopiQL.Objects.PageInfo do
  # @enforce_keys [:id, :name]
  defstruct [:__typename, :startCursor, :endCursor, :hasNextPage, :hasPreviousPage]

  def decode(result) do
    Enum.reduce(result, %__MODULE__{}, &decode/2)
  end

  def decode({key, value}, struct) do
    %{struct | key => value}
  end
end
