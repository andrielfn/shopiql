defmodule ShopiQL.Operation do
  @enforce_keys [:type, :name, :fields]
  defstruct [:type, :name, :fields, :variables]

  @type t :: %__MODULE__{
          type: :query | :mutation,
          name: String.t(),
          fields: [Node.t()],
          variables: [Variable.t()] | nil
        }
end
