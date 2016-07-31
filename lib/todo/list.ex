defmodule Todo.List do
  @doc ~S"""
  Handles CRU operations on todo list

  ## Examples
      iex> Todo.List.init
      %Todo.List{ auto_id: 1, entries: HashDict.new }

      iex> Todo.List.add_entry(%Todo.List{}, %{date: {2013, 10, 1}, title: "Dentist"})
      %Todo.List{auto_id: 2, entries: HashDict.put(HashDict.new, 1, %{date: {2013, 10, 1}, id: 1, title: "Dentist"})}

  """
  defstruct entries: HashDict.new, auto_id: 1

  def init do
    %__MODULE__{}
  end

  ## Public API
  def add_entry(%__MODULE__{entries: entries, auto_id: auto_id}, entry = %{date: _date, title: _title}) do
    entry = Map.put(entry, :id, auto_id)
    new_entries = HashDict.put(entries, auto_id, entry)

    %__MODULE__{entries: new_entries, auto_id: auto_id + 1}
  end

  def get_entries(%__MODULE__{entries: entries}) do
    entries_from_struct(entries)
  end

  def get_entries(%__MODULE__{entries: entries}, date = {_year, _month, _day}) do
    entries
    |> Stream.filter(fn({_, entry}) -> entry.date == date end)
    |> entries_from_struct
  end

  def get_entry(%__MODULE__{entries: entries}, id) do
    entries[id]
  end

  def update_entry(%__MODULE__{entries: entries} = list, id, update_fun) do
    case entries[id] do
      nil -> list
      old_entry ->
        new_entry = update_fun.(old_entry)
        new_entries = HashDict.put(entries, id, new_entry)
        %__MODULE__{list | entries: new_entries}
    end
  end

  defp entries_from_struct(entries) do
    Enum.map(entries, fn({_, entry}) -> entry end)
  end
end
