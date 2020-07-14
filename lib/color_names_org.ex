defmodule ColorNamesOrg do
  require Logger
  @server ColorNamesOrg.Server
  def start_link(initial_state) do
    Logger.info(fn -> "Starting ColorNamesOrg" end)
    GenServer.start_link(@server, initial_state, name: @server)
  end

  def search(hex_color) do
    GenServer.call(@server, {:search, hex_color})
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end
end
