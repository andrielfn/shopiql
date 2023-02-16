defmodule ShopiQL.Objects.MailingAddress do
  # @enforce_keys [:id, :name]
  defstruct [:__typename, :address1]

  def decode(result) do
    Enum.reduce(result, %__MODULE__{}, &decode/2)
  end

  def decode({key, %{__typename: connection} = value}, struct) when is_map_key(value, :edges) do
    "Elixir.ShopiQL.Connections.#{connection}"
    |> String.to_existing_atom()
    |> apply(:decode, [value])

    struct
  end

  def decode({_key, %{__typename: object} = value}, struct) do
    "Elixir.ShopiQL.Objects.#{object}"
    |> String.to_existing_atom()
    |> apply(:decode, [value])

    struct
  end

  def decode({key, value}, struct) do
    %{struct | key => value}
  end
end
