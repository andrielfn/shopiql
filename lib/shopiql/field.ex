defmodule ShopiQL.Field do
  @enforce_keys [:name]
  defstruct type: nil, name: nil, fields: nil, arguments: nil

  @type name :: String.t() | atom()
  @type type :: :field | :connection

  @type t :: %__MODULE__{
          type: type(),
          name: name(),
          arguments: map() | Keyword.t(),
          fields: [t()]
        }

  def new(:field, name, args, fields) do
    %__MODULE__{
      type: :field,
      name: name,
      arguments: args,
      fields: fields
    }
  end

  def new(:connection, name, args, fields) do
    %__MODULE__{
      type: :field,
      name: name,
      arguments: Map.merge(%{first: 15}, args),
      fields: [
        new(:field, :__typename, %{}, []),
        new(:field, :edges, %{}, [
          new(:field, :node, %{}, fields)
        ]),
        new(:field, :pageInfo, %{}, [
          new(:field, :__typename, %{}, []),
          new(:field, :startCursor, %{}, []),
          new(:field, :endCursor, %{}, []),
          new(:field, :hasNextPage, %{}, []),
          new(:field, :hasPreviousPage, %{}, [])
        ])
      ]
    }
  end
end
