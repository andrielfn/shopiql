defmodule Examples do
  import ShopiQL.OperationBuilder

  def double_query do
    query("DoubleQuery", %{id: "ID!", query: "String!"}, [
      field(:order, %{id: :"$id"}, [
        field(:__typename),
        field(:id),
        field(:name),
        field(:shippingAddress, %{}, [
          field(:__typename),
          field(:address1)
        ]),
        connection(:lineItems, %{}, [
          field(:id)
        ])
      ]),
      connection(:fulfillmentOrders, %{query: :"$query", first: 5}, [
        field(:__typename),
        field(:id)
      ])
    ])
  end

  def single_query do
    query("SingleQuery", %{id: "ID!"}, [
      field(:order, %{id: :"$id"}, [
        field(:__typename),
        field(:id),
        field(:name),
        field(:shippingAddress, %{}, [
          field(:__typename),
          field(:address1)
        ]),
        connection(:lineItems, %{}, [
          field(:__typename),
          field(:id),
          field(:sku)
        ])
      ])
    ])
  end

  def example2 do
    query("FulfillmentOrdersByLocationId", %{query: "String!"}, [
      connection(:fulfillmentOrders, %{query: :"$query", first: 5}, [
        field(:id)
      ])
    ])
  end
end
