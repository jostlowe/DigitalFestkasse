defmodule DigitalFestkasse do
  require Logger

  @root_address "https://regi.samfundet.no/intern/festkassen/digitalkryss"
  @secret "bp5an6ohklpr0cp27jmy"

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
        {:error, "Kunne ikke koble til Regiweb. Er nettverket nede?"}

      {:ok, %{status_code: 200, body: body}} ->
        Jason.decode(body)

      {:ok, %{status_code: 404}} ->
        :ingen_konto

      {:ok, %{status_code: _, body: body}} ->
        {:error, "Feilmelding fra RegiWeb: #{body}"}
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

    request = HTTPoison.post(@root_address <> "/konto", json)

    case request do
      {:error, _} ->
        {:error, "Kunne ikke koble til Regiweb. Er nettverket nede?"}

      {:ok, %{status_code: 200}} ->
        :ok

      {:ok, %{status_code: _, body: body}} ->
        {:error, "Feilmelding fra RegiWeb: #{body}"}
    end
  end

  def registrer_kryss(konto_id, sum) do
    json =
      Jason.encode!(%{
        sum: -sum,
        konto_id: konto_id,
        secret: @secret
      })

    request = HTTPoison.post(@root_address <> "/kryss", json)

    case request do
      {:error, _} ->
        {:error, "Kunne ikke koble til Regiweb. Er nettverket nede?"}

      {:ok, %{status_code: 200}} ->
        :ok

      {:ok, %{status_code: _, body: body}} ->
        {:error, "Feilmelding fra RegiWeb: #{body}"}
    end
  end
end
