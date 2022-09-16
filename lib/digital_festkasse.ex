defmodule DigitalFestkasse do
  require Logger

  @root_address "https://regi.samfundet.no/intern/festkassen/digitalkryss"
  @secret "bp5AN6ohKlpR0cP27Jmy"

  def hent_konto(kortnummer) do
    Logger.debug("Henter konto_id og navn for kortnummer #{kortnummer}")

    request =
      HTTPoison.get(
        @root_address <> "/konto",
        [],
        params: %{"kortnummer" => kortnummer}
      )

    case request do
      {:error, _} ->
        :error

      {:ok, response} ->
        Jason.decode(response.body)
    end
  end

  def oppdater_kortnummer(brukernavn, passord, kortnummer) do
    json =
      Jason.encode!(%{
        brukernavn: brukernavn,
        passord: passord,
        kortnummer: kortnummer,
        secret: @secret
      })

    HTTPoison.post(@root_address <> "/konto", json)
  end

  def registrer_kryss(konto_id, sum) do
    json =
      Jason.encode!(%{
        sum: -sum,
        konto_id: konto_id,
        secret: @secret
      })

    HTTPoison.post(@root_address <> "/kryss", json)
  end
end
