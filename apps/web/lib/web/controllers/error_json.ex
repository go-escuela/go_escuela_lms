defmodule Web.ErrorJSON do
  # If you want to customize a particular status code,
  # you may add your own clauses, such as:
  #
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render("401.json", _assigns) do
    %{errors: %{detail: "invalid credentials"}}
  end

  def render("403.json", _assigns) do
    %{errors: %{detail: "Forbidden resource"}}
  end

  def render("422.json", %{error: error}) do
    %{errors: %{detail: error}}
  end

  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
