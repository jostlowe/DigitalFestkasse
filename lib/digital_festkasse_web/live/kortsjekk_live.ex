defmodule DigitalFestkasseWeb.KortsjekkLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use DigitalFestkasseWeb, :live_view
  require Logger
  alias DigitalFestkasseWeb.{KryssesideLive, KortregistreringLive}

  def mount(_params, %{}, socket) do
    {:ok, socket}
  end

  def handle_event("sjekk_kortnummer", %{"kortnummer" => kortnummer}, socket) do
    Logger.debug("Sjekker kortnummer #{kortnummer}")

    # Sjekk kortnummer mot RegiWeb her og hent konto_id
    konto_id = 123

    {:noreply,
     redirect(socket,
       to: Routes.live_path(socket, KryssesideLive, konto_id: konto_id)
     )}

    {:noreply,
     redirect(socket,
       to: Routes.live_path(socket, KortregistreringLive, kortnummer: kortnummer)
     )}
  end
end
