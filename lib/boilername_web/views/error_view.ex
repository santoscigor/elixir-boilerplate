defmodule BoilerNameWeb.ErrorView do
  use BoilerNameWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  def render("400.json", %{error: error}) do
    %{errors: [error]}
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
