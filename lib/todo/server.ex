defmodule Todo.Server do
  use GenServer

  ## Public API
  def start_link do
    GenServer.start(__MODULE__, [], [])
  end

  def add_entry(pid, entry = %{date: _date, title: _title}) do
    GenServer.cast(pid, {:add_entry, entry})
  end

  def entries(pid) do
    GenServer.call(pid, :get_entries)
  end

  def entries(pid, date = {_year, _month, _day}) do
    GenServer.call(pid, {:get_entries_for_date, date})
  end

  def get_entry(pid, id) do
    GenServer.call(pid, {:get_entry, id})
  end

  def update_entry(pid, id, update_fun) do
    GenServer.cast(pid, {:update_entry, id, update_fun})
  end

  ## Private API
  def init([]) do
    list = Todo.List.init

    {:ok, list}
  end

  def handle_cast({:add_entry, entry}, list) do
    {:noreply, Todo.List.add_entry(list, entry)}
  end

  def handle_cast({:update_entry, id, update_fun}, list) do
    {:noreply, Todo.List.update_entry(list, id, update_fun)}
  end

  def handle_call(:get_entries, _from, list) do
    {:reply, Todo.List.get_entries(list), list}
  end

  def handle_call({:get_entries_for_date, date}, _from, list) do
    {:reply, Todo.List.get_entries(list, date), list}
  end

  def handle_call({:get_entry, id}, _from, list) do
    {:reply, Todo.List.get_entry(list, id), list}
  end
end
