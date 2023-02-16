defmodule ShopiQL.Encoder do
  alias ShopiQL.Operation
  alias ShopiQL.Variable
  alias ShopiQL.Field

  def encode(%Operation{} = operation) do
    indentation = 2

    [
      "#{operation.type} #{operation.name}#{variables(operation.variables)}",
      " {\n",
      fields(operation.fields, indentation),
      "\n}"
    ]
    |> Enum.join()
  end

  defp variables(nil), do: nil

  defp variables(variables) do
    [
      "(",
      variables |> Enum.map(&encode_variable/1) |> Enum.join(", "),
      ")"
    ]
    |> Enum.join()
  end

  defp encode_variable(%Variable{} = var) do
    ["$", var.name, ": ", var.type]
    |> Enum.join()
  end

  defp fields(nil, _), do: ""
  defp fields([], _), do: ""

  defp fields(fields, indentation) do
    fields
    |> Enum.map(&encode_field(&1, indentation))
    |> Enum.join("\n")
  end

  defp encode_field(%Field{} = field, indentation) do
    has_arguments? = valid?(field.arguments)
    has_fields? = valid?(field.fields)

    [
      String.duplicate(" ", indentation),
      # encode_field_alias(field.alias),
      field.name,
      if(has_arguments?, do: encode_arguments(field.arguments)),
      if(has_fields?, do: " {\n"),
      fields(field.fields, indentation + 2),
      if(has_fields?, do: "\n"),
      if(has_fields?, do: String.duplicate(" ", indentation)),
      if(has_fields?, do: "}")
    ]
    |> Enum.join()
  end

  # defp encode_field(%Connection{} = connection, indentation) do
  #   has_arguments? = valid?(connection.arguments)
  #   has_fields? = valid?(connection.fields)

  #   [
  #     String.duplicate(" ", indentation),
  #     connection.name,
  #     if(has_arguments?, do: encode_arguments(connection.arguments)),
  #     " {\n",
  #     indent("edges {\n", indentation + 2),
  #     if(has_fields?, do: indent("nodes {\n", indentation + 4)),
  #     fields(connection.fields, indentation + 6),
  #     if(has_fields?, do: "\n"),
  #     if(has_fields?, do: indent("}\n", indentation + 4)),
  #     indent("}\n", indentation + 2),
  #     indent("}", indentation)
  #   ]
  #   |> Enum.join()
  # end

  defp indent(value, indentation), do: "#{String.duplicate(" ", indentation)}#{value}"

  def encode_arguments(nil), do: ""

  def encode_arguments([]), do: ""

  def encode_arguments(map_or_keyword) do
    vars =
      map_or_keyword
      |> Enum.map(&encode_argument/1)
      |> Enum.join(", ")

    "(#{vars})"
  end

  def encode_argument({key, value}) do
    "#{key}: #{encode_value(value)}"
  end

  defp encode_value(v) do
    cond do
      is_binary(v) ->
        "\"#{v}\""

      is_list(v) ->
        v
        |> Enum.map(&encode_value/1)
        |> Enum.join()

      is_map(v) ->
        parsed_v =
          v
          |> Enum.map(&encode_argument/1)
          |> Enum.join(", ")

        Enum.join(["{", parsed_v, "}"])

      true ->
        case v do
          {:enum, v} -> v
          v -> "#{v}"
        end
    end
  end

  defp valid?(nil), do: false
  defp valid?([]), do: false
  defp valid?(a_map) when is_map(a_map), do: a_map != %{}
  defp valid?(_), do: true
end
