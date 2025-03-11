defmodule TypstApp.Repo do
  use Ecto.Repo,
    otp_app: :typst_app,
    adapter: Ecto.Adapters.Postgres
end
