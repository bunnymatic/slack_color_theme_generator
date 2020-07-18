defmodule ImageProcessor do
  @server ImageProcessor.Server
  def start_link(initial_state) do
    IO.puts("Starting image processor with #{initial_state}")
    IO.puts(__MODULE__)
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
