defmodule ShopiQL.OperationBuilder do
  alias ShopiQL.Operation
  alias ShopiQL.Field

  alias ShopiQL.Variable

  def query(name, variables, fields) do
    build(:query, name, variables, fields)
  end

  defp build(operation, name, variables, fields) do
    %Operation{
      type: operation,
      name: name,
      fields: fields,
      variables: parse_variables(variables)
    }
  end

  def field(name, args \\ %{}, fields \\ nil) do
    Field.new(:field, name, args, fields)
  end

  def connection(name, args \\ %{}, fields \\ []) do
    Field.new(:connection, name, args, fields)
  end

  defp parse_variables(vars) do
    Enum.map(vars, &parse_variable/1)
  end

  defp parse_variable({name, type}) do
    %Variable{name: name, type: type}
  end
end
