defmodule ShopiQL.Client do
  alias ShopiQL.Operation
  alias ShopiQL.Encoder
  alias ShopiQL.Response

  @default_headers [
    {"Content-Type", "application/json"},
    {"Accept", "application/json"},
    {"x-shopify-access-token", ""}
  ]

  def execute(%Operation{} = operation, variables) do
    query = Encoder.encode(operation)

    %{
      query: query,
      variables: variables,
      operationName: operation.name
    }
    |> request()
  end

  defp request(body) do
    Req.new(
      method: :post,
      url: "",
      headers: @default_headers,
      json: body
    )
    |> Req.request()
    |> Response.parse()
  end
end
