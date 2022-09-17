defmodule DigitalFestkasseWeb.KortsjekkLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use DigitalFestkasseWeb, :live_view
  require Logger
  alias DigitalFestkasseWeb.{KryssesideLive, KortregistreringLive, FeilsideLive}

  def mount(_params, %{}, socket) do
    {:ok, socket}
  end

  def handle_event("sjekk_kortnummer", %{"kortnummer" => kortnummer}, socket) do
    Logger.debug("Sjekker kortnummer #{kortnummer}")

    case DigitalFestkasse.hent_konto(kortnummer) do
      :ingen_konto ->
        {:noreply, KortregistreringLive.redirect_to(socket, kortnummer)}

      {:ok, %{"konto_id" => konto_id, "navn" => navn, "saldo" => saldo}} ->
        if String.to_float(saldo) < 0 do
          {:noreply, FeilsideLive.redirect_to(socket, "Du er svart!")}
        else
          {:noreply, KryssesideLive.redirect_to(socket, konto_id, navn, saldo)}
        end
    end
  end
end
