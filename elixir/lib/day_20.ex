defmodule Day20 do
  # QUEUE = [{:low, "broadcaster"}]
  # broadcaster -> a, b, c
  # QUEUE = [{:low, "a"}, {:low, "b"}, {:low, "c"}]

  def main(file_path) do
    {_, content} = File.read(file_path)
    module_map = content
    |> String.split("\r\n")
    |> create_module_map()
    |> init_conjunction_inputs()

    {queue, signal_state} = init_state()

    {_, signal_state} = (1..1000)
    |> Enum.to_list()
    |> Enum.reduce({module_map, signal_state}, fn (_, {module_map, signal_state}) ->
      process_signal(queue, module_map, signal_state)
    end)

    signal_state |> Map.values() |> Enum.reduce(1, fn (state, acc) ->
      acc * state
    end)
  end

  def create_module_map(rows) do
    rows
    |> Enum.reduce(%{}, fn (row, map) ->
      [name, outputs] = row |> String.split(" -> ")
      outputs = outputs |> String.split(", ")
      {prefix, name} = name |> String.split_at(1)
      {name, module} = case prefix do
        "%" -> {name, {:flip_flop, outputs, :low}}
        "&" -> {name, {:conjunction, outputs, %{}}}
        _ -> {"broadcaster", {:broadcaster, outputs, nil}}
      end
      map |> Map.put(name, module)
    end)
  end

  def init_conjunction_inputs(module_map) do
    module_map
    |> Map.keys()
    |> Enum.reduce(module_map, fn (key, module_map) ->
      {_type, outputs, _inputs} = module_map |> Map.get(key)
      outputs |> Enum.reduce(module_map, fn (output, module_map) ->
        case module_map |> Map.get(output) do
          {:conjunction, outputs, inputs} ->
            inputs = inputs |> Map.put(key, :low)
            new_module = {:conjunction, outputs, inputs}
            module_map |> Map.put(output, new_module)
          _ -> module_map
        end
      end)
    end)
  end

  def init_state() do
    queue = [{:low, nil, "broadcaster"}]
    signal_state = %{:low => 0, :high => 0}
    {queue, signal_state}
  end

  def process_signal([], module_map, signal_state) do
    {module_map, signal_state}
  end
  def process_signal(queue, module_map, signal_state) do
    [signal | rest] = queue
    {signal_type, _sender, receiver} = signal

    old_count = signal_state |> Map.get(signal_type)
    signal_state = signal_state |> Map.put(signal_type, old_count + 1)


    case module_map |> Map.get(receiver) do
      nil -> process_signal(rest, module_map, signal_state)
      module ->
        {queue, module_map} = case module do
          {:flip_flop, _, _} ->
            process_flip_flop(signal, module, rest, module_map)
          {:conjunction, _, _} ->
            process_conjunction(signal, module, rest, module_map)
          {:broadcaster, _, _} ->
            process_broadcast(signal, module, rest, module_map)
        end

        process_signal(queue, module_map, signal_state)
    end
  end

  def process_flip_flop(signal, module, queue, module_map) do
    {signal_type, _sender, receiver} = signal
    {_, outputs, state} = module

    case signal_type do
      :high -> {queue, module_map}
      :low ->
        new_state = if state === :low, do: :high, else: :low
        new_module = {:flip_flop, outputs, new_state}
        module_map = module_map |> Map.put(receiver, new_module)

        new_signals = outputs |> Enum.map(fn (output) ->
          {new_state, receiver, output}
        end)

        {queue ++ new_signals, module_map}
    end
  end

  def process_conjunction(signal, module, queue, module_map) do
    # TODO: Change other functions to use senders/receivers
    {signal_type, sender, receiver} = signal
    {_, outputs, state} = module

    new_state = state |> Map.put(sender, signal_type)
    new_module = {:conjunction, outputs, new_state}
    module_map = module_map |> Map.put(receiver, new_module)
    all_signals_high? = new_state |> Map.values() |> Enum.all?(&(&1) === :high)

    outgoing_signal_type = if all_signals_high?, do: :low, else: :high
    new_signals = outputs |> Enum.map(fn (output) ->
      {outgoing_signal_type, receiver, output}
    end)

    {queue ++ new_signals, module_map}
  end


  def process_broadcast(signal, module, queue, module_map) do
    {signal_type, _sender, receiver} = signal
    {_, outputs, _} = module

    new_signals = outputs |> Enum.map(fn (output) ->
      {signal_type, receiver, output}
    end)
    {queue ++ new_signals, module_map}
  end
end
