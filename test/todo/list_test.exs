defmodule Todo.ListText do
  use ExUnit.Case, async: true
  doctest Todo.List

  setup do
    list = Todo.List.init

    {:ok, [list: list]}
  end

  test "init returns new Todo.List entry" do
    assert Todo.List.init == %Todo.List{}
  end

  describe "add_entry/2" do
    setup [:add_new_entry]

    test "add_entry adds new entry with id equal to auto_id", %{list: list} do
      assert list.entries[1] == %{date: {2015, 10, 1}, title: "Foo", id: 1}
    end

    test "add_entry bumps auto_id by 1", %{list: list} do
      assert list.auto_id == 2
    end

    defp add_new_entry(%{list: list}) do
      list = Todo.List.add_entry(list, %{date: {2015, 10, 1}, title: "Foo"})

      %{list: list}
    end
  end

  describe "get_entries/1" do
    test "returns empty list for new list", %{list: list} do
      entries = Todo.List.get_entries(list)

      assert entries, []
    end
  end
end
