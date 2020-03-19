defmodule UserServiceWeb.PowAssent.RegistrationView do
  use UserServiceWeb, :view

  def provider_message(%{params: %{"provider" => "github"}}), do: "with Github."
  def provider_message(_), do: "."

  def email_taken?(%{errors: errors}) do
    Enum.find(errors, fn
      {:email, {_, [{:constraint, :unique}, _]}} -> true
      _ -> false
    end)
  end
end
