defmodule Day7 do
  @values ~w(A K Q J T 9 8 7 6 5 4 3 2)
  @hand_types [
    :five_of_a_kind,
    :four_of_a_kind,
    :full_house,
    :full_house,
    :three_of_a_kind,
    :two_par,
    :one_pair,
    :high_card
  ]

  @spec main(String.t()) :: integer()
  def main(file_path) do
    {_status, content} = File.read(file_path)
    content
    |> String.split("\r\n", trim: true)
    |> Enum.map(fn (line) ->
      [hand, bid] = line |> String.split(~r{\s}, trim: true)
      {bid, _} = bid |> Integer.parse()
      hand = hand |> String.graphemes()
      {hand, bid}
    end)
    |> label_by_hand()
    |> Enum.sort(&compare_hands/2)
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn ({{_, _, bid}, index}, acc) ->
      acc + (bid * index)
    end)
  end

  def compare_hands({type_a, value_a, _}, {type_b, value_b, _}) do
    type_index_a = Enum.find_index(@hand_types, &(&1 == type_a))
    type_index_b = Enum.find_index(@hand_types, &(&1 == type_b))
    case type_index_a == type_index_b do
      true -> compare_values(value_a, value_b)
      false -> type_index_a > type_index_b
    end
  end

  def compare_values([], []) do true end
  def compare_values([a | a_rest], [b | b_rest]) do
    value_b = Enum.find_index(@values, &(&1 == b))
    value_a = Enum.find_index(@values, &(&1 == a))
    case value_a == value_b do
      true -> compare_values(a_rest, b_rest)
      false -> value_a > value_b
    end
  end

  def label_by_hand(hands, labelled_hands \\ [])
  def label_by_hand([], labelled_hands) do labelled_hands end
  def label_by_hand(hands, labelled_hands) when hands !== [] do
    [{hand, bid} | rest] = hands
    label = hand
    |> Enum.frequencies
    |> Enum.to_list
    |> label_by_frequencies

    rest |> label_by_hand([{label, hand, bid} | labelled_hands])
  end

  def label_by_frequencies(frequencies) do
    index = [[5], [4], [3, 2], [2, 3], [3], [2, 2], [2], [1]]
    |> Enum.find_index(fn counts -> contains_counts(frequencies, counts) end)

    @hand_types |> Enum.at(index)
  end

  def contains_counts(_frequencies, []) do true end
  def contains_counts(frequencies, [desired_count | rest_of_desired]) do
    found = frequencies
    |> Enum.with_index
    |> Enum.find(fn {{_, count}, _index} -> count === desired_count end)
    case found do
      {_, index} ->
        frequencies
        |> Enum.slice(index + 1, 5)
        |> contains_counts(rest_of_desired)
      nil -> false
    end
  end
end
