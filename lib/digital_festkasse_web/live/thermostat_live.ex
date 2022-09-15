defmodule DigitalFestkasseWeb.ThermostatLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use DigitalFestkasseWeb, :live_view

  def mount(_params, %{}, socket) do
    :timer.send_interval(1000, :wolol)
    {:ok, assign(socket, :temperature, 3)}
  end

  def handle_info(:wolol, socket) do
    socket = update(socket, :temperature, fn x -> x + 1 end)
    {:noreply, socket}
  end

  def handle_event("zoop", %{"poop" => poop}, socket) do
    String.to_integer(poop) |> IO.puts()
    {:noreply, socket}
  end
end
