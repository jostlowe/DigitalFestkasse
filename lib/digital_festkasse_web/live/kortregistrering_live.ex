defmodule DigitalFestkasseWeb.KortregistreringLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use DigitalFestkasseWeb, :live_view
  require Logger
  alias DigitalFestkasseWeb.KryssesideLive

  @reset_time 30
  def mount(%{"kortnummer" => kortnummer}, %{}, socket) do
    :timer.send_interval(1000, :reset_timer_tick)

    socket =
      assign(socket,
        reset_timer: @reset_time,
        kortnummer: kortnummer,
        registrering_godkjent: false
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

  def handle_event("registrer_kort", %{"brukernavn" => brukernavn, "passord" => passord}, socket) do
    Logger.debug("Registrerer kort for bruker #{brukernavn}")
    {:noreply, assign(socket, registrering_godkjent: true, reset_timer: 3)}
  end
end
