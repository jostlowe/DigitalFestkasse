defmodule DigitalFestkasseWeb.KortregistreringLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use DigitalFestkasseWeb, :live_view
  require Logger
  alias DigitalFestkasseWeb.KryssesideLive

  @reset_time 30
  def mount(%{"kortnummer" => kortnummer}, %{}, socket) do
    socket =
      assign(socket,
        reset_timer: @reset_time,
        kortnummer: kortnummer,
        registrering_godkjent: false
      )

    {:ok, socket}
  end

  def handle_info(:reset, socket) do
    {:noreply, redirect(socket, to: "/")}
  end

  def handle_event("registrer_kort", %{"brukernavn" => brukernavn, "passord" => passord}, socket) do
    Logger.debug("Registrerer kort for bruker #{brukernavn}")

    {:ok, wolol} =
      DigitalFestkasse.oppdater_kortnummer(brukernavn, passord, socket.assigns.kortnummer)

    Logger.debug("fikk svar #{wolol}")

    :timer.send_after(3000, :reset)
    {:noreply, assign(socket, registrering_godkjent: true)}
  end
end
