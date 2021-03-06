defmodule ImageProcessor.Server do
  use GenServer
  alias ImageProcessor.Impl

  def init(initial_state) do
    {:ok, initial_state}
  end

  # - from is {pid, callerId}
  def handle_call({:compute_theme, image_file}, _from, state) do
    theme = image_file |> Impl.compute_theme()
    # Additional error handling could go here
    {:reply, theme, state}
  end
end
