defmodule ShopiQL.Objects.Order do
  # @enforce_keys [:id, :name]
  defstruct [:id, :name, :__typename, :lineItems, :shippingAddress]

  def decode(result) do
    Enum.reduce(result, %__MODULE__{}, &decode/2)
  end

  def decode({key, %{__typename: connection} = value}, struct) when is_map_key(value, :edges) do
    connection =
      "Elixir.ShopiQL.Connections.#{connection}"
      |> String.to_existing_atom()
      |> apply(:decode, [value])

    %{struct | key => connection}
  end

  def decode({key, %{__typename: object} = value}, struct) do
    object =
      "Elixir.ShopiQL.Objects.#{object}"
      |> String.to_existing_atom()
      |> apply(:decode, [value])

    %{struct | key => object}
  end

  def decode({key, value}, struct) do
    %{struct | key => value}
  end
end
