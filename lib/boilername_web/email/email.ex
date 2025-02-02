defmodule BoilerNameWeb.Email do
  use Bamboo.Phoenix, view: BoilerNameWeb.EmailView

  def confirmation_email(token, user) do
    base_email()
    |> to(user.email)
    |> subject("Confirmation link")
    |> assign(:user, user)
    |> assign(:token, token)
    |> render(:confirmation)
  end

  def forgot_password_email(token, user) do
    base_email()
    |> to(user.email)
    |> subject("Password reset link")
    |> assign(:user, user)
    |> assign(:token, token)
    |> render(:forgot_password)
  end

  def base_email do
    new_email()
    |> from("hey@boilername.com")
    |> put_html_layout({BoilerNameWeb.LayoutView, "email.html"})
  end
end
