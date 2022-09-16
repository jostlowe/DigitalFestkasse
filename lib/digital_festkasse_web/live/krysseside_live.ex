defmodule DigitalFestkasseWeb.KryssesideLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use DigitalFestkasseWeb, :live_view
  require Logger

  @reset_time 30

  def mount(%{"konto_id" => konto_id}, %{}, socket) do
    Logger.debug("Åpnet krysseside med konto_id #{konto_id}")
    :timer.send_interval(1000, :reset_timer_tick)

    socket =
      assign(socket,
        sum: 0,
        reset_timer: @reset_time,
        konto_id: konto_id,
        kryss_godkjent: false
      )

    {:ok, socket}
  end

  def handle_info(:reset_timer_tick, socket) do
    if socket.assigns.reset_timer > 0 do
      {:noreply, update(socket, :reset_timer, fn timer -> timer - 1 end)}
    else
      {:noreply, redirect(socket, to: "/")}
    end
  end

  def handle_event("oppdater_sum", %{"pris" => pris}, socket) do
    socket = update(socket, :sum, fn sum -> sum + String.to_integer(pris) end)
    Logger.debug("Sum oppdatert til #{socket.assigns.sum}")
    {:noreply, socket}
  end

  def handle_event("oops", _, socket) do
    {:noreply, redirect(socket, to: "/")}
  end

  def handle_event("kryss", _, socket) do
    # Registrer kryssene i databasen her
    if socket.assigns.sum > 0 do
      {:ok, _} = DigitalFestkasse.registrer_kryss(socket.assigns.konto_id, socket.assigns.sum)
      kryss_godkjent = true
      {:noreply, assign(socket, reset_timer: 3, kryss_godkjent: kryss_godkjent)}
    else
      {:noreply, socket}
    end
  end
end
