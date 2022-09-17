defmodule DigitalFestkasseWeb.FeilsideLive do
  # In Phoenix v1.6+ apps, the line below should be: use MyAppWeb, :live_view
  use DigitalFestkasseWeb, :live_view
  require Logger
  alias DigitalFestkasseWeb.{KryssesideLive, KortregistreringLive, FeilsideLive}

  @reset_time 5
  def mount(%{"feilmelding" => feilmelding}, %{}, socket) do
    :timer.send_interval(1000, :reset_timer_tick)
    {:ok, assign(socket, feilmelding: feilmelding, reset_timer: @reset_time)}
  end

  def handle_info(:reset_timer_tick, socket) do
    if socket.assigns.reset_timer > 0 do
      {:noreply, update(socket, :reset_timer, fn timer -> timer - 1 end)}
    else
      {:noreply, redirect(socket, to: "/")}
    end
  end

  def redirect_to(socket, feilmelding) do
    redirect(socket,
      to: Routes.live_path(socket, FeilsideLive, feilmelding: feilmelding)
    )
  end
end
