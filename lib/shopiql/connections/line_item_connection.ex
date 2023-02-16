defmodule ShopiQL.Connections.LineItemConnection do
  defimpl Enumerable do
    def count(_), do: {:error, __MODULE__}
    def member?(_, _), do: {:error, __MODULE__}
    def slice(_), do: {:error, __MODULE__}

    def reduce(%{}, {:halt, acc}, _fun), do: {:halted, acc}

    def reduce(%{} = connection, {:suspend, acc}, fun) do
      {:suspended, acc, &reduce(connection, &1, fun)}
    end

    def reduce(%{nodes: [], pageInfo: %{haxNextPage: false}}, {:cont, acc}, _fun) do
      {:done, acc}
    end

    def reduce(%{nodes: [], pageInfo: pageInfo} = connection, {:cont, acc}, fun) do
      # TODO: perform next page call
    end

    def reduce(%{nodes: [head | tail]} = connection, {:cont, acc}, fun) do
      reduce(%{connection | nodes: tail}, fun.(head, acc), fun)
    end
  end

  defstruct [:__typename, :nodes, :pageInfo]

  def decode(result) do
    Enum.reduce(result, %__MODULE__{}, &decode/2)
    |> Stream.each(& &1)
  end

  def decode({:edges, nodes}, struct) do
    nodes = Enum.map(nodes, &decode_node/1)

    %{struct | nodes: nodes}
  end

  def decode({key, value}, struct) do
    %{struct | key => value}
  end

  def decode_node(%{node: %{__typename: object} = value}) do
    "Elixir.ShopiQL.Objects.#{object}"
    |> String.to_existing_atom()
    |> apply(:decode, [value])
  end
end
