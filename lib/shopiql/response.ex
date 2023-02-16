defmodule ShopiQL.Response do
  def parse({:ok, %Req.Response{body: body}}) do
    body
    |> decode()
  end

  defp decode(%{"data" => data}) do
    data
    |> Jason.encode!()
    |> Jason.decode!(keys: :atoms)
    |> Enum.map(&decode/1)
    |> Enum.into(%{})
  end

  defp decode({operation_name, %{__typename: connection} = result}) when is_map_key(result, :edges) do
    {operation_name,
     "Elixir.ShopiQL.Connections.#{connection}"
     |> String.to_existing_atom()
     |> apply(:decode, [result])}
  end

  defp decode({operation_name, %{__typename: object} = result}) do
    {operation_name,
     "Elixir.ShopiQL.Objects.#{object}"
     |> String.to_existing_atom()
     |> apply(:decode, [result])}
  end
end
