defmodule ColorNamesOrg.Server do
  use GenServer
  alias ColorNamesOrg.Impl

  def init(initial_state) do
    {:ok, initial_state}
  end

  def handle_call({:search, hex_color}, _from, state) do
    color_name = hex_color |> Impl.search()
    {:reply, color_name, state}
  end
end
