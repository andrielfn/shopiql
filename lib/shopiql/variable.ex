defmodule ShopiQL.Variable do
  defstruct name: nil, type: nil

  @type name() :: String.t() | atom()

  @type t :: %__MODULE__{
          name: name(),
          type: name()
        }
end
