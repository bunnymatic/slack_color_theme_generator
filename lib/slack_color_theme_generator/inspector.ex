defmodule Inspector do

  defmacro __using__(_) do
    quote do
      defp inspector(v,s), do: (IO.puts("[#{s}] #{inspect(v)}"); v)
      defp inspector(v), do: (IO.puts("[check] #{inspect(v)}"); v)
    end
  end

end
