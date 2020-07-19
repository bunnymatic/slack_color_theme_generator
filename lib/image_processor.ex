defmodule ImageProcessor do
  require Logger
  @server ImageProcessor.Server
  def start_link(initial_state) do
    Logger.info(fn -> "Starting ImageProcessor" end)
    GenServer.start_link(@server, initial_state, name: @server)
  end

  def compute_theme(image_file) do
    GenServer.call(@server, {:compute_theme, image_file})
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
